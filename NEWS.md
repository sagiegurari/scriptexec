# CHANGELOG

## 0.3.1

* Update dependencies #31
* Update windows build as building R dependencies is unstable

## 0.3.0

* Fixed bug which caused incorrect command line arguments setup #30
* Make travis mac builds optional as R support for mac on travis is unstable

## 0.2.3

* Add execute errors to output structure #27
* Add all dev dependencies to suggest field #23
* Share example code in unit test, readme and vignettes #21
* Add linter unit test #20
* Fix tests to pass on all platforms #24
* Fix example unit test #19
* Script output key checks in api stability unit tests #22
* Automatically test all demos
* Run mac build in travis #28
* Test specific R version in travis build
* More demos #25

## 0.2.2

* Output executed script #16
* Packrat integration to enable easier collaboration #14
* Generate readme dynamically #17
* Document only execute api in generated docs #15

## 0.2.1

* Support custom runner #9
* Support env vars for windows platform #11
* Support flag to print every command before invocation #12
* Markdown documentation hosted on github #10
* Consistent error handling for all platforms

## 0.2.0

* execute_script function renamed to execute
* Add support for command line arguments to be passed to the script #1
* Merge all output text instead of vector #5
* Add status 0 instead of null #6
* Pass env variables as part of script execution #7
* Add wait support #8
* Export all functions #4
* Add demos #3

## 0.1.0

* Initial Release
