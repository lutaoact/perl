#!/usr/bin/perl
use warnings; use strict;
my $anon_sub_ref = sub {print "@_\n"};
&$anon_sub_ref('hello!');
$anon_sub_ref->('hello!');
