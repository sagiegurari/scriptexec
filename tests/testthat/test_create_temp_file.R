context("create_temp_file")

describe("create_temp_file", {
    source("helper.R")
    
    it("no text", {
        filename <- scriptexec::create_temp_file()
        extension <- get_os_string(".sh", ".bat")
        
        found <- is_string_exists(extension, filename)
        expect_true(found)
        
        text <- readLines(filename)
        expect_equal(text, "")
    })
    
    it("text", {
        filename <- scriptexec::create_temp_file("test123")
        extension <- get_os_string(".sh", ".bat")
        
        found <- is_string_exists(extension, filename)
        expect_true(found)
        
        text <- readLines(filename)
        expect_equal(text, "test123")
    })
})
