use warnings;
use strict;

use Encode qw/encode decode/;

$^I = '.bak';
while (my $line = <>) {
  print encode('utf-8', decode('gbk', $line));
}
