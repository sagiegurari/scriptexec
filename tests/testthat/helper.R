
is_string_exists <- function(pattern, text) {
    position <- regexpr(pattern, text)
    
    found <- FALSE
    if (position > 0) {
        found <- TRUE
    }
    
    found
}

get_os_string <- function(unix_string, windows_string) {
    output <- unix_string
    if (.Platform$OS.type == "windows") {
        output <- windows_string
    }
    
    output
}
