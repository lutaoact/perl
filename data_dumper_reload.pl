#!/usr/bin/perl
use warnings; use strict;
open my $fh, '<', 'data_dumped.txt';
my $data = do
{
    local $/;
    <$fh>;
};
=cut1
my $data = do {
    if (open my $fh, '<', 'data_dumped.txt')
    {
        local $/;
        <$fh>;
    }
    else {undef};
};
=cut
my %hash;
my @array;
eval $data;
print "$hash{Fred}\n";
print "$array[0]\n";
