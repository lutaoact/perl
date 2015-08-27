#!/usr/bin/perl
use warnings;
use strict;
$_ = "just another perl hacker";
m/(\S+)/g;
print "$1 \n";
print "@{[pos()]} \n";

pos() = index($_, 'h');
m/(\S+)/g;
print "$1 \n";
print "@{[pos()]} \n"; #You'd better not call a subroutine directly in the string. You can derefrence an array refrence instead which contains the return value of the subroutine. That's smart skill.
