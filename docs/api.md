

<!-- toc -->

October 13, 2018

# DESCRIPTION


```
Package: scriptexec
Title: Execute Native Scripts
Version: 0.2.3
Authors@R: person("Sagie", "Gur-Ari", email = "sagiegurari@gmail.com", role = c("aut", "cre"))
Description: Run complex native scripts with a single command, similar to system commands.
License: Apache License 2.0
URL: https://github.com/sagiegurari/scriptexec
BugReports: https://github.com/sagiegurari/scriptexec/issues
Depends: R (>= 3.2.3)
Encoding: UTF-8
RoxygenNote: 6.1.0
Suggests: knitr (>= 1.20),
    testthat (>= 2.0.0),
    lintr (>= 1.0.2),
    formatR (>= 1.5),
    devtools (>= 1.13.6),
    Rcpp (>= 0.12.19),
    digest (>= 0.6.17),
    roxygen2 (>= 6.1.0),
    rmarkdown (>= 1.10),
    rversions (>= 1.0.3)
VignetteBuilder: knitr
```


# `execute`

Executes a script and returns the output.
 The stdout and stderr are captured and returned.
 In case of errors, the exit code will return in the status field.

## Description


 Executes a script and returns the output.
 The stdout and stderr are captured and returned.
 In case of errors, the exit code will return in the status field.


## Usage


```r
execute(script = "", args = c(), env = character(), wait = TRUE,
  runner = NULL, print_commands = FALSE, get_runtime_script = FALSE)

```


## Arguments

Argument      |Description
------------- |----------------
`script`     |     The script text
`args`     |     Optional script command line arguments (arguments are added as variables in the script named ARG1, ARG2, ...)
`env`     |     Optional character vector of name=value strings to set environment variables
`wait`     |     A TRUE/FALSE parameter, indicating whether the function should wait for the command to finish, or run it asynchronously (output status will be -1)
`runner`     |     The executable used to invoke the script (by default cmd.exe for windows, sh for other platforms)
`print_commands`     |     True if to print each command before invocation (not available for windows)
`get_runtime_script`     |     True to return the actual invoked script in a script output parameter

## Value


 The process output and status code (in case wait=TRUE) in the form of list(status = status, output = output)


## Examples


```r 
 library("scriptexec")
 library("testthat")
 
 # execute script text
 output <- scriptexec::execute("echo command1\necho command2")
 expect_equal(output$status, 0)
 expect_equal(grepl("command1", output$output), TRUE)
 expect_equal(grepl("command2", output$output), TRUE)
 
 if (.Platform$OS.type == "windows") {
 ls_command <- "dir"
 } else {
 ls_command <- "ls"
 }
 output <- scriptexec::execute(c("echo user home:", ls_command))
 expect_equal(output$status, 0)
 
 # execute multiple commands as a script
 output <- scriptexec::execute(c("cd", "echo test"))
 expect_equal(output$status, 0)
 
 # pass arguments (later defined as ARG1, ARG2, ...) and env vars
 if (.Platform$OS.type == "windows") {
 command <- "echo %ARG1% %ARG2% %MYENV%"
 } else {
 command <- "echo $ARG1 $ARG2 $MYENV"
 }
 output <- scriptexec::execute(command, args = c("TEST1", "TEST2"), env = c("MYENV=TEST3"))
 expect_equal(output$status, 0)
 expect_equal(grepl("TEST1 TEST2 TEST3", output$output), TRUE)
 
 # non zero status code is returned in case of errors
 expect_warning(output <- scriptexec::execute("exit 1"))
 expect_equal(output$status, 1)
 
 # do not wait for command to finish
 output <- scriptexec::execute("echo my really long task", wait = FALSE)
 expect_equal(output$status, -1)

``` 

