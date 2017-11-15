
#regenerate documentation
devtools::document() 

#format code
formatR::tidy_dir("R", indent = 4, arrow = TRUE, brace.newline = FALSE, blank = TRUE)

#run lint
lintr::lint_package()

#run tests
devtools::test()

#check package
devtools::check()
