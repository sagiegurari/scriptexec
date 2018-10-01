
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
    print("[build] Extrating Description Documention")
    
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
    file_name <- paste("./vignettes/", name, ".Rmd", sep = "")
    text <- readLines(file_name)
    
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
    
    template_doc <- readLines("./tools/README-template.md")
    package_name <- read_package_value("Package")
    version <- read_package_value("Version")
    description <- read_package_value("Description")
    
    template_doc <- gsub(pattern = "{package.version}", replace = version, x = template_doc, 
        fixed = TRUE)
    template_doc <- gsub(pattern = "{package.name}", replace = package_name, x = template_doc, 
        fixed = TRUE)
    template_doc <- gsub(pattern = "{package.description}", replace = description, 
        x = template_doc, fixed = TRUE)
    
    code <- read_example_code(package_name)
    code <- c("```r", code, "```")
    code <- paste(code, sep = "\n")
    
    template_doc_parts <- c()
    for (line in template_doc) {
        # trim line
        line <- gsub(pattern = "^\\s+|\\s+$", replace = "", x = line)
        
        if (startsWith(x = line, prefix = "{package.example.code}")) {
            template_doc_parts <- c(template_doc_parts, code)
        } else {
            template_doc_parts <- c(template_doc_parts, line)
        }
    }
    template_doc <- paste(template_doc_parts, sep = "")
    
    writeLines(template_doc, con = "./README.md")
}

generate_docs <- function() {
    # generate documentation
    print("[build] Generating Documentation")
    devtools::document()
    dir.create("./docs")
    Rd2md::ReferenceManual(".", outdir = "./docs", verbose = FALSE)
    
    api_doc_file <- "./docs/api.md"
    file.rename("./docs/Reference_Manual_..md", api_doc_file)
    
    api_doc <- readLines(api_doc_file)
    
    api_doc <- gsub(pattern = "```", replace = "\n```", x = api_doc)
    api_doc <- gsub(pattern = "\r", replace = "", x = api_doc)
    api_doc <- gsub(pattern = "[ \t]+\n", replace = "\n", x = api_doc)
    api_doc <- gsub(pattern = "\n\n", replace = "\n", x = api_doc)
    
    description_doc <- get_description_doc(api_doc)
    function_doc <- get_function_api_doc(name = "execute", text = api_doc)
    api_doc <- c(description_doc, function_doc)
    
    print("[build] Writing API markdown")
    writeLines(api_doc, con = api_doc_file)
    
    generate_readme()
}

format <- function() {
    # format code
    print("[build] Formatting Code")
    format_config <- list(recursive = TRUE, indent = 4, arrow = TRUE, brace.newline = FALSE, 
        blank = TRUE)
    do.call(formatR::tidy_dir, c("R", format_config))
    do.call(formatR::tidy_dir, c("tests", format_config))
    do.call(formatR::tidy_dir, c("demo", format_config))
    do.call(formatR::tidy_dir, c("tools", format_config))
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

format_flow <- c(setup_env, cleanup, format)
docs_flow <- c(setup_env, cleanup, load, generate_docs)
dev_flow <- c(docs_flow, format, lint, test)
default_flow <- c(dev_flow, build)
flows <- list(format = format_flow, dev = dev_flow, development = dev_flow, docs = docs_flow, 
    default = default_flow, windows = c(default_flow, build_windows), release = c(default_flow, 
        release))

args <- commandArgs(trailingOnly = TRUE)
flow_name <- "default"
if (length(args) > 0) {
    flow_name <- args[1]
}

sprintf("[build] Build Flow: %s", flow_name)

flow <- flows[[flow_name]]

if (is.null(flow)) {
    sprintf("[build] Unsupported Build Flow: %s", flow_name)
} else {
    for (step in flow) {
        step()
    }
}
