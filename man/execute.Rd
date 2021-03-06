% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/scriptexec.R
\name{execute}
\alias{execute}
\title{Executes a script and returns the output.
The stdout and stderr are captured and returned.
In case of errors, the exit code will return in the status field.}
\usage{
execute(script = "", args = c(), env = character(), wait = TRUE,
  runner = NULL, print_commands = FALSE, get_runtime_script = FALSE)
}
\arguments{
\item{script}{The script text}

\item{args}{Optional script command line arguments (arguments are added as variables in the script named ARG1, ARG2, ...)}

\item{env}{Optional character vector of name=value strings to set environment variables}

\item{wait}{A TRUE/FALSE parameter, indicating whether the function should wait for the command to finish, or run it asynchronously (output status will be -1)}

\item{runner}{The executable used to invoke the script (by default cmd.exe for windows, sh for other platforms)}

\item{print_commands}{True if to print each command before invocation (not available for windows)}

\item{get_runtime_script}{True to return the actual invoked script in a script output parameter}
}
\value{
The process output, status code (in case wait=TRUE), error message (in case of any errors) and invoked script in the form of list(status = status, output = output_text, error = error_message, script = script)
}
\description{
Executes a script and returns the output.
The stdout and stderr are captured and returned.
In case of errors, the exit code will return in the status field.
}
\examples{
library('scriptexec')
library('testthat')

# execute script text
output <- scriptexec::execute('echo command1\\necho command2')
expect_equal(output$status, 0)
expect_equal(grepl('command1', output$output), TRUE)
expect_equal(grepl('command2', output$output), TRUE)

if (.Platform$OS.type == 'windows') {
    ls_command <- 'dir'
} else {
    ls_command <- 'ls'
}
output <- scriptexec::execute(c('echo user home:', ls_command))
expect_equal(output$status, 0)

# execute multiple commands as a script
output <- scriptexec::execute(c('cd', 'echo test'))
expect_equal(output$status, 0)

# pass arguments (later defined as ARG1, ARG2, ...) and env vars
if (.Platform$OS.type == 'windows') {
    command <- 'echo \%ARG1\% \%ARG2\% \%MYENV\%'
} else {
    command <- 'echo $ARG1 $ARG2 $MYENV'
}
output <- scriptexec::execute(command, args = c('TEST1', 'TEST2'), env = c('MYENV=TEST3'))
expect_equal(output$status, 0)
expect_equal(grepl('TEST1 TEST2 TEST3', output$output), TRUE)

# non zero status code is returned in case of errors
expect_warning(output <- scriptexec::execute('exit 1'))
expect_equal(output$status, 1)

# do not wait for command to finish
output <- scriptexec::execute('echo my really long task', wait = FALSE)
expect_equal(output$status, -1)
}
