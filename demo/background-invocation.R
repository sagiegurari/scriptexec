library(scriptexec)

# do not wait for command to finish exist status will be -1 meaning
# 'unknown'
output <- scriptexec::execute("echo my really long task", wait = FALSE)
cat(sprintf("Exit Status: %s\n", output$status))
