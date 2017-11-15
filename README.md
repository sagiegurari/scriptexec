# scriptexec

[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/scriptexec)](https://cran.r-project.org/package=scriptexec) [![Build Status](https://travis-ci.org/sagiegurari/scriptexec.svg)](http://travis-ci.org/sagiegurari/scriptexec) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/sagiegurari/scriptexec?branch=master&svg=true)](https://ci.appveyor.com/project/sagiegurari/scriptexec) [![codecov](https://codecov.io/gh/sagiegurari/scriptexec/branch/master/graph/badge.svg)](https://codecov.io/gh/sagiegurari/scriptexec) [![CRAN](https://img.shields.io/cran/l/scriptexec.svg)](https://github.com/sagiegurari/scriptexec/blob/master/LICENSE) [![Rdoc](http://www.rdocumentation.org/badges/version/scriptexec)](http://www.rdocumentation.org/packages/scriptexec)

> Run complex native scripts with a single command, similar to system commands.

* [Overview](#overview)
* [Usage](#usage)
* [Installation](#installation)
* [API Documentation](http://www.rdocumentation.org/packages/scriptexec)
* [Contributing](.github/CONTRIBUTING.md)
* [Release History](NEWS.md)
* [License](#license)

<a name="overview"></a>
## Overview
The purpose of the scriptexec package is to enable quick and easy way to execute native scripts.

<a name="usage"></a>
## Usage
Simply load the library and invoke the script_execute

````r
library(scriptexec)

#execute script text
output <- scriptexec::script_execute("echo Current Directory:\ndir") 
cat(sprintf("%s\n", output))

#execute multiple commands as a script
output <- scriptexec::script_execute(c("cd", "echo User Home:", "dir"))
cat(sprintf("%s\n", output))

#pass argument to the script, later defined as ARG1
output <- script_execute(c("echo $ARG1 $ARG2"), c("TEST1", "TEST2"))
cat(sprintf("%s\n", output))

#status is returned in case of errors
output <- scriptexec::script_execute("exit 1")
cat(sprintf("Status: %s\n", output$status))
cat(sprintf("%s\n", output))
````

<a name="installation"></a>
## Installation
In order to use this library, run the following command:

```r
install.packages("scriptexec")
```

Or install latest version from github:

```r
devtools::install_github("sagiegurari/scriptexec")
```

## API Documentation
See full docs at: [API Docs](http://www.rdocumentation.org/packages/scriptexec)

## Contributing
See [contributing guide](.github/CONTRIBUTING.md)

<a name="history"></a>
## Release History

See [NEWS](NEWS.md)

<a name="license"></a>
## License
Developed by Sagie Gur-Ari and licensed under the Apache 2 open source license.
