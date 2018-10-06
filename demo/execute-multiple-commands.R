library(scriptexec)

# execute script text
output <- scriptexec::execute("echo running some command\necho running another command")
cat(sprintf("Exit Status: %s Output: %s\n", output$status, output$output))
