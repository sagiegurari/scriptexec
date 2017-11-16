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

#' Modifies the provided script text and ensures the script content is executed in the correct location.
#'
#' @param script The script text
#' @param args Optional script command line arguments
#' @return The modified script text
#' @export
#' @examples
#' full.script <- modify_script(script = 'echo test', args = c('first', 'second'))
modify_script <- function(script, args = c()) {
    # setup cd command
    cwd <- getwd()
    cd.line <- paste("cd", cwd, sep = " ")
    
    # setup script arguments
    index <- 1
    var.prefix <- get_platform_value("ARG", "SET ARG")
    args.lines <- c()
    for (arg in args) {
        args.line <- paste(var.prefix, index, "=", arg, sep = "")
        args.lines <- c(args.lines, args.line)
        index <- index + 1
    }
    
    script.string <- paste(script, collapse = "\n")
    paste(cd.line, args.lines, script.string, sep = "\n")
}

#' Creates a temporary file, writes the provided script content into it and returns the file name.
#'
#' @param script The script text
#' @return The temporary file name
#' @export
#' @examples
#' filename <- create_temp_file('echo test')
create_temp_file <- function(script = "") {
    extension <- get_platform_value(".sh", ".bat")
    
    # create a temporary file to store the script
    filename <- tempfile("script_", fileext = extension)
    
    # write script to temprary file
    fd <- file(filename)
    writeLines(script, fd)
    close(fd)
    
    filename
}

#' Returns the command and arguments needed to execute the provided script file on the current platform.
#'
#' @param filename The script file to execute
#' @return A list holding the command and arguments
#' @export
#' @examples
#' command_struct <- get_command('myfile.sh')
#' command <- command_struct$command
#' cli_args <- command_struct$args
get_command <- function(filename) {
    command <- get_platform_value("sh", "cmd.exe")
    args <- get_platform_value(c(filename), c("/C", filename))
    
    list(command = command, args = args)
}

#' Executes a script and returns the output.
#' The stdout and stderr are captured and returned.
#' In case of errors, the exit code will return in the status field.
#'
#' @param script The script text
#' @param args Optional script command line arguments (arguments are added as variables in the script named ARG1, ARG2, ...)
#' @param env Optional character vector of name=value strings to set environment variables (not supported on windows)
#' @return The script output, see system2 documentation
#' @export
#' @examples
#' #execute script text
#' output <- execute('echo Current Directory:\ndir')
#' cat(sprintf('Exit Status: %s Output: %s\n', output$status, output$output))
#'
#' #execute multiple commands as a script
#' output <- execute(c('cd', 'echo User Home:', 'dir'))
#' cat(sprintf('Exit Status: %s Output: %s\n', output$status, output$output))
#'
#' #pass arguments to the script, later defined as ARG1, ARG2, ...
#' output <- execute('echo $ARG1 $ARG2', args = c('TEST1', 'TEST2'))
#' cat(sprintf('%s\n', output))
#'
#' #non zero status code is returned in case of errors
#' output <- execute('exit 1')
#' cat(sprintf('Status: %s\n', output$status))
#' cat(sprintf('%s\n', output))
execute <- function(script = "", args = c(), env = character()) {
    full.script <- modify_script(script = script, args = args)
    
    # create a temporary file to store the script
    filename <- create_temp_file(full.script)
    
    command_struct <- get_command(filename)
    command <- command_struct$command
    cli_args <- command_struct$args
    
    arg.list <- list(command = command, args = cli_args, stdout = TRUE, stderr = TRUE, 
        stdin = "", input = NULL, env = env, wait = TRUE)
    windows <- is_windows()
    if (windows) {
        c(list(minimized = TRUE, invisible = TRUE), arg.list)
    }
    
    output <- do.call(system2, arg.list)
    
    # get output
    status <- attr(output, "status")
    if (is.null(status)) {
        status <- 0
    }
    output.text <- paste(c(output), sep = "\n", collapse = "")
    
    list(status = status, output = output.text)
}
