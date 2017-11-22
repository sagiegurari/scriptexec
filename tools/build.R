
# delete old files
unlink("./docs", recursive = TRUE)
unlink("./man", recursive = TRUE)
unlink("./NAMESPACE", recursive = TRUE)

devtools::load_all(".")

# regenerate documentation
dir.create("./docs")
devtools::document()
Rd2md::ReferenceManual(".", outdir = "./docs", verbose=FALSE)    

# format code
format.config <- list(recursive = TRUE, indent = 4, arrow = TRUE, brace.newline = FALSE, blank = TRUE)
do.call(formatR::tidy_dir, c("R", format.config))
do.call(formatR::tidy_dir, c("tests", format.config))
do.call(formatR::tidy_dir, c("demo", format.config))

# run lint
lintr::lint_package()

# run tests
devtools::test()

# check package
devtools::check()

# used before release
# devtools::build_win()
# devtools::release()
