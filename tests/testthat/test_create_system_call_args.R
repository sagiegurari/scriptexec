context("create_system_call_args")

describe("create_system_call_args", {
    source("helper.R")

    it("unix", {
        args <- scriptexec::create_system_call_args("sh", c("./myfile.sh"),
            TRUE, c("MYENV=TEST3"), FALSE)

        expect_equal(args$command, "sh")
        expect_equal(args$args, c("./myfile.sh"))
        expect_equal(args$stdout, TRUE)
        expect_equal(args$stderr, TRUE)
        expect_equal(args$stdin, "")
        expect_equal(args$input, NULL)
        expect_equal(args$env, c("MYENV=TEST3"))
        expect_equal(args$wait, TRUE)
    })

    it("windows", {
        args <- scriptexec::create_system_call_args("sh", c("./myfile.sh"),
            TRUE, c("MYENV=TEST3"), TRUE)

        expect_equal(args$command, "sh")
        expect_equal(args$args, c("./myfile.sh"))
        expect_equal(args$stdout, TRUE)
        expect_equal(args$stderr, TRUE)
        expect_equal(args$stdin, "")
        expect_equal(args$input, NULL)
        expect_equal(args$env, c("MYENV=TEST3"))
        expect_equal(args$wait, TRUE)
        expect_equal(args$minimized, TRUE)
        expect_equal(args$invisible, TRUE)
    })

    it("wait", {
        args <- scriptexec::create_system_call_args("sh", c("./myfile.sh"),
            TRUE, c("MYENV=TEST3"), TRUE)

        expect_equal(args$stdout, TRUE)
        expect_equal(args$stderr, TRUE)
        expect_equal(args$wait, TRUE)
    })

    it("no wait", {
        args <- scriptexec::create_system_call_args("sh", c("./myfile.sh"),
            FALSE, c("MYENV=TEST3"), TRUE)

        expect_equal(args$stdout, FALSE)
        expect_equal(args$stderr, FALSE)
        expect_equal(args$wait, FALSE)
    })
})
