use warnings;
use strict;

use Data::Dumper;
my @arr1 = (1, 5, 6, 8, 10);
my @arr2 = (2, 3, 4, 7, 8, 9);

my @result;

my ($i, $j, $k) = (0, 0, 0);
while ($i < @arr1 && $j < @arr2) {
    if ($arr1[$i] <= $arr2[$j]) {
        $result[$k] = $arr1[$i];
        $i++;
    } else {
        $result[$k] = $arr2[$j];
        $j++;
    }
    $k++;
}
if ($i == @arr1) {
    while ($j < @arr2) {
        $result[$k] = $arr2[$j];
        $j++;
        $k++;
    }
} else {
    while ($i < @arr1) {
        $result[$k] = $arr1[$i];
        $i++;
        $k++;
    }
}
print "@result";
