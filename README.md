# scriptexec

[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/scriptexec)](https://cran.r-project.org/package=scriptexec) [![Build Status](https://travis-ci.org/sagiegurari/scriptexec.svg)](http://travis-ci.org/sagiegurari/scriptexec) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/sagiegurari/scriptexec?branch=master&svg=true)](https://ci.appveyor.com/project/sagiegurari/scriptexec) [![codecov](https://codecov.io/gh/sagiegurari/scriptexec/branch/master/graph/badge.svg)](https://codecov.io/gh/sagiegurari/scriptexec) [![CRAN](https://img.shields.io/cran/l/scriptexec.svg)](https://github.com/sagiegurari/scriptexec/blob/master/LICENSE) [![Rdoc](http://www.rdocumentation.org/badges/version/scriptexec)](http://www.rdocumentation.org/packages/scriptexec)

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

````r
output <- scriptexec::execute("echo Current Directory:\ndir")
cat(sprintf("Exit Status: %s Output: %s\n", output$status, output$output))

# execute multiple commands as a script
output <- scriptexec::execute(c("cd", "echo User Home:", "dir"))
cat(sprintf("Exit Status: %s Output: %s\n", output$status, output$output))

# pass arguments to the script, later defined as ARG1, ARG2, ...
# and also pass some env vars
output <- execute("echo $ARG1 $ARG2 $MYENV", args = c("TEST1", "TEST2"), env = c("MYENV=TEST3"))
cat(sprintf("%s\n", output))

# non zero status code is returned in case of errors
output <- scriptexec::execute("exit 1")
cat(sprintf("Status: %s\n", output$status))
cat(sprintf("%s\n", output))

# do not wait for command to finish
execute('echo my really long task', wait = FALSE)
````

<a name="installation"></a>
## Installation
Install latest release from github (recommanded):

```r
devtools::install_github("sagiegurari/scriptexec@0.2.0")
```

Install from CRAN (might be older, depending on CRAN team approval process)

```r
install.packages("scriptexec")
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
