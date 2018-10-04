context("generate_env_setup_script")

describe("generate_env_setup_script", {
    source("helper.R")
    
    it("no env", {
        script <- scriptexec::generate_env_setup_script()
        
        length <- nchar(script)
        
        expect_equal(length, 0)
    })
    
    it("multiple env vars", {
        script <- scriptexec::generate_env_setup_script(c("ENV1=VALUE1", "ENV2=VALUE2"))
        
        found <- grepl("ENV1=VALUE1", script)
        expect_true(found, TRUE)
        
        found <- grepl("ENV2=VALUE2", script)
        expect_true(found, TRUE)
        
        prefix <- get_os_string("export", "SET")
        expected_result <- paste(paste(prefix, "ENV1=VALUE1", sep = " "), paste(prefix, 
            "ENV2=VALUE2", sep = " "), sep = "\n")
        
        expect_equal(expected_result, script)
    })
})
