context("generate_args_setup_script")

describe("generate_args_setup_script", {
    source("helper.R")

    it("no env", {
        script <- scriptexec::generate_args_setup_script()

        length <- length(script)
        expect_equal(length, 0)
    })

    it("multiple env vars", {
        script <- scriptexec::generate_args_setup_script(c("test1", "test2"))

        length <- length(script)
        expect_equal(length, 2)

        prefix <- get_os_string("", "SET ")
        expected_result <- c(paste(prefix, "ARG1=test1", sep = ""), paste(prefix,
            "ARG2=test2", sep = ""))

        expect_equal(expected_result, script)
    })
})
