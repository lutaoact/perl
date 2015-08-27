use warnings;
use strict;

my @arr = (-2, 11, -4, 13, -5, 2, -5, -3, 12, -9);
print max_sub_sequence_sum(@arr), "\n";
print max_sub_sequence_sum2(@arr), "\n";

sub max_sub_sequence_sum {
    my @arr = @_;
    my $max = $arr[0];
    for my $i (0 .. @arr - 1) {
        my $v = 0;
        for my $j ($i .. @arr - 1) {
            $v += $arr[$j];
            if ($v > $max) {
                $max = $v;
            }
        }
    }
    return $max;
}

sub max_sub_sequence_sum2 {
    my @arr = @_;
    my ($max, $temp_sum) = (0, 0);
    for my $i (0 .. @arr - 1) {
        $temp_sum += $arr[$i];
        if ($temp_sum > $max) {
            $max = $temp_sum;
        } elsif ($temp_sum < 0) {
            $temp_sum = 0;
        }
    }
    return $max;
}
