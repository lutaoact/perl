#!/usr/bin/perl
use warnings; use strict;
my $str = "240-2012-08-01.html";
if ($str =~ /(\d{3}-(\d{4}-\d{2}-\d{2}).html)/)
{
    print $1, "\n";
    print $2, "\n";
}
