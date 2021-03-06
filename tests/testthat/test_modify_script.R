context("modify_script")

describe("modify_script", {
    source("helper.R")

    it("no args", {
        script <- scriptexec::modify_script("")
        script <- paste(script, collapse = "\n")

        found <- grepl("ARG", script)
        expect_false(found)
    })

    it("multiple args", {
        script <- scriptexec::modify_script("", c("test1", "test2"))
        script <- paste(script, collapse = "\n")

        found <- grepl("ARG1", script)
        expect_true(found, TRUE)

        found <- grepl("ARG2", script)
        expect_true(found)

        found <- grepl("ARG3", script)
        expect_false(found)
    })

    it("print_commands default", {
        script <- scriptexec::modify_script("", print_commands = TRUE)
        script <- paste(script, collapse = "\n")

        command <- get_os_string("set -x", "")
        found <- grepl(command, script)
        expect_true(found, TRUE)
    })

    it("print_commands unix", {
        script <- scriptexec::modify_script("", print_commands = TRUE,
            is_windows_os = FALSE)
        script <- paste(script, collapse = "\n")

        found <- grepl("set -x", script)
        expect_true(found, TRUE)
    })

    it("generate_env_setup_script windows", {
        script <- scriptexec::modify_script("", env = c("e1=v1", "e2=v2"),
            is_windows_os = TRUE)
        script <- paste(script, collapse = "\n")

        prefix <- get_os_string("export", "SET")
        expected_result <- c(paste(prefix, "e1=v1", sep = " "))
        found <- grepl(expected_result, script)
        expect_true(found, TRUE)
    })
})
