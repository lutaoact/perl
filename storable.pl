#!/usr/bin/perl
use warnings; use strict;
use Storable qw(dclone store retrieve);
my @a1 = ([qw(apple orange)], [qw(asparagus corn peas)], [qw(ham chicken)]);
store (\@a1, "array.dat");
my @a2 = @{retrieve("array.dat")};
print $a2[1][1];
my $a3 = dclone(\@a1);
$a3->[1][1] = "squash";
print "$a1[1][1] $a3->[1][1]";
