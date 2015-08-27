use warnings;
use strict;

#my $dynamic_regex = qr/^(\d)+(??{"X{$1}"})/;#动态正则结构
#if ('3XXXX' =~ /$dynamic_regex/) {
#    print 'in';
#}

my $str = '  functionName: (value)';
if ($str =~ /(\s+)([^@\$]+)(:\s*\(.+\))/) {
  $str =~ s/(\s+)([^@\$]+)(:\s*\(.+\))/$1\$$2$3/;
  print $1, $2, $3, "\n";
  print $str;
}
