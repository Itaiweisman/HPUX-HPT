# INFINIDAT Snapshot Handling Utility for HPUX
## Written By Itai Weisman

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
./set_creds.pl
````
Box name, user and password will be asked


## Modules in use:
REST::Client
JSON
MIME::Base64
Data::Dumper
Switch
Term::ReadKey
