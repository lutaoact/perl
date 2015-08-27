#!/usr/bin/perl
use warnings; use strict;
use Doubler;
my $data;
tie $data, 'Doubler', $$;
$data = 10;
#$data= 10;
print $data, "\n";
