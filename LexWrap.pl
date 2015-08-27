#!/usr/bin/perl
use warnings; use strict;
use Hook::LexWrap qw(wrap);
use Data::Dumper;

my ($m, $n);
$n = $ARGV[0] || 5;
$m = $ARGV[1] || 6;
wrap add,
     pre => sub{print "arguments: [@_]\n";
     },
     post=> sub{print "return value is $_[-1]\n";
     }
     ;

print "The sum of $n and $m is ". add($n, $n) . "\n";
sub add
{
    my ($n, $m) = @_;
    my $sum = $n + $m;
    return $sum;
}
