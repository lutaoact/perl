#!/usr/bin/perl
use warnings; use strict;
package A;
use Data::Dumper;
#my $var1 = 1;
our $var = 1;
{
    local $var = 2;
    print $var, "\n";
}
print $var, "\n";
#print Dumper(\%A::);
