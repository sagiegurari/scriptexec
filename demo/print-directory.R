library(scriptexec)

# execute script text
output <- scriptexec::execute("echo Current Directory:\ndir")
cat(sprintf("Exit Status: %s Output: %s\n", output$status, output$output))
