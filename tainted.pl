#!/usr/bin/perl -T
use warnings; use strict;
use Scalar::Util qw(tainted);
print "tainted\n" if tainted($ARGV[0]);
@ARGV = keys %{{map {$_, 1} @ARGV}};
print "not tainted\n" unless tainted($ARGV[0]);
print "@ARGV";
