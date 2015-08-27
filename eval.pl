#!/usr/bin/perl
use warnings; use strict;
eval
{
    eval
    {
        die "I got first error";
    };
    print $@ if $@;
    print "I got second error";
};
print $@ if $@;
