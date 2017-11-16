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
        
        it("args as second parameter as text", {
            command <- get_os_string("echo $ARG1", "echo %ARG1%")
            
            output <- scriptexec::execute(command, "TEST_R")
            expect_equal(output$status, 0)
            
            found <- is_string_exists("TEST_R", output$output)
            expect_true(found)
        })
        
        it("args as second parameter as vector", {
            command <- get_os_string("echo $ARG1", "echo %ARG1%")
            
            output <- scriptexec::execute(command, c("TEST_R"))
            expect_equal(output$status, 0)
            
            found <- is_string_exists("TEST_R", output$output)
            expect_true(found)
        })
        
        it("args as named parameter", {
            command <- get_os_string("echo $ARG1", "echo %ARG1%")
            
            output <- scriptexec::execute(command, args = "TEST_R")
            expect_equal(output$status, 0)
            
            found <- is_string_exists("TEST_R", output$output)
            expect_true(found)
        })
        
        it("env vars as third paramter as text", {
            command <- get_os_string("echo $ENV_TEST", "echo %ENV_TEST%")
            
            output <- scriptexec::execute(command, NULL, "ENV_TEST=MYENV")
            windows <- scriptexec::is_windows()
            expect_equal(output$status, 0)
            
            found <- is_string_exists("MYENV", output$output)
            expect_equal(found, !windows)
        })
        
        it("env vars as third paramter as vector", {
            command <- get_os_string("echo $ENV_TEST", "echo %ENV_TEST%")
            
            output <- scriptexec::execute(command, NULL, c("ENV_TEST=MYENV"))
            windows <- scriptexec::is_windows()
            expect_equal(output$status, 0)
            
            found <- is_string_exists("MYENV", output$output)
            expect_equal(found, !windows)
        })
        
        it("env vars as named paramter", {
            command <- get_os_string("echo $ENV_TEST", "echo %ENV_TEST%")
            
            output <- scriptexec::execute(command, env = c("ENV_TEST=MYENV"))
            windows <- scriptexec::is_windows()
            expect_equal(output$status, 0)
            
            found <- is_string_exists("MYENV", output$output)
            expect_equal(found, !windows)
        })
        
        it("args and env vars as paramters", {
            command <- get_os_string("echo $ARG1 $ENV_TEST", "echo %ARG1% %ENV_TEST%")
            
            output <- scriptexec::execute(command, "TEST_ARG", c("ENV_TEST=MYENV"))
            windows <- scriptexec::is_windows()
            expect_equal(output$status, 0)
            
            found <- is_string_exists("TEST_ARG MYENV", output$output)
            expect_equal(found, !windows)
        })
        
        it("args and env vars as named paramters", {
            command <- get_os_string("echo $ARG1 $ENV_TEST", "echo %ARG1% %ENV_TEST%")
            
            output <- scriptexec::execute(command, args = "TEST_ARG", env = c("ENV_TEST=MYENV"))
            windows <- scriptexec::is_windows()
            expect_equal(output$status, 0)
            
            found <- is_string_exists("TEST_ARG MYENV", output$output)
            expect_equal(found, !windows)
        })
    })
    
    describe("examples", {
        it("all examples", {
            # execute script text
            output <- scriptexec::execute("echo Current Directory:\ndir")
            expect_equal(output$status, 0)
            expect_equal(is_string_exists("test_api_stability.R", output$output), 
                TRUE)
            
            # execute multiple commands as a script
            output <- scriptexec::execute(c("cd", "echo User Home:", "dir"))
            expect_equal(output$status, 0)
            
            # pass arguments to the script, later defined as ARG1, ARG2, ...
            command <- get_os_string("echo $ARG1 $ARG2", "echo %ARG1% %ARG2%")
            output <- execute(command, args = c("TEST1", "TEST2"))
            expect_equal(output$status, 0)
            expect_equal(is_string_exists("TEST1 TEST2", output$output), TRUE)
            
            # non zero status code is returned in case of errors
            expect_warning(output <- scriptexec::execute("exit 1"))
            expect_equal(output$status, 1)
        })
    })
})
