use warnings;
use strict;

my $str = "abcacbdefdefjhhdefjjdfeabcdef";
print $str, "\n";
#$str =~ s/(def|abc)/${{abc => 'def', def => 'abc'}}{$1}/g;#引用解析，变量内插
$str =~ s/(def|abc)/{abc => 'def', def => 'abc'}->{$1}/eg;#e表示会执行代码
print $str, "\n";
