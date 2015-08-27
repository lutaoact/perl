#!/usr/bin/perl
use strict; use warnings;
sub paint
{
    my $color = $_[0];
    return sub {
        my $object = $_[0];
        print "Paint the $object $color.\n";
    }#工厂模式创建闭包
}
my $p1 = paint("red");
my $p2 = paint("blue");
$p1->("flower");
$p2->("sky");
