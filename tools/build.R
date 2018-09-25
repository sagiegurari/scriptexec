
# setup env
print("[build] Setup Env")
Sys.setenv(LC_ALL = "C.UTF-8")
Sys.setlocale("LC_ALL", "C.UTF-8")

# delete old files
print("[build] Deleting Old Files")
unlink("./docs", recursive = TRUE)
unlink("./man", recursive = TRUE)
unlink("./NAMESPACE", recursive = TRUE)

print("[build] Loading Project")
devtools::load_all(".")

# generate documentation
print("[build] Generating Documentation")
devtools::document()
dir.create("./docs")
Rd2md::ReferenceManual(".", outdir = "./docs", verbose = FALSE)
api.doc.file <- "./docs/api.md"
file.rename("./docs/Reference_Manual_..md", api.doc.file)
api.doc <- readLines(api.doc.file)
api.doc <- gsub(pattern = "```", replace = "\n```", x = api.doc)
api.doc <- gsub(pattern = "\r", replace = "", x = api.doc)
api.doc <- gsub(pattern = "[ \t]+\n", replace = "\n", x = api.doc)
api.doc <- gsub(pattern = "\n\n", replace = "\n", x = api.doc)
writeLines(api.doc, con = api.doc.file)

# format code
print("[build] Formatting Code")
format.config <- list(recursive = TRUE, indent = 4, arrow = TRUE, brace.newline = FALSE, 
    blank = TRUE)
do.call(formatR::tidy_dir, c("R", format.config))
do.call(formatR::tidy_dir, c("tests", format.config))
do.call(formatR::tidy_dir, c("demo", format.config))
do.call(formatR::tidy_dir, c("tools", format.config))

# run lint
print("[build] Running Linter")
lintr::lint_package()

# run tests
print("[build] Running Tests")
devtools::test()

# check package
print("[build] Running Checks")
devtools::check()

# used before release
if (exists("build_win", mode = "environment")) {
    print("[build] Running Windows Build")
    devtools::build_win()
}
if (exists("release", mode = "environment")) {
    print("[build] Releasing New Version")
    devtools::release()
}
