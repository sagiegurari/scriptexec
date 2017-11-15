library(scriptexec)
context("script_execute")

test_that("modify_script no args", {
    script <- scriptexec::modify_script("")
    script <- paste(script, collapse = "\n")
    
    position <- regexpr("ARG", script)
    found <- FALSE
    if (position > 0) {
        found <- TRUE
    }
    expect_equal(found, FALSE)
})

test_that("modify_script multiple args", {
    script <- scriptexec::modify_script("", c("test1", "test2"))
    script <- paste(script, collapse = "\n")
    
    position <- regexpr("ARG1", script)
    found <- FALSE
    if (position > 0) {
        found <- TRUE
    }
    expect_equal(found, TRUE)
    
    position <- regexpr("ARG2", script)
    found <- FALSE
    if (position > 0) {
        found <- TRUE
    }
    expect_equal(found, TRUE)
    
    position <- regexpr("ARG3", script)
    found <- FALSE
    if (position > 0) {
        found <- TRUE
    }
    expect_equal(found, FALSE)
})
