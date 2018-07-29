# INFINIDAT Snapshot Handling Utility for HPUX
# Credentials Saver Utility
## Written By Itai Weisman, Solution Engineering Team Leader, INFINIDAT.
### Change Control
#Version | Who          | What         | When
#------- | ------------ | ----------   | -------------
#1.0     | Itai Weisman | Gensis       | July 29th, 2018
#1.1     | Itai Weisman | Snap Refresh | July 29th, 2018
### Usage:
#perl ./set_creds.pl
#Box name, user and password will be asked
#

## Imports
use REST::Client;
use JSON;
use MIME::Base64;
use Data::Dumper;
use Switch;


## Functions
## Gets InfiniBox credentials from a file.
sub get_ibox_creds {
    $ibox=shift;
    $ibox_sec_file="." . $ibox .".sec";
    #print "sec file is $ibox_sec_file \n";
    open(F, '<', $ibox_sec_file) || die "cannot open security file";
    my $line=<F>;
    my $user=(split(' ',$line))[0];
    my $password=(split(' ',$line))[1];
    my $decoded_password=decode_base64($password);
    #print "user is $user \n";
    my %creds=("user" => $user, "password" => $decoded_password);
    return \%creds



}


## Reterive InfiniBox Object ID by its name, can be used for multiple object types (hosts, volumes etc)
sub getInfiniBoxSingleObjectByName {
        my $host=shift;
        my $user=shift;
        my $password=shift;
        my $objtype=shift;
        my $object=shift;
        my $namevar=shift;
        my @result=[];
        $namevar = defined $namevar ? $namevar : "name" ;
        our $headers = {Accept => 'application/json', Authorization => 'Basic ' . encode_base64($user . ':' . $password)};
        my $client = REST::Client->new();
        $client->setHost("http://$host");
        my $uri="/api/rest/". $objtype . "?" . $namevar ."=" .$object;
        $client->GET( $uri, $headers);
        $ok = eval {$response = from_json($client->responseContent());1};
	if (! $ok ) {
        print "Caught Error - Can't get response from $host \n";
		  return 0 ;
	}
        @result=$response->{'result'};
        @error=$response->{'error'};
        if ( @{$result[0]} )  {
                #print "Response from http://${host}/${uri} is not empty \n";
                
                 }
        else {
                print "Response from http://${host}/${uri} is empty \n";
                print  "Response is empty \n";
                if ($error[0]{'code'}) {
                        print "Caught Error - $error[0]{'message'} \n";
                        exit();
                }
                return {};
                }
        #return @result;
	%res=%{$result[0][0]};
	return $res{'id'};
	#print keys(%res);
	#return $result[0][0];
}

## Creates or refreshes a snapshot, from source or other snapshot.

sub CreateRefreshSnapshot {
    my $action=shift;
    my $host=shift;
    my $user=shift;
    my $password=shift;
    my $id=shift;
    my $snapname=shift;
    my %json_data;
    my $uri;
    #my $headers = {Content-Type => 'application/json',  Authorization => 'Basic ' . encode_base64($user . ':' . $password)};
	#print "headers are $headers \n";
    if ($action eq 'create') {
     %json_data = (
                        "parent_id" => $id,
                        "name" => $snapname
        );
    $uri="/api/rest/volumes/";

    }
    
    elsif ($action eq 'refresh') {
         %json_data = (
                        "source_id" => $id
        );
    $snap_id=getInfiniBoxSingleObjectByName($host,$user,$password,'volumes',$snapname);
    
    if ($snap_id) {
    $uri="/api/rest/volumes/". $snap_id . "/refresh?approved=true"; }
    else {print "Refresh Failed \n"; exit();}

    }
    
    else {print "problem \n"; return 0;}
    my $data = encode_json(\%json_data);
	#print "data is $data \n";
    
        my $post = REST::Client->new();
	   $post->addHeader('Content-Type', 'application/json');
    	$post->addHeader('Accept', 'application/json');
    	$post->addHeader('Authorization', 'Basic ' . encode_base64($user . ':' . $password));
        $post->setHost("http://$host");
        $post->POST ( $uri,$data);
        $ok = eval {$response = from_json($post->responseContent());1};
        if (! $ok ) {
         print "Caught Error - Can't get response from $host \n";
        }
        @result=$response->{'result'};
        @error=$response->{'error'};
        if ( $result[0])   {
                #print "Response is not empty \n";
                #print "Response from http://${host}/${uri} is not empty \n";


                 }
        else {
                 print "Response from http://${host}/${uri} is  empty \n";
                if ($error[0]{'code'}) {
                        #print "Caught Error - $error[0]{'message'} \n";
                       print "Caught Error - $error[0]{'message'} \n";
                       exit();

                }
                return 0;
                }
        #return 1;
            #print "print result is $result \n";
            %res=%{$result[0]};
            return $res{'id'};
}


