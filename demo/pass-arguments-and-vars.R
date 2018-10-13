library(scriptexec)

# pass arguments (later defined as ARG1, ARG2, ...) and env vars
if (.Platform$OS.type == "windows") {
    command <- "echo %ARG1% %ARG2% %MYENV%"
} else {
    command <- "echo $ARG1 $ARG2 $MYENV"
}
output <- scriptexec::execute(command, args = c("TEST1", "TEST2"), env = c("MYENV=TEST3"))
cat(sprintf("Exit Status: %s Output: %s\n", output$status, output$output))
