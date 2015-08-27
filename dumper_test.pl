#!/usr/bin/perl
use Data::Dumper;
use warnings; use strict;
my $my_scalar = "This is my scalar";
my @my_array = ("hello", "world", "123", 456);
my %my_hash = (itemA=>12.4, itemB=>1.72e30, itemC=>"bye/n");
#print Dumper($my_scalar, \@my_array, \%my_hash);
#print Dumper();
#print Dumper();
#my $dump_name = Data::Dumper->new([$my_scalar, \@my_array, \%my_hash], [qw(*my_scalar *my_array *my_hash)]);
#print $dump_name->Dump;
print Data::Dumper->Dump([$my_scalar, \@my_array, \%my_hash], [qw(*my_scalar *my_array *my_hash)]);
my @my_array2 = ([1, 2, 3], [4, 5, 6]);
print Dumper(\@my_array2);
