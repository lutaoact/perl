#!/usr/bin/perl
use warnings; use strict;
my @program;
push (@program, 'my $i = 1;');
push (@program, 'my $i = 3; my $j = 2; my $k = $i + $j');
push (@program, 'my $i = 3; my ($j, $k); return 24; $k = $i + $j');
foreach (@program)
{
    my $rtn = eval($_);
    print $rtn, "\n";
}
