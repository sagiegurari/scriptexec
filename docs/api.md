

<!-- toc -->

October 07, 2018

# DESCRIPTION


```
Package: scriptexec
Title: Execute Native Scripts
Version: 0.2.2
Authors@R: person("Sagie", "Gur-Ari", email = "sagiegurari@gmail.com", role = c("aut", "cre"))
Description: Run complex native scripts with a single command, similar to system commands.
License: Apache License 2.0
URL: https://github.com/sagiegurari/scriptexec
BugReports: https://github.com/sagiegurari/scriptexec/issues
Depends: R (>= 3.2.3)
Encoding: UTF-8
RoxygenNote: 6.1.0
Suggests: knitr,
    testthat,
    lintr
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
 # execute script text
 output <- execute('echo Current Directory:\ndir')
 cat(sprintf('Exit Status: %s Output: %s\n', output$status, output$output))
 
 # execute multiple commands as a script
 output <- execute(c('cd', 'echo User Home:', 'dir'))
 cat(sprintf('Exit Status: %s Output: %s\n', output$status, output$output))
 
 # pass arguments (later defined as ARG1, ARG2, ...) and env vars
 output <- execute('echo $ARG1 $ARG2', args = c('TEST1', 'TEST2'), env = c('MYENV=TEST3'))
 cat(sprintf('%s\n', output))
 
 # non zero status code is returned in case of errors
 output <- execute('exit 1')
 cat(sprintf('Status: %s\n', output$status))
 cat(sprintf('%s\n', output))
 
 #do not wait for command to finish
 execute('echo my really long task', wait = FALSE)

``` 

