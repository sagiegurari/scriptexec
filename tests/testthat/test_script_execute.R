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
        windows <- scriptexec::is_windows()
        expect_equal(output$status, 0)
        
        found <- is_string_exists("MYENV", output$output)
        expect_equal(found, !windows)
    })
    
    it("error exit code", {
        output <- scriptexec::execute("exit 1")
        expect_equal(output$status, 1)
    })
})
