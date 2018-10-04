context("API Stability")

describe("API Stability", {
    source("helper.R")
    
    describe("public api", {
        it("string command as named parameter", {
            output <- scriptexec::execute(script = "exit 0")
            expect_equal(output$status, 0)
        })
        
        it("string command", {
            output <- scriptexec::execute("exit 0")
            expect_equal(output$status, 0)
        })
        
        it("vector command", {
            output <- scriptexec::execute(c("cd", "exit 0"))
            expect_equal(output$status, 0)
        })
        
        it("error exit code", {
            expect_warning(output <- scriptexec::execute("exit 1"))
            expect_equal(output$status, 1)
        })
        
        it("args as parameter 2 as text", {
            command <- get_os_string("echo $ARG1", "echo %ARG1%")
            
            output <- scriptexec::execute(command, "TEST_R")
            expect_equal(output$status, 0)
            
            found <- grepl("TEST_R", output$output)
            expect_true(found)
        })
        
        it("args as parameter 2 as vector", {
            command <- get_os_string("echo $ARG1", "echo %ARG1%")
            
            output <- scriptexec::execute(command, c("TEST_R"))
            expect_equal(output$status, 0)
            
            found <- grepl("TEST_R", output$output)
            expect_true(found)
        })
        
        it("args as named parameter", {
            command <- get_os_string("echo $ARG1", "echo %ARG1%")
            
            output <- scriptexec::execute(command, args = "TEST_R")
            expect_equal(output$status, 0)
            
            found <- grepl("TEST_R", output$output)
            expect_true(found)
        })
        
        it("env vars as paramter 3 as text", {
            command <- get_os_string("echo $ENV_TEST", "echo %ENV_TEST%")
            
            output <- scriptexec::execute(command, NULL, "ENV_TEST=MYENV")
            expect_equal(output$status, 0)
            
            found <- grepl("MYENV", output$output)
            expect_equal(found, TRUE)
        })
        
        it("env vars as paramter 3 as vector", {
            command <- get_os_string("echo $ENV_TEST", "echo %ENV_TEST%")
            
            output <- scriptexec::execute(command, NULL, c("ENV_TEST=MYENV"))
            expect_equal(output$status, 0)
            
            found <- grepl("MYENV", output$output)
            expect_equal(found, TRUE)
        })
        
        it("env vars as named paramter", {
            command <- get_os_string("echo $ENV_TEST", "echo %ENV_TEST%")
            
            output <- scriptexec::execute(command, env = c("ENV_TEST=MYENV"))
            expect_equal(output$status, 0)
            
            found <- grepl("MYENV", output$output)
            expect_equal(found, TRUE)
        })
        
        it("wait as parameter 4", {
            output <- scriptexec::execute("exit 0", NULL, NULL, FALSE)
            expect_equal(output$status, -1)
        })
        
        it("wait as named parameter", {
            output <- scriptexec::execute("exit 0", wait = FALSE)
            expect_equal(output$status, -1)
        })
        
        it("runner as parameter 5", {
            runner <- get_os_string("sh", "cmd.exe")
            output <- scriptexec::execute("exit 0", NULL, NULL, TRUE, runner)
            expect_equal(output$status, 0)
        })
        
        it("runner as named parameter", {
            runner <- get_os_string("sh", "cmd.exe")
            output <- scriptexec::execute("exit 0", runner = runner)
            expect_equal(output$status, 0)
        })
        
        it("print_commands as parameter 6", {
            output <- scriptexec::execute("exit 0", NULL, NULL, TRUE, NULL, TRUE)
            expect_equal(output$status, 0)
        })
        
        it("print_commands as named parameter", {
            output <- scriptexec::execute("exit 0", print_commands = TRUE)
            expect_equal(output$status, 0)
        })
        
        it("all paramters", {
            command <- get_os_string("echo $ARG1 $ENV_TEST", "echo %ARG1% %ENV_TEST%")
            runner <- get_os_string("sh", "cmd.exe")
            
            output <- scriptexec::execute(command, "TEST_ARG", c("ENV_TEST=MYENV"), 
                TRUE, runner, TRUE)
            expect_equal(output$status, 0)
            
            found <- grepl("TEST_ARG MYENV", output$output)
            expect_equal(found, TRUE)
            
            output <- scriptexec::execute(command, "TEST_ARG", c("ENV_TEST=MYENV"), 
                FALSE)
            expect_equal(output$status, -1)
        })
        
        it("all named paramters", {
            command <- get_os_string("echo $ARG1 $ENV_TEST", "echo %ARG1% %ENV_TEST%")
            runner <- get_os_string("sh", "cmd.exe")
            
            output <- scriptexec::execute(command, args = "TEST_ARG", env = c("ENV_TEST=MYENV"), 
                wait = TRUE, runner = runner, print_commands = TRUE)
            expect_equal(output$status, 0)
            
            found <- grepl("TEST_ARG MYENV", output$output)
            expect_equal(found, TRUE)
            
            output <- scriptexec::execute(command, args = "TEST_ARG", env = c("ENV_TEST=MYENV"), 
                wait = FALSE)
            expect_equal(output$status, -1)
        })
    })
})
