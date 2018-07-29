use REST::Client;
use JSON;
use MIME::Base64;
use Data::Dumper;

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
                print "Response from http://${host}/${uri} is not empty \n";
                
                 }
        else {
                print "Response from http://${host}/${uri} is empty \n";
                print  $d "Response is empty \n";
                if ($error[0]{'code'}) {
                        print "Caught Error - $error[0]{'message'} \n";
                }
                return {};
                }
        #return @result;
	%res=%{$result[0][0]};
	return $res{'id'};
	#print keys(%res);
	#return $result[0][0];
}


sub CreateSnapshot {
 
    my $host=shift;
    my $user=shift;
    my $password=shift;
    my $id=shift;
    my $snapname=shift;
    #$DevPword=$passowrd;
    my $headers = {Content-Type => 'application/json',  Authorization => 'Basic ' . encode_base64($user . ':' . $password)};
	print "headers are $headers \n";
    my %json_data = (
                        "parent_id" => $id,
                        "name" => $snapname
        );
    my $data = encode_json(\%json_data);
	print "data is $data \n";
    my $uri="/api/rest/volumes/";
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
                print "Response from http://${host}/${uri} is not empty \n";


                 }
        else {
                 print "Response from http://${host}/${uri} is  empty \n";
                if ($error[0]{'code'}) {
                        #print "Caught Error - $error[0]{'message'} \n";
                       print "Caught Error - $error[0]{'message'} \n";;

                }
                return 0;
                }
        #return 1;
            %res=%{$result[0][0]};
            return $res{'id'};
}

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
	print "Data is $data \n";
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
                print "Response from http://${host}/${uri} is not empty \n";


                 }
        else {
                 print "Response from http://${host}/${uri} is  empty \n";
                if ($error[0]{'code'}) {
                        #print "Caught Error - $error[0]{'message'} \n";
                       print "Caught Error - $error[0]{'message'} \n";;

                }
                return 0;
                }
        return 1;
}
sub usage {
    print "Usage: \n";
    print "Create a snapshot: \n";
    print "./snaphandle create <volume name> <snapshot name> \n";
    print "Map a snapshot to a host: \n";
    print "./snaphandle map <snapshot name> <host name> \n\n\n\n";
}
usage();
$id=getInfiniBoxSingleObjectByName('ibox1499','iscsi','123456','volumes','itai');
$host_id=getInfiniBoxSingleObjectByName('ibox1499','iscsi','123456','hosts','kuku');
print "ID is $id ; host ID is $host_id \n";
$snap_id=CreateSnapshot('ibox1499','iscsi','123456',$id,'hpux1-snap');
print "snap ID is $snap_id \n";
SnapMap('ibox1499','iscsi','123456',$host_id,$snap_id);

### Program starts here
#my ($volume, $action, $host_or_name)=@ARGV;
#switch ($action) {
 #   case "create" {snap_create($volume, $name, )}
 #   case "map" {}
 #   else {usage() ; exit 0; }
#} 

