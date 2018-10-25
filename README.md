# INFINIDAT Snapshot Handling Utility for HPUX
## Written By Itai Weisman, Solution Engineering Team Leader, INFINIDAT.

### Change Control
Version | Who	| What | When 
---- | ---- | ---------- | ------------- 
1.0	| Itai Weisman | Gensis	| July 29th, 2018 
1.1	| Itai Weisman | Snap Refresh	| July 29th, 2018 

### About
Host PowerTools and infinishell are currently not provided for HPUX. the Python distribution avaialble on HPUX is also not very stable and do not allow using infinisdk or similar. to mitigate this, I wrote this tool which is avaialble for HPUX releases and written in perl. it uses some perl modules including REST::Client. a compiled and link version (using perl2exe) is also avaiable.

### Usage:

#### For Creating Snapshot 
````
perl ./snaphandle.pl create <ibox_name> <volume name> <snapshot name>
````

#### For Refreshing a Snapshot 
````
perl ./snaphandle.pl refresh <ibox_name> <volume name> <snapshot name>
````

#### For Mapping Snapshot To Host 

````
perl ./snaphandle.pl create <ibox_name> <snapshot name> <host name>
````



### Setting Credentails 
```
perl ./set_creds.pl
````
Box name, user and password will be asked


## Modules In Use
REST::Client, 
JSON, 
MIME::Base64, 
Data::Dumper, 
Switch, 
Term::ReadKey
