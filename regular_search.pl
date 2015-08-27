#!/usr/bin/perl
use warnings; use strict;
my $pop = '$33011.39843';
$pop =~ s/(?<!\.\d\d)(?<=\d)(?=(?:\d\d\d)+\b)/,/g;
print $pop;
