use warnings;
use strict;

use MIME::Base64 qw/encode_base64 decode_base64/;

my $encoded = encode_base64('brian-totty:Ow!', '');
my $decoded = decode_base64($encoded);
print chomp $encoded;
print $decoded;
print $encoded;
#print $encoded, $decoded;
print length $encoded;
print length $decoded;
