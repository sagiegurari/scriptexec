
setup_env <- function() {
    # setup env
    print("[build] Setup Env")
    Sys.setenv(LC_ALL = "C.UTF-8")
    Sys.setlocale("LC_ALL", "C.UTF-8")
}

cleanup <- function() {
    # delete old files
    print("[build] Deleting Old Files")
    unlink("./docs", recursive = TRUE)
    unlink("./man", recursive = TRUE)
    unlink("./NAMESPACE", recursive = TRUE)
}

load <- function() {
    print("[build] Loading Project")
    devtools::load_all(".")
}

generate_docs <- function() {
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
}

format <- function() {
    # format code
    print("[build] Formatting Code")
    format.config <- list(recursive = TRUE, indent = 4, arrow = TRUE, brace.newline = FALSE, 
        blank = TRUE)
    do.call(formatR::tidy_dir, c("R", format.config))
    do.call(formatR::tidy_dir, c("tests", format.config))
    do.call(formatR::tidy_dir, c("demo", format.config))
    do.call(formatR::tidy_dir, c("tools", format.config))
}

lint <- function() {
    # run lint
    print("[build] Running Linter")
    lintr::lint_package()
}

test <- function() {
    # run tests
    print("[build] Running Tests")
    devtools::test()
}

build <- function() {
    # check package
    print("[build] Running Checks")
    devtools::check()
}

# used before release
build_windows <- function() {
    if (exists("build_win", mode = "environment")) {
        print("[build] Running Windows Build")
        devtools::build_win()
    }
}
release <- function() {
    if (exists("release", mode = "environment")) {
        print("[build] Releasing New Version")
        devtools::release()
    }
}

format.flow <- c(setup_env, cleanup, format)
docs.flow <- c(setup_env, cleanup, load, generate_docs)
dev.flow <- c(docs.flow, format, lint, test)
default.flow <- c(dev.flow, build)
flows <- list(format = format.flow, dev = dev.flow, development = dev.flow, docs = docs.flow, 
    default = default.flow, windows = c(default.flow, build_windows), release = c(default.flow, 
        release))

args <- commandArgs(trailingOnly = TRUE)
flow.name <- "default"
if (length(args) > 0) {
    flow.name <- args[1]
}

print(paste("[build] Build Flow:", flow.name, sep = " "))

flow <- flows[[flow.name]]

if (is.null(flow)) {
    print(paste("[build] Unknown flow:", flow.name, sep = " "))
} else {
    for (step in flow) {
        step()
    }
}
