#!/usr/bin/perl
use warnings; use strict;
use Data::Dumper;
package Bar;
our $glarch = 1;
our @glarch = (1, 3);
our %glarch = qw/2 4/;

sub glarch {
    return 1;
}


package main;
identify_typeglob(*Bar::glarch);
#identify_symble_table(%Bar::);

sub identify_typeglob
{
    my ($glob) = @_;
#    print Dumper $glob;
    print "You give me ", *{$glob}{PACKAGE}, '::', *{$glob}{NAME}, "\n";
    print *{$glob}{SCALAR}, "\n";
    print ${*{$glob}{SCALAR}}, "\n";
    print *{$glob}{ARRAY}, "\n";
    print @{*{$glob}{ARRAY}}, "\n";
    print *{$glob}{HASH}, "\n";
    print %{*{$glob}{HASH}}, "\n";
    print *{$glob}{CODE}, "\n";
    print &{*{$glob}{CODE}}, "\n";
    print *{$glob}{CODE}->(), "\n";
#    print *{$glob}{IO}, "\n";
#    while( my ($key, $value) = each (*{$glob}) ) {
#        print "$key => $value\n";
#    }
    return;
}

sub identify_symble_table {
    my (%symble) = @_;
    print "*" x 20, "\n";
    while(my ($key, $value) = each %symble) {
        print "$key => $value\n";
    }
    print "*" x 20, "\n";
    return;
}
