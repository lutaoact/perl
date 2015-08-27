#!/usr/bin/perl
use warnings; use strict;
use utf8;
sub nice_string
{
    join("",
        map {
            $_ > 255 ?
            sprintf("\\x{%04X}", $_) :
            chr($_) =~ /[[:cntrl:]]/ ?
            sprintf("\\x%02X", $_) :
            quotemeta(chr($_))
        } unpack ("w*", $_[0])
    );
}
#print nice_string("foo\x{100}好\n");
print nice_string("好\n");
print nice_string("人\n");
print nice_string("好人\n");
print nice_string("\n");
