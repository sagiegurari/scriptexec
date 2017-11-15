library(scriptexec)
context("script_execute")

test_that("is_windows", {
    windows <- scriptexec::is_windows()
    expect_equal(windows, .Platform$OS.type == "windows")
})
