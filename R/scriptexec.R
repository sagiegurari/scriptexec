#' scriptexec: Execute native scripts
#'
#' This package provides one main function: script_execute which executes the provided script and returns its output.
#' @docType package
#' @name scriptexec
NULL

#' Returns true if windows, else false.
#'
#' @return True if windows, else false.
is_windows <- function() {
    os <- .Platform$OS.type  #windows or unix
    (os == "windows")
}

#' Modifies the provided script text and ensures the script content is executed in the correct location.
#'
#' @param script The script text
#' @param args Optional script command line arguments
#' @return The modified script text
modify_script <- function(script, args = c()) {
    # setup cd command
    cwd <- getwd()
    cd.line <- paste("cd", cwd, sep = " ")
    
    # setup script arguments
    windows <- is_windows()
    index <- 1
    var.prefix <- "ARG"
    if (windows) {
        var.prefix <- "SET ARG"
    }
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
create_temp_file <- function(script) {
    windows <- is_windows()
    
    extension <- ".sh"
    if (windows) {
        extension <- ".bat"
    }
    
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
get_command <- function(filename) {
    windows <- is_windows()
    
    command <- "sh"
    args <- c(filename)
    if (windows) {
        command <- "cmd.exe"
        args <- c("/C", filename)
    }
    
    list(command = command, args = args)
}

#' Executes a script and returns the output.
#' The stdout and stderr are captured and returned.
#' In case of errors, the exit code will return in the status field.
#'
#' @param script The script text
#' @param args Optional script command line arguments (arguments are added as variables in the script named ARG1, ARG2, ...)
#' @return The script output, see system2 documentation
#' @export
#' @examples
#' #execute script text
#' output <- script_execute('echo Current Directory:\ndir') 
#' cat(sprintf('%s\n', output))
#'
#' #execute multiple commands as a script
#' output <- script_execute(c('cd', 'echo User Home:', 'dir'))
#' cat(sprintf('%s\n', output))
#'
#' #pass argument to the script, later defined as ARG1
#' output <- script_execute(c('echo $ARG1 $ARG2'), c('TEST1', 'TEST2'))
#' cat(sprintf('%s\n', output))
script_execute <- function(script, args = c()) {
    full.script <- modify_script(script = script, args = args)
    
    # create a temporary file to store the script
    filename <- create_temp_file(full.script)
    
    command_struct <- get_command(filename)
    command <- command_struct[[1]]
    cli_args <- command_struct[[2]]
    
    output <- system2(command, args = cli_args, stdout = TRUE, stderr = TRUE, stdin = "", 
        input = NULL, env = character(), wait = TRUE, minimized = TRUE, invisible = TRUE)
    
    status <- attr(output, "status")
    
    list(status = status, output = c(output))
}
