#!/usr/bin/perl
use warnings; use strict;
my $text = 'hellllo world';
$text =~ tr/l/L/s;
print $text, "\n";
