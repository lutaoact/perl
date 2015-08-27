use warnings;
use strict;

open my $english, '>', 'english.txt';
open my $chinese, '>', 'chinese.txt';

my ($english_text, $chinese_text);
while (<>) {
    if (/^[a-zA-Z0-9]/) {
        unless (/^Unit/) {
            $english_text .= $_;
        }
    }
    elsif (/^\s*$/) {
    }
    else {
        s/(，|。|？|：|！)/${{'，' => ',', '。' => '.', '？' => '?', '：' => ':', '！' => '!'}}{$1}/g;
        $chinese_text .= $_;
    }
}

print $english $english_text;
print $chinese $chinese_text;
#print $english_text;
#print $chinese_text;
