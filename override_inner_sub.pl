#!/usr/bin/perl
use warnings; use strict;
use subs 'exit';
sub exit
{
    print "Do you really want to exit?";
    my $answer = <>;
    if ($answer =~ /^y/i){CORE::exit;}
}
while(1)
{exit;}
#需要覆盖内置子程序时，use subs 'subname';
