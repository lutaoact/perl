#!/usr/bin/perl
use warnings; use strict;
use File::Find qw(find);

my ($wanted, $reporter) = find_by_regex(qr/.pl/);
my @search_dirs = qw/. /;
find($wanted, @search_dirs);
my @files = $reporter->();
print "@files";
sub find_by_regex {
    require File::Spec::Functions;
    require Carp;
    require UNIVERSAL;

    my $regex = shift;
    unless(UNIVERSAL::isa($regex, ref qr//)) {
        Carp::croak "Argument";
    }

    my @files = ();
    sub {
        push @files,
            File::Spec::Functions::canonpath($File::Find::name) if m/$regex/;
    },
    sub {
        wantarray ? @files : [@files];
    }
}

