
get_os_string <- function(unix_string, windows_string) {
    output <- unix_string
    if (.Platform$OS.type == "windows") {
        output <- windows_string
    }
    
    output
}
