context("execute")

describe("execute", {
    source("helper.R")
    
    it("valid exit code", {
        output <- scriptexec::execute("exit 0")
        expect_equal(output$status, 0)
    })
    
    it("valid command", {
        output <- scriptexec::execute("dir")
        expect_equal(output$status, 0)
    })
    
    it("valid commands", {
        output <- scriptexec::execute(c("dir", "cd", "dir"))
        expect_equal(output$status, 0)
    })
    
    it("cli arguments is NULL", {
        output <- scriptexec::execute("exit 0", args = NULL)
        expect_equal(output$status, 0)
    })
    
    it("cli arguments", {
        arg <- get_os_string("$ARG1", "%ARG1%")
        
        output <- scriptexec::execute(paste("echo", arg, sep = " "), c("TEST_R"))
        expect_equal(output$status, 0)
        
        found <- is_string_exists("TEST_R", output$output)
        expect_true(found)
    })
    
    it("env vars", {
        command <- get_os_string("echo $ENV_TEST", "echo %ENV_TEST%")
        
        output <- scriptexec::execute(command, env = c("ENV_TEST=MYENV"))
        expect_equal(output$status, 0)
        
        found <- is_string_exists("MYENV", output$output)
        expect_equal(found, TRUE)
    })
    
    it("error exit code", {
        expect_warning(output <- scriptexec::execute("exit 1"))
        expect_equal(output$status, 1)
    })
    
    it("no wait", {
        output <- scriptexec::execute("dir", wait = FALSE)
        expect_equal(output$status, -1)
    })
    
    it("error exit code with no wait", {
        output <- scriptexec::execute("exit 1", wait = FALSE)
        expect_equal(output$status, -1)
    })
    
    it("runner provided", {
        runner <- get_os_string("sh", "cmd.exe")
        output <- scriptexec::execute("dir", runner = runner)
        expect_equal(output$status, 0)
    })
    
    it("print_commands", {
        output <- scriptexec::execute("dir", print_commands = TRUE)
        expect_equal(output$status, 0)
    })
})
