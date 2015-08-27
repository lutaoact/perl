#!/usr/bin/perl
use warnings; use strict;
my ($first, $last, $ID, $extention);
open DATA, "<dat/format.dat" or die "can't open";
open OUT, ">> dat/report.dat" or die "Can't open file";
format standardformat_TOP =
@>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
"Page $%"
            Employees
FirstName   LastName   ID     Extention
---------------------------------------
.
format standardformat =
@<<<<<<<<<<<@<<<<<<<<<<@<<<<<<@<<<<
$first, $last, $ID, $extention
.
select OUT;
$~ = 'standardformat';
$^ = 'standardformat_TOP';
$= = 3;
while(<DATA>)
{
    my @ary = split;
$first = $ary[0];
$last = $ary[1];
$ID = $ary[2];
$extention = $ary[3];
write;
}
close;
