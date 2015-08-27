use warnings;
use strict;

my $text = '<>&&<>';
$text =~ s/(<|>|&)/${{'<' => '&lt;', '>' => '&gt;', '&' => '&amp;'}}{$1}/g; #变量内插
print $text, "\n";
my $text2 = '<>&&<>';
$text2 =~ s/(<|>|&)/@{[{'<' => '&lt;', '>' => '&gt;', '&' => '&amp;'}->{$1}]}/g; #@{[]}插入运算
print $text2, "\n";
my $text3 = '<>&&<>';
$text3 =~ s/(<|>|&)/{'<' => '&lt;', '>' => '&gt;', '&' => '&amp;'}->{$1}/ge; #使用e修饰符
print $text3, "\n";
