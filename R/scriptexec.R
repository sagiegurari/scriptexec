#' scriptexec: Execute native scripts
#'
#' This package provides one main function: execute which executes the provided script and returns its output.
#' @docType package
#' @name scriptexec
NULL

#' Returns true if windows, else false.
#'
#' @return True if windows, else false.
#' @export
#' @examples
#' windows <- is_windows()
is_windows <- function() {
    os <- .Platform$OS.type  #windows or unix
    (os == "windows")
}

#' Returns the value based on the current platform.
#'
#' @param unix_value The unix platform value
#' @param windows_value The windows platform value
#' @return unix_value in case of unix system, else the windows_value
#' @export
#' @examples
#' platform_value <- get_platform_value('.sh', '.bat')
get_platform_value <- function(unix_value, windows_value) {
    windows <- is_windows()

    output <- unix_value
    if (windows) {
        output <- windows_value
    }

    output
}

#' Generates and returns a script which sets up the env vars for the script execution.
#'
#' @param env Optional character vector of name=value strings to set environment variables
#' @return The script text which sets up the env
#' @export
#' @examples
#' script <- generate_env_setup_script(c('ENV_TEST=MYENV'))
generate_env_setup_script <- function(env = character()) {
    lines <- c()

    prefix <- get_platform_value("export", "SET")
    for (pair in env) {
        line <- paste(prefix, pair, sep = " ")
        lines <- c(lines, line)
    }

    lines
}

#' Generates and returns a script which sets up the env vars for the script arguments
#'
#' @param args Optional script command line arguments
#' @return The script text which sets up the env vars for the script arguments
#' @export
#' @examples
#' script <- generate_args_setup_script(args = c('first', 'second'))
generate_args_setup_script <- function(args = character()) {
    lines <- c()

    # setup script arguments
    index <- 1
    var_prefix <- get_platform_value("ARG", "SET ARG")
    for (arg in args) {
        args_line <- paste(var_prefix, index, "=", arg, sep = "")
        lines <- c(lines, args_line)
        index <- index + 1
    }

    lines
}

#' Modifies the provided script text and ensures the script content is executed in the correct location.
#'
#' @param script The script text
#' @param args Optional script command line arguments
#' @param env Optional character vector of name=value strings to set environment variables
#' @param print_commands True if to print each command before invocation (not available for windows)
#' @return The modified script text
#' @export
#' @examples
#' script <- modify_script(script = 'echo test', args = c('first', 'second'), env = c('MYENV=MYENV'))
modify_script <- function(script, args = c(), env = character(), print_commands = FALSE) {
    windows <- is_windows()
    initial_commands <- ""
    if (!windows && print_commands) {
        initial_commands <- "set -x"
    }

    # setup cd command
    cwd <- getwd()
    cd_line <- paste("cd", cwd, sep = " ")

    # setup env vars
    env_line <- character()
    if (windows) {
        env_line <- generate_env_setup_script(env)
    }

    # setup script arguments
    args_lines <- generate_args_setup_script(args)

    c(initial_commands, cd_line, env_line, args_lines, script)
}

#' Returns the command and arguments needed to execute the provided script file on the current platform.
#'
#' @param filename The script file to execute
#' @param runner The executable used to invoke the script (by default cmd.exe for windows, sh for other platforms)
#' @return A list holding the command and arguments
#' @export
#' @examples
#' command_struct <- get_command('myfile.sh')
#' command <- command_struct$command
#' cli_args <- command_struct$args
get_command <- function(filename, runner = NULL) {
    if (is.null(runner)) {
        command <- get_platform_value("sh", "cmd.exe")
    } else {
        command <- runner
    }

    # nolint start (lintr bug)
    args <- get_platform_value(c(filename), c("/C", filename))
    # nolint end

    list(command = command, args = args)
}

#' Creates a temporary file, writes the provided script content into it and returns the file name.
#'
#' @param script The script text
#' @return The temporary file name
#' @export
#' @examples
#' filename <- create_script_file('echo test')
create_script_file <- function(script = "") {
    extension <- get_platform_value(".sh", ".bat")

    # create a temporary file to store the script
    filename <- tempfile("script_", fileext = extension)

    # write script to temprary file
    fd <- file(filename)
    writeLines(script, fd)
    close(fd)

    filename
}

