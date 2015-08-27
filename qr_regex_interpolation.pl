#!/usr/bin/perl
use warnings;
use strict;
my $string = ' aaa a';
my $name = '(.)\1{2}';
my $regex = eval { qr/\b$name\b/ } or die "Regex failed: $@";
#print ref $regex, "\n";
print "1 match\n" if $string =~ /$regex/;
print "2 match\n" if $string =~ /\b$name\b/;
