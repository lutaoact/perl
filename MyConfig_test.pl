#!/usr/bin/perl
use warnings;
use strict;

use Data::Dumper;
use MyConfig;

my $columns = MyConfig::SETTING_COLUMNS();
print Dumper $columns;
