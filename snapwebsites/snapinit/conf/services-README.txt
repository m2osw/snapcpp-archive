
    This directory defines a set of services, one service per file,
    that snapinit will start on a server. snapinit itself does not
    define such a file. The following documents the understood tags
    and attributes:

      <service>   Define a service using sub-tags as shown below.

        attributes: name      Define the name of the service, in general
                              this is the same as the name of the executable.

                    disabled  Define whether the service should be started
                              or not. If disabled is present, ignore that
                              entry. This makes it easier to keep all the
                              entries and just disable those you do not
                              want to run on a specific server.

                    required  Says that this service is required. This means
                              that if it fails to start, then snapinit as
                              a whole fails (i.e. it cannot sensibly be
                              removed from the list of running processes.)

      <service>
      <dependencies>
                  Let snapinit know of dependencies to a service. For
                  example, to start snapserver we need to have snaplock
                  and snapdbproxy registered. We also want to have
                  snapfirewall for security reasons.

                  The tag expects a list of service names that have to be
                  registered (see definition of "registered" below) before
                  this very service gets started.

      <service>
      <dependencies>
      <dependency>
                  Define the name of a dependency that has to be registered
                  before this very service gets started.

                  Note that "registered" in our case means up and running
                  in terms of Unix process and REGISTERed with
                  snapcommunicator. Without that registration, the
                  process is considered to be in an intermediate state
                  which is not enough to satisfy the dependency.

                  Also, if a service has a <safe> message defined, registered
                  means:
                  
                  * Unix process running,
                  * REGISTER message received, and
                  * SAFE message received and matching the expected safe
                    message.

        attributes: weak      Mark that dependency as a weak dependency.
                              If that service exists, then it has to be
                              registered for this dependency to be
                              satisfied. If the service is not installed
                              on that machine, then to this service can
                              be started even without that dependency.
                              So a dependency such as:
                              
                       <dependency weak="weak">firewall</dependency>

                              means that if the firewall is one of the
                              services, we will wait on it before starting,
                              otherwise we just start without it (since it
                              will never appear if not installed.)

      <service>
      <priority>  Define a service priority; this parameter must be a
                  number between -100 and +100. The smaller the value,
                  the higher the priority. Services with a higher priority
                  get started first (see also <dependencies>).

                  The system waits one second between starts, so it gives
                  one second to a service to start before the next service
                  starts.

      <service>
      <wait>      Define the number of seconds to wait before
                  attempting to start the next service. If not present,
                  use the default of 1 (one second).

                  We use a minimum of 1 to avoid problems with starting
                  too many executables all at once which often does not
                  work that well on a small VPS server.

      <service>
      <safe>      Define a name that will be sent to snapinit via Snap
                  Communicator. Until that message is received, the
                  snapinit system blocks waiting for the message. No
                  other service can be started until then.

                  If the snapinit service receives an invalid name, then
                  the initialization process stops and the Snap! server
                  does not start. If it "never" receives the name, it
                  will wait forever. (TODO: we should have a timeout
                  for this case because if the process fails starting
                  we should not block forever, but quit.)

      <service>
      <config>    Define the path and filename of the configuration file
                  for this service. Pretty much all services will load a
                  default configuration file from /etc/snapwebsites if
                  you do not specify this tag.

      <service>
      <snapcommunicator>
                  Request that snapinit attempts a connection to this
                  service once started. In this case snapinit blocks
                  until the connection happens. It is assumed that
                  without this connection, the start process fails.
                  The parameter is an IP address and port separated
                  by a colon as in:
                  
                      <snapcommunicator>127.0.0.1:4040</snapcommunicator>

      <service>
      <snapdbproxy>
                  Define the IP address and port to use to connect to
                  the snapdbproxy service and ultimately to the Cassandra
                  database. By default this is 127.0.0.1:4042.

                  This parameter is passed down to the other services
                  started by snapinit.

      <service>
      <command>   Define the path and name of the command. The path is
                  optional and if not specified the standard Unix PATH
                  variable is used to find the command. You may also
                  use the -.-binary-path option (without the '.') to
                  specify a path. The command is particularly useful
                  when the name of the service (see <service> name
                  attribute above) is different from the name of the
                  command we have to run to start the service.

                  By default a command is expected to stick. You
                  may run commands that exit and restart them at
                  a given schedule using the <cron> tag.

      <service>
      <options>   Define static command line options to be added to
                  the call. For example, you could add the -.-debug
                  option (without the . but we are in an XML comment!)
                  to get debug information while running that process.
                  Please make sure to first check what options that
                  service supports. Note that the debug flag is
                  automatically passed down when the snapinit daemon
                  is started in debug mode.

      <service>
      <cron>      Define an interval defining ticks when this service
                  should run. The ticks are assumed to have started
                  on Jan 1, 2012 at midnight (all balls.) This is used
                  as a CRON system for Snap! to run certain processes
                  regularly, but using snapinit so that way we can
                  cleanly and safely stop the process if the user
                  requests a shutdown or other similar actions that
                  would require Snap! to stop. This feature makes
                  use of a file under /var/spool/snapwebsites/snapinit
                  to know when the last run happened. If more than one
                  tick, then a run is started as soon as possible
                  (although we give the other services some time to
                  get started before we start the CRON process.)

                  The value must be either "off" or a number between
                  60 and 31708800 which represents the number of
                  seconds between runs. The larger value represents
                  about 1 year. The minimum is likely to not be very
                  useful (i.e. if the process takes 10 minutes to run,
                  trying to have it run every minute will not really
                  make much of a difference.) The default is "off".
                  The expected value for the snapback tool is 300
                  (i.e. 5 min.)

      <service>
      <recovery>  The number of seconds to recover a failed
                  process. In general, when a process crashes,
                  we retry very quickly to restart it. If all
                  those attempts fail, then we generally mark
                  the service as failed and remove it from our
                  list of services. If this parameter is defined,
                  then we will try yet again after that many
                  seconds. This is generally used for backends
                  with a value of about 60 seconds (1min.)

      <service>
      <nice>      Change the nice value of the specified process to
                  this integer. The nice value must be between 0 and
                  19 inclusive. Any other number will make the loading
                  of snap fail. You may also use the special value
                  "default", which at this time means do not change the
                  nice value (i.e. the same as not specifying the
                  <nice> tag.)

      <service>
      <user>      Define the name of the user the service should run as.

      <service>
      <group>     Define the name of the group the service should run as.

      <service>
      <coredump>  Define the size of the core dump file.
      
                  If set to "none" then the default behavior is preserved,
                  which is also the default if the tag is not defined.
                  The default behavior can be changed in your shell by
                  using `ulimit -c <size>` in bash or an equivalent
                  in another shell.

                  Otherwise the OS will be setup so that the child
                  process generate a core dump file on an error such
                  as SEGV or BUS error. To get the entire program in
                  the core dump file, use "infinity" as the size (as
                  in <coredump>infinity</coredump>.)

                  To the minimum, the core dump file must be one block
                  of memory, which is 1Kb on Linux. You may use a two
                  letter size instead of a number of bytes as in: 4Kb,
                  10Mb, 1Gb.

                  Remember that if the core dump is larger than this
                  size, it will be completely discarded. (i.e. if the
                  core dump file is going to be 6Mb and your limit
                  is 1Mb, you are not going to get the first 1Mb of
                  the dump. Instead, you get nothing.)

                  Changing coredump filename? try `man 5 core`

vim: ts=2 sw=2 et syntax=xml