#' Builds the output structure.
#'
#' @param output The invocation output
#' @param wait A TRUE/FALSE parameter, indicating whether the function should wait for the command to finish, or run it asynchronously
#' @return The script output structure
#' @export
#' @examples
#' output <- c('line 1', '\n', 'line 2')
#' attr(output, 'status') <- 15
#' script_output <- build_output(output)
build_output <- function(output, wait) {
    status <- attr(output, "status")
    if (is.null(status)) {
        if (wait) {
            status <- 0
        } else {
            status <- -1
        }
    }

    error_message <- attr(output, "errmsg")

    output_text <- paste(c(output), sep = "\n", collapse = "")

    script_output <- list(status = status, output = output_text, error = error_message)

    script_output
}

#' Internal error handler.
#'
#' @param error The invocation error
#' @return The invocation output
#' @export
on_invoke_error <- function(error) {
    output <- ""
    attr(output, "status") <- 1
    attr(output, "errmsg") <- error

    output
}

#' Executes a script and returns the output.
#' The stdout and stderr are captured and returned.
#' In case of errors, the exit code will return in the status field.
#'
#' @param script The script text
#' @param args Optional script command line arguments (arguments are added as variables in the script named ARG1, ARG2, ...)
#' @param env Optional character vector of name=value strings to set environment variables
#' @param wait A TRUE/FALSE parameter, indicating whether the function should wait for the command to finish, or run it asynchronously (output status will be -1)
#' @param runner The executable used to invoke the script (by default cmd.exe for windows, sh for other platforms)
#' @param print_commands True if to print each command before invocation (not available for windows)
#' @param get_runtime_script True to return the actual invoked script in a script output parameter
#' @return The process output, status code (in case wait=TRUE), error message (in case of any errors) and invoked script in the form of list(status = status, output = output_text, error = error_message, script = script)
#' @export
#' @examples
#' library('scriptexec')
#' library('testthat')
#'
#' # execute script text
#' output <- scriptexec::execute('echo command1\necho command2')
#' expect_equal(output$status, 0)
#' expect_equal(grepl('command1', output$output), TRUE)
#' expect_equal(grepl('command2', output$output), TRUE)
#'
#' if (.Platform$OS.type == 'windows') {
#'     ls_command <- 'dir'
#' } else {
#'     ls_command <- 'ls'
#' }
#' output <- scriptexec::execute(c('echo user home:', ls_command))
#' expect_equal(output$status, 0)
#'
#' # execute multiple commands as a script
#' output <- scriptexec::execute(c('cd', 'echo test'))
#' expect_equal(output$status, 0)
#'
#' # pass arguments (later defined as ARG1, ARG2, ...) and env vars
#' if (.Platform$OS.type == 'windows') {
#'     command <- 'echo %ARG1% %ARG2% %MYENV%'
#' } else {
#'     command <- 'echo $ARG1 $ARG2 $MYENV'
#' }
#' output <- scriptexec::execute(command, args = c('TEST1', 'TEST2'), env = c('MYENV=TEST3'))
#' expect_equal(output$status, 0)
#' expect_equal(grepl('TEST1 TEST2 TEST3', output$output), TRUE)
#'
#' # non zero status code is returned in case of errors
#' expect_warning(output <- scriptexec::execute('exit 1'))
#' expect_equal(output$status, 1)
#'
#' # do not wait for command to finish
#' output <- scriptexec::execute('echo my really long task', wait = FALSE)
#' expect_equal(output$status, -1)
execute <- function(script = "", args = c(), env = character(), wait = TRUE,
    runner = NULL, print_commands = FALSE, get_runtime_script = FALSE) {
    full_script <- modify_script(script = script, args = args, env = env,
        print_commands = print_commands)
    full_script <- paste(full_script, sep = "\n")

    # create a temporary file to store the script
    filename <- create_script_file(full_script)

    command_struct <- get_command(filename, runner)
    command <- command_struct$command
    cli_args <- command_struct$args

    arg_list <- list(command = command, args = cli_args, stdout = wait,
        stderr = wait, stdin = "", input = NULL, env = env, wait = wait)
    windows <- is_windows()
    if (windows) {
        arg_list <- c(list(minimized = TRUE, invisible = TRUE), arg_list)
    }

    output <- tryCatch(do.call(system2, arg_list), error = on_invoke_error)

    # get output
    script_output <- build_output(output = output, wait = wait)

    if (get_runtime_script) {
        script_output$script <- full_script
    }

    script_output
}
