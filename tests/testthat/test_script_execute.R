library(scriptexec)
context("execute")

test_that("execute valid exit code", {
    output <- scriptexec::execute("exit 0")
    expect_equal(output$status, 0)
})

test_that("execute valid command", {
    output <- scriptexec::execute("dir")
    expect_equal(output$status, 0)
})

test_that("execute valid commands", {
    output <- scriptexec::execute(c("dir", "cd", "dir"))
    expect_equal(output$status, 0)
})

test_that("execute cli arguments is NULL", {
    output <- scriptexec::execute("exit 0", args = NULL)
    expect_equal(output$status, 0)
})

test_that("execute cli arguments", {
    arg <- "$ARG1"
    if (.Platform$OS.type == "windows") {
        arg <- "%ARG1%"
    }
    
    output <- scriptexec::execute(paste("echo", arg, sep = " "), c("TEST_R"))
    expect_equal(output$status, 0)
    position <- regexpr("TEST_R", output$output)
    found <- FALSE
    if (position > 0) {
        found <- TRUE
    }
    expect_equal(found, TRUE)
})

test_that("execute env vars", {
    command <- "echo $ENV_TEST"
    if (.Platform$OS.type == "windows") {
        command <- "echo %ENV_TEST%"
    }
    
    output <- scriptexec::execute(command, env = c("ENV_TEST=MYENV"))
    windows <- scriptexec::is_windows()
    expect_equal(output$status, 0)
    position <- regexpr("MYENV", output$output)
    found <- FALSE
    if (position > 0) {
        found <- TRUE
    }
    expect_equal(found, !windows)
})

test_that("execute error exit code", {
    output <- scriptexec::execute("exit 1")
    expect_equal(output$status, 1)
})
