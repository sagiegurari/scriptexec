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

    output <- scriptexec::script_execute(c("echo ", arg), c("TEST"))
    expect_equal(output$status, NULL)
    position = regexpr('TEST', output$output)
    found = FALSE
    if (position > 0) {
        found = TRUE
    }
    expect_equal(found, TRUE)
})

test_that("script_execute error exit code", {
    output <- scriptexec::script_execute("exit 1")
    expect_equal(output$status, 1)
})
