#!/usr/bin/perl
use warnings; use strict;
use Benchmark;
our $b = 1.234;
timethese(
    1_000_000,
    {
        control => q{my $a = $b},
        sin     => q{my $a = sin $b},
        log     => q{my $a = log $b},
    }
);
