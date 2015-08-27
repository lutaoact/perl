use warnings;
use strict;

my @arr = (1, 5, 6, 2, 3, 4, 7, 8, 9, 8, 10);

for my $i (0 .. @arr - 2) {
    my $k = $i;
    for my $j ($i + 1 .. @arr - 1) {
        if ($arr[$j] < $arr[$k]) {
            $k = $j;
        }
    }
    #swap $arr[$i] $arr[$k];
    if ($k != $i) {
        $arr[$k] = $arr[$k] - $arr[$i];
        $arr[$i] = $arr[$k] + $arr[$i];
        $arr[$k] = $arr[$i] - $arr[$k];
#        my $tmp = $arr[$k];
#        $arr[$k] = $arr[$i];
#        $arr[$i] = $tmp;
    }
}
print "@arr";