## Mapping a snapshot(or volume) to a host
sub SnapMap {
 
    my $host=shift;
    my $user=shift;
    my $password=shift;
    my $id=shift;
    my $snap_id=shift;
    #$DevPword=$passowrd;
    #our $headers = {Accept => 'application/json', Authorization => 'Basic ' . encode_base64($user . ':' . $password)};
    my %json_data = (
                 
                        "volume_id" => $snap_id
        );
    my $data = encode_json(\%json_data);
	#print "Data is $data \n";
    my $uri="/api/rest/hosts/".$id."/luns";
        my $post = REST::Client->new();
        $post->addHeader('Content-Type', 'application/json');
        $post->addHeader('Accept', 'application/json');
     $post->addHeader('Authorization', 'Basic ' . encode_base64($user . ':' . $password));
        $post->setHost("http://$host");
        $post->POST ( $uri,$data);
        $ok = eval {$response = from_json($post->responseContent());1};
        if (! $ok ) {
         print "Caught Error - Can't get response from $host \n";
        }
        @result=$response->{'result'};
        @error=$response->{'error'};
        if ( $result[0])   {
                #print "Response is not empty \n";
                #print "Response from http://${host}/${uri} is not empty \n";


                 }
        else {
                 print "Response from http://${host}/${uri} is  empty \n";
                if ($error[0]{'code'}) {
                        #print "Caught Error - $error[0]{'message'} \n";
                       print "Caught Error - $error[0]{'message'} \n";
                       exit();

                }
                return 0;
                }
        return 1;
}


## print usage 
sub usage {
    print "Usage: \n";
    print "Create a snapshot: \n";
    print "perl ./snaphandle.pl create <ibox_name> <volume name> <snapshot name> \n";
    print "Map a snapshot to a host: \n";
    print "perl ./snaphandle.pl map <ibox_name> <snapshot name> <host name>\n";
    print "Refresh a snapshot: \n";
    print "perl ./snaphandle.pl create <ibox_name> <volume name> <snapshot name> \n";
    

     print "\n\n";
     exit();
}


### Program starts here
my ($box, $action, $item, $item_b)=@ARGV;
#print "action $action box $box item $item item_b $item_b \n";
usage() if (! $action or ! $box or ! $item or ! $item_b );
$credi=get_ibox_creds($box);
%creds=%{$credi};

switch ($action) {
    case "create" {
        $volume_name=$item;
        $snapshot_name=$item_b;
        $volume_id=getInfiniBoxSingleObjectByName($box,$creds{'user'},$creds{'password'},'volumes',$volume_name);
        print "Creating snapshot <$snapshot_name> to volume <$volume_name> \n";
        $snap_id=CreateRefreshSnapshot('create',$box,$creds{'user'},$creds{'password'},$volume_id,$snapshot_name);
    }
    case "refresh" {
        $volume_name=$item;
        $snapshot_name=$item_b;
        $volume_id=getInfiniBoxSingleObjectByName($box,$creds{'user'},$creds{'password'},'volumes',$volume_name);
        print "Refreshing snapshot <$snapshot_name> from volume <$volume_name> \n";
        $snap_id=CreateRefreshSnapshot('refresh',$box,$creds{'user'},$creds{'password'},$volume_id,$snapshot_name);
    }
    case "map" {
        $snapshot_name=$item;
        $host_name=$item_b;
        $host_id=getInfiniBoxSingleObjectByName($box,$creds{'user'},$creds{'password'},'hosts',$host_name);
        $snapshot_id=getInfiniBoxSingleObjectByName($box,$creds{'user'},$creds{'password'},'volumes',$snapshot_name);
        print "Mapping snapshot <$snapshot_name> to host <$host_name> \n";

        SnapMap($box,$creds{'user'},$creds{'password'},$host_id,$snapshot_id);  
    }
    else {usage() ; exit 0; }
} 

