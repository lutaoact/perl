#!/usr/bin/perl
use warnings; use strict;
my $decimal = 100;
my $binary = unpack("B32", pack("N", $decimal));
print $binary;
