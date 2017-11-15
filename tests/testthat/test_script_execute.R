library(scriptexec)
context("script_execute")

test_that("script_execute valid exit code", {
    output <- scriptexec::script_execute("exit 0")
    expect_equal(output$status, 0)
})

test_that("script_execute valid command", {
    output <- scriptexec::script_execute("dir")
    expect_equal(output$status, 0)
})

test_that("script_execute valid commands", {
    output <- scriptexec::script_execute(c("dir", "cd", "dir"))
    expect_equal(output$status, 0)
})

test_that("script_execute cli arguments is NULL", {
    output <- scriptexec::script_execute("exit 0", args = NULL)
    expect_equal(output$status, 0)
})

test_that("script_execute cli arguments", {
    arg <- "$ARG1"
    if (.Platform$OS.type == "windows") {
        arg  <- "%ARG1%"
    }

    output <- scriptexec::script_execute(paste("echo", arg, sep = " "), c("TEST_R"))
    expect_equal(output$status, 0)
    position <- regexpr("TEST_R", output$output)
    found <- FALSE
    if (position > 0) {
        found <- TRUE
    }
    expect_equal(found, TRUE)
})

test_that("script_execute env vars", {
    command <- "echo $ENV_TEST"
    if (.Platform$OS.type == "windows") {
        command <- "echo %ENV_TEST%"
    }

    output <- scriptexec::script_execute(command, env = c("ENV_TEST=MYENV"))
    expect_equal(output$status, 0)
    position <- regexpr("MYENV", output$output)
    found <- FALSE
    if (position > 0) {
        found <- TRUE
    }
    expect_equal(found, TRUE)
})

test_that("script_execute error exit code", {
    output <- scriptexec::script_execute("exit 1")
    expect_equal(output$status, 1)
})
