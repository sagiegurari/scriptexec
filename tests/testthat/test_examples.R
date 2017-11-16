context("examples")

describe("examples", {
    source("helper.R")
    
    it("all examples", {
        # execute script text
        output <- scriptexec::execute("echo Current Directory:\ndir")
        expect_equal(output$status, 0)
        expect_equal(is_string_exists("test_examples.R", output$output), TRUE)
        
        # execute multiple commands as a script
        output <- scriptexec::execute(c("cd", "echo User Home:", "dir"))
        expect_equal(output$status, 0)
        
        # pass argument to the script, later defined as ARG1
        output <- execute(c("echo $ARG1 $ARG2"), args = c("TEST1", "TEST2"))
        expect_equal(output$status, 0)
        expect_equal(is_string_exists("TEST1 TEST2", output$output), TRUE)
        
        # non zero status code is returned in case of errors
        expect_warning(output <- scriptexec::execute("exit 1"))
        expect_equal(output$status, 1)
    })
})
