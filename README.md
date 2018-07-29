# INFINIDAT Snapshot Handling Utility for HPUX
## Written By Itai Weisman, Solution Engineering Team Leader, INFINIDAT.

### Change Control
Version | Who	| What | When 
---- | ---- | ---------- | ------------- 
1.0	| Itai Weisman | Gensis	| July 29th, 2018 
### Usage:

#### For Creating Snapshot 
````
perl ./snaphandle.pl create <ibox_name> <volume name> <snapshot name>
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
