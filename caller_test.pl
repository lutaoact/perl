#!/usr/bin/perl
package hello;
sub a
{
    my $b = caller;
    print "$b\n";
}
&a;
