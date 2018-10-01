
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
    unlink("./README.md", recursive = TRUE)
}

load <- function() {
    print("[build] Loading Project")
    devtools::load_all(".")
}

get_description_doc <- function(text) {
    print("[build] Extrating Description Documention.")
    
    doc <- c()
    for (line in text) {
        if (startsWith(x = line, prefix = "# `")) {
            break
        }
        
        doc <- c(doc, line)
    }
    
    doc
}

get_function_api_doc <- function(name, text) {
    print(sprintf("[build] Extrating Function Documention: %s", name))
    
    doc <- c()
    prefix <- paste("# `", name, "`", sep = "")
    started <- FALSE
    for (line in text) {
        if (started) {
            if (startsWith(x = line, prefix = "# `")) {
                break
            }
            
            doc <- c(doc, line)
        } else if (startsWith(x = line, prefix = prefix)) {
            started <- TRUE
            doc <- c(doc, line)
        }
    }
    
    doc
}

read_package_value <- function(name) {
    text <- readLines("./DESCRIPTION")
    
    value <- ""
    prefix <- paste(name, ": ", sep = "")
    for (line in text) {
        if (startsWith(x = line, prefix = prefix)) {
            value <- gsub(pattern = prefix, replace = "", x = line)
            value <- gsub(pattern = "^\\s+|\\s+$", replace = "", x = value)
            break
        }
    }
    
    value
}

read_example_code <- function(name) {
    file.name <- paste("./vignettes/", name, ".Rmd", sep = "")
    text <- readLines(file.name)
    
    code <- c()
    prefix <- paste("library(", name, ")", sep = "")
    started <- FALSE
    for (line in text) {
        line <- gsub(pattern = "^\\s+|\\s+$", replace = "", x = line)
        
        if (started) {
            if (startsWith(x = line, prefix = "```")) {
                break
            }
            
            code <- c(code, line)
        } else if (startsWith(x = line, prefix = prefix)) {
            started <- TRUE
            code <- c(code, line)
        }
    }
    
    code
}

generate_readme <- function() {
    print("[build] Generating README")
    
    template.doc <- readLines("./tools/README-template.md")
    package.name <- read_package_value("Package")
    version <- read_package_value("Version")
    description <- read_package_value("Description")
    
    template.doc <- gsub(pattern = "{package.version}", replace = version, x = template.doc, 
        fixed = TRUE)
    template.doc <- gsub(pattern = "{package.name}", replace = package.name, x = template.doc, 
        fixed = TRUE)
    template.doc <- gsub(pattern = "{package.description}", replace = description, 
        x = template.doc, fixed = TRUE)
    
    code <- read_example_code(package.name)
    code <- c("```r", code, "```")
    code <- paste(code, sep = "\n")
    
    template.doc.parts <- c()
    for (line in template.doc) {
        if (startsWith(x = line, prefix = "{package.example.code}")) {
            template.doc.parts <- c(template.doc.parts, code)
        } else {
            template.doc.parts <- c(template.doc.parts, line)
        }
    }
    template.doc <- paste(template.doc.parts, sep = "")
    
    writeLines(template.doc, con = "./README.md")
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
    
    description.doc <- get_description_doc(api.doc)
    function.doc <- get_function_api_doc(name = "execute", text = api.doc)
    api.doc <- c(description.doc, function.doc)
    
    print("[build] Writing API markdown")
    writeLines(api.doc, con = api.doc.file)
    
    generate_readme()
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

sprintf("[build] Build Flow: %s", flow.name)

flow <- flows[[flow.name]]

if (is.null(flow)) {
    sprintf("[build] Unsupported Build Flow: %s", flow.name)
} else {
    for (step in flow) {
        step()
    }
}
