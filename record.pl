#!/usr/bin/perl
use warnings; use strict;
sub record
{
    my ($value, $max, $min) = @_;
    if ($value <= $max && $value >= $min)
    {
        return {value=>$value, max=>$max, min=>$min};
    }
}
my $myrecord = record(100, 2000, 30);
print $myrecord, "\n";
print $myrecord->{value};
