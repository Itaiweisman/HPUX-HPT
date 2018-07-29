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
print "enc_password is >$enc_password< \n";
$passfile="./.". $box .".sec";
open(F,">",$passfile);
print F "$user $enc_password";
close(F);

