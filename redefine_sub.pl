#!/usr/bin/perl
use warnings; use strict;
sub sub1
{
    my $text = shift;
    print "$text there!\n";
}
sub sub2
{
    my $text = shift;
    print "$text everyone!\n";
}
sub1('hello');
*sub1 = \&sub2;
sub1('hello');
