# scriptexec

> Run complex native scripts with a single command, similar to system commands.

* [Overview](#overview)
* [Usage](#usage)
* [Installation](#installation)
* [API Documentation](https://sagiegurari.github.io/scriptexec/)
* [Contributing](.github/CONTRIBUTING.md)
* [Release History](#history)
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
output <- scriptexec::script_execute('echo Current Directory:\ndir')
cat(sprintf('%s\n', output))

#execute multiple commands as a script
output <- scriptexec::script_execute(c('cd', 'echo User Home:', 'dir'))
cat(sprintf('%s\n', output))
````

<a name="installation"></a>
## Installation
In order to use this library, run the following command:

```r
install.packages("lintr")
```

Or install latest version from github:

```r
devtools::install_github("sagiegurari/scriptexec")
```

## API Documentation
See full docs at: [API Docs](https://sagiegurari.github.io/scriptexec/)

## Contributing
See [contributing guide](.github/CONTRIBUTING.md)

<a name="history"></a>
## Release History

| Date        | Version | Description |
| ----------- | ------- | ----------- |
| 2017-11-06  | v0.1.6  | Maintenance |
| 2017-11-04  | v0.1.1  | Initial release. |

<a name="license"></a>
## License
Developed by Sagie Gur-Ari and licensed under the Apache 2 open source license.
