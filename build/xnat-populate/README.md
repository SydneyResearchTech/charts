# xnat-populate

## ISSUES

```
org.codehaus.groovy.control.MultipleCompilationErrorsException: startup failed:
/home/groovy/PopulateXnat.groovy: 23: unable to resolve class CliBuilder
 @ line 23, column 18.
   final CliBuilder cli = new CliBuilder(
                    ^

/home/groovy/PopulateXnat.groovy: 23: unable to resolve class CliBuilder
 @ line 23, column 24.
   final CliBuilder cli = new CliBuilder(
                          ^

/home/groovy/PopulateXnat.groovy: 52: unable to resolve class OptionAccessor
 @ line 52, column 22.
   final OptionAccessor params = cli.parse(args)
                        ^

/home/groovy/PopulateXnat.groovy: 92: unable to resolve class OptionAccessor
 @ line 92, column 17.
   String readUser(OptionAccessor params) {
                   ^

/home/groovy/PopulateXnat.groovy: 102: unable to resolve class OptionAccessor
 @ line 102, column 34.
   String readPassword(String user, OptionAccessor params) {
                                    ^

/home/groovy/PopulateXnat.groovy: 116: unable to resolve class OptionAccessor
 @ line 116, column 27.
   List<String> readProjects(OptionAccessor params) {
                             ^

/home/groovy/PopulateXnat.groovy: 137: unable to resolve class OptionAccessor
 @ line 137, column 31.
   List<String> readTciaProjects(OptionAccessor params) {
                                 ^

file:/home/groovy/org/nrg/populate/util/Globals.groovy: 17: unable to resolve class AntBuilder
 @ line 17, column 5.
       public static final AntBuilder antBuilder = new AntBuilder()
       ^

file:/home/groovy/org/nrg/populate/util/Globals.groovy: 17: unable to resolve class AntBuilder
 @ line 17, column 49.
   final AntBuilder antBuilder = new AntBui
                                 ^

9 errors
```
