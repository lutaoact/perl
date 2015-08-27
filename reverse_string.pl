use warnings;
use strict;

print reverse_word(reverse_string('hello world'));

sub reverse_string {
    my ($str) = @_;
    my @arr = split //, $str;
    for my $i (0 .. int((@arr + 1) / 2) - 1) {
        if ($i < @arr - 1 - $i) {
            swap($arr[$i], $arr[@arr - 1 - $i]);
        }
    }
    return join '', @arr;
}

sub reverse_word {
    my ($str) = @_;
    my @arr = split /(\s+)/, $str;

    FOR:
    foreach my $word (@arr) {
        if ($word =~ /^\s+$/) {
            next FOR;
        }
        $word = reverse_string($word);
    }
    return join '', @arr;
}

sub swap {
    $_[0] = $_[1] ^ $_[0];#a = b ^ a;
    $_[1] = $_[1] ^ $_[0];#b = b ^ a;
    $_[0] = $_[1] ^ $_[0];#a = b ^ a;
}
