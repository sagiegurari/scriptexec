# scriptexec

[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/scriptexec)](https://cran.r-project.org/package=scriptexec) [![GitHub release](https://img.shields.io/github/release/sagiegurari/scriptexec.svg)](https://github.com/sagiegurari/scriptexec/releases) [![Build Status](https://travis-ci.org/sagiegurari/scriptexec.svg)](http://travis-ci.org/sagiegurari/scriptexec) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/sagiegurari/scriptexec?branch=master&svg=true)](https://ci.appveyor.com/project/sagiegurari/scriptexec) [![codecov](https://codecov.io/gh/sagiegurari/scriptexec/branch/master/graph/badge.svg)](https://codecov.io/gh/sagiegurari/scriptexec)<br>
[![License](https://img.shields.io/cran/l/scriptexec.svg)](https://github.com/sagiegurari/scriptexec/blob/master/LICENSE) [![Downloads](https://cranlogs.r-pkg.org/badges/grand-total/scriptexec)](https://github.com/sagiegurari/scriptexec/releases) [![Rdoc](http://www.rdocumentation.org/badges/version/scriptexec?0.2.2)](http://www.rdocumentation.org/packages/scriptexec)

> Run complex native scripts with a single command, similar to system commands.

* [Overview](#overview)
* [Usage](#usage)
* [Installation](#installation)
* [API Documentation](docs/api.md)
* [Contributing](.github/CONTRIBUTING.md)
* [Release History](NEWS.md)
* [License](#license)

<a name="overview"></a>
## Overview
The purpose of the scriptexec package is to enable quick and easy way to execute native scripts.

<a name="usage"></a>
## Usage
Simply load the library and invoke the execute

```r
library(scriptexec)

# execute script text
output <- scriptexec::execute("echo command1\necho command2")
expect_equal(output$status, 0)
expect_equal(grepl("command1", output$output), TRUE)
expect_equal(grepl("command2", output$output), TRUE)

# execute multiple commands as a script
output <- scriptexec::execute(c("cd", "echo test"))
expect_equal(output$status, 0)

# pass arguments (later defined as ARG1, ARG2, ...) and env vars
if (.Platform$OS.type == "windows") {
    command <- "echo %ARG1% %ARG2% %MYENV%"
} else {
    command <- "echo $ARG1 $ARG2 $MYENV"
}
output <- scriptexec::execute(command, args = c("TEST1", "TEST2"), env = c("MYENV=TEST3"))
expect_equal(output$status, 0)
expect_equal(grepl("TEST1 TEST2 TEST3", output$output), TRUE)

# non zero status code is returned in case of errors
expect_warning(output <- scriptexec::execute("exit 1"))
expect_equal(output$status, 1)

# do not wait for command to finish
output <- scriptexec::execute("echo my really long task", wait = FALSE)
expect_equal(output$status, -1)
```

<a name="installation"></a>
## Installation
Install from CRAN:

```r
install.packages("scriptexec")
```

Install latest release from github:

```r
devtools::install_github("sagiegurari/scriptexec@0.2.2")
```

Install current development version from github (might be unstable):

```r
devtools::install_github("sagiegurari/scriptexec")
```

## API Documentation
See full docs at: [API Docs](docs/api.md)

## Contributing
See [contributing guide](.github/CONTRIBUTING.md)

<a name="history"></a>
## Release History

See [NEWS](NEWS.md)

<a name="license"></a>
## License
Developed by Sagie Gur-Ari and licensed under the Apache 2 open source license.
