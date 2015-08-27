use warnings;
use strict;

my $str = q{http://example.com/:@-._~!$&'()*+,=;:@-._~!$&'()*+,=:@-._~!$&'()*+,==?/?:@-._~!$'()*+,;=/?:@-._~!$'()*+,;==#/?:@-._~!$&'()*+,;=};

#              协议     主机 路径 路径参数     查询参数     锚位
if ($str =~ m{(http)://(.+?)(/.+?);(.+?)=(.+?)\?(.+?)=(.+?)\#(.+)}) {
  print "协议：      $1\n";
  print "主机：      $2\n";
  print "路径：      $3\n";
  print "路径参数名：$4\n";
  print "路径参数值：$5\n";
  print "查询参数名：$6\n";
  print "查询参数值：$7\n";
  print "锚位：      $8\n";
}