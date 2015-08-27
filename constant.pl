#!/usr/bin/perl
use warnings; use strict;
use constant ARRAY => [1 .. 4];
print ARRAY->[1];
ARRAY->[1] = "be changed";#ARRAY的值是一个数组引用，ARRAY的值无法改变，数组中的值是可以改变的，改变一个数组元素的值，这个数组的引用地址并不会改变，所以ARRAY的值也就没有改变，所以这样的修改是不会出现错误的
print ARRAY->[1];
