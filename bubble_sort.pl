use warnings;
use strict;

my @arr = (5, 6, 2, 3, 1, 4, 7, 8, 9, 8, 10);
@arr = (5, 6, 3, 9, 1, 4, 2, 7, 8, 8, 10);
my @expected = (1, 2, 3, 4, 5, 6, 7, 8, 8, 9, 10);
my @sorted = bubble_sort1(@arr);
print join ', ', @sorted;

for my $i (0 .. @sorted - 1) {
    if ($expected[$i] != $sorted[$i]) {
        die;
    }
}

sub bubble_sort1 {
    my @arr = @_;
    my $start = 0;
    while ($start <= @arr - 2) {
        for (my $i = @arr - 1; $i >= $start + 1; $i--) {
            if ($arr[$i - 1] > $arr[$i]) {
                swap($arr[$i - 1], $arr[$i]);
            }
        }
        print "@arr\n";
        $start++;
    }
    return @arr;
}

sub bubble_sort2 {
    my @arr = @_;
    my $final = @arr - 1;
    while ($final >= 1) {
        for my $i (0 .. $final - 1) {
            if ($arr[$i] > $arr[$i + 1]) {
                swap($arr[$i], $arr[$i + 1]);
            }
        }
        $final--;
    }
    return @arr;
}

sub swap {
    $_[0] = $_[1] - $_[0];#a = b - a;
    $_[1] = $_[1] - $_[0];#b = b - a;
    $_[0] = $_[1] + $_[0];#a = b + a;
}
