#!/usr/bin/perl
use warnings; use strict;
my $encrypted = crypt "Hello", "ll";
my $salt = substr($encrypted, 0, 2);
chomp (my $input = <>);
print "right\n" if ($encrypted eq crypt $input, "ll");
