#!/usr/bin/perl
use warnings;
use strict;
my $line  = "just another perl hacker, perl hacker, and that's it!\n";
my @items = (
    [ qr/\G([a-z]+(?:'[ts])?)/i, "word" ],
    [ qr/\G(\n)/,                "newline" ],
    [ qr/\G(\s+)/,               "whitespace" ],
    [ qr/\G([[:punct:]])/,       "punctuation" ],
);

while (1) {
    my $match_end;
    foreach my $item (@items) {
        my ( $regex, $desc ) = @$item;
        next unless $line =~ /$regex/gc;
        $match_end = $1;
        print "Found a $desc [$1] \n";
    }
    last if ( $match_end eq "\n" );
}

