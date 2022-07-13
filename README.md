# Snap! C++ Archive

The following are projects that were moved out from our snapcpp and submodules
and made available here as archives.

These are not maintained.

Note that for some projects, they may have been moved from snapwebsites to
a contrib so it may still be supported, just under a different name. For
example, the cppthread, eventdispatcher, communicatord are projects that
were under snapwebsites library and projects and now these are separate
contribs.

Similarly, many of the files/functions that were in the snapwebsites library
were moved to a corresponding contrib project. Especially:

* addr -> libaddr
* email related lib -> libmimemail
* http releated lib -> edhttp
* log -> snaplogger
* plugins -> serverplugins
* snapcommunicator -> eventdispatcher (lib) / communicatord (service)
* snapconfig -> advgetopt
* snapdbproxy (and all of cassandra env.) -> will be replaced by snapdatabase
* snapexception -> libexcept
* snapfirewall -> iplock
* snapthread -> cppthread
* snapwatchdog -> sitter
* simple class -> snapdev (i.e. `file_content`, `glob_dir`, etc.)

One reason for having contribs instead of the large snapwebsites environment
is that it makes it a lot easier to write tests and maintain them. I still
do not have as many tests as I would like to have, but it's getting there.
(one you can easily add a test, it's easy to add a test!)
