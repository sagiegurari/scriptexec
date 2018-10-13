library(scriptexec)

# execute script text
if (.Platform$OS.type == "windows") {
    ls_command <- "dir"
} else {
    ls_command <- "ls"
}
output <- scriptexec::execute(c("echo user home:", ls_command))
cat(sprintf("Exit Status: %s Output: %s\n", output$status, output$output))
