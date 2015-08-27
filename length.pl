#!/usr/bin/perl
use warnings; use strict;
#use utf8;
use Encode;
my $var = "经世济国";
$var = decode("utf8", $var);
print length($var);
