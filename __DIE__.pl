#!/usr/bin/perl
use warnings; use strict;
use Carp;
$SIG{__DIE__} = sub{
    local $Carp::CarpLevel = 1;
    &Carp::croak;
};
foo();
sub foo{bar()}
sub bar{die "Dying from bar \n";}
