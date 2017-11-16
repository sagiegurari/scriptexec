context("modify_script")

describe("modify_script", {
    source("helper.R")
    
    it("no args", {
        script <- scriptexec::modify_script("")
        script <- paste(script, collapse = "\n")
        
        found <- is_string_exists("ARG", script)
        expect_false(found)
    })
    
    it("multiple args", {
        script <- scriptexec::modify_script("", c("test1", "test2"))
        script <- paste(script, collapse = "\n")
        
        found <- is_string_exists("ARG1", script)
        expect_true(found, TRUE)
        
        found <- is_string_exists("ARG2", script)
        expect_true(found)
        
        found <- is_string_exists("ARG3", script)
        expect_false(found)
    })
})
