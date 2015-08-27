#!/usr/bin/perl
use warnings;
use strict;
foreach ( 100 .. 116 ) {
    my $bit = "Just another perl hacker,";
    vec( $bit, $_, 1 ) = 0;
    print "$bit\n";
    print "$_\n";
}
