#!/usr/bin/perl
use warnings; use strict;
use File::Find;
find sub {
    #$File::Find::prune = 0 if /.*pl/;
    $File::Find::name =~ s#$File::Find::dir/##, 
    print "Here is a file: ", $File::Find::name, "\n" if /.*pl/;
}, '.';
