context("get_platform_value")

describe("get_platform_value", {
    source("helper.R")

    it("default", {
        output <- scriptexec::get_platform_value("unix", "windows", FALSE)

        os_value <- get_os_string("unix", "windows")
        expect_equal(output, os_value)
    })

    it("force windows", {
        output <- scriptexec::get_platform_value("unix", "windows", TRUE)

        expect_equal(output, "windows")
    })
})
