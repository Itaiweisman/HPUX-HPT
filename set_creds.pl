# INFINIDAT Snapshot Handling Utility for HPUX
## Written By Itai Weisman, Solution Engineering Team Leader, INFINIDAT.
### Change Control
#Version | Who          | What       | When
#------- | ------------ | ---------- | -------------
#1.0     | Itai Weisman | Gensis     | July 29th, 2018
### Usage:

## perl ./set_creds.pl
## Will be prompted to enter a box name, user and password 


use MIME::Base64;
use Term::ReadKey;

print "Enter Box Name \n";
$box=<STDIN>;
chomp $box;
if (! $box) { die "invalid box name \n " };

print "Enter Username \n";
$user=<STDIN>;
chomp $user;
if (! $user) { "invalid username \n" };

print "Enter password \n";
ReadMode('noecho');
my $password = <STDIN>;
chomp $password;
ReadMode(0);

if (! $password) { die "invalid password  \n" };

$enc_password=encode_base64($password);
chomp $enc_password;
$passfile="./.". $box .".sec";
open(F,">",$passfile);
print F "$user $enc_password";
close(F);

