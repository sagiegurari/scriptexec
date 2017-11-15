library(scriptexec)
context("script_execute")

test_that("script_execute valid exit code", {
    output <- scriptexec::script_execute("exit 0")
    expect_equal(output$status, NULL)
})

test_that("script_execute valid command", {
    output <- scriptexec::script_execute("dir")
    expect_equal(output$status, NULL)
})

test_that("script_execute valid commands", {
    output <- scriptexec::script_execute(c("dir", "cd", "dir"))
    expect_equal(output$status, NULL)
})

test_that("script_execute cli arguments", {
    arg <- "$1"
    if (.Platform$OS.type == "windows") {
        arg  <- "%1"
    }

    output <- scriptexec::script_execute(c("exit", arg), c("10"))
    expect_equal(output$status, 10)
})

test_that("script_execute error exit code", {
    output <- scriptexec::script_execute("exit 1")
    expect_equal(output$status, 1)
})
