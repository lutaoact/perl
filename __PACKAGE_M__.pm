package __PACKAGE_M__;

use warnings;
use strict;

BEGIN
{
    use Exporter();
    our @ISA = qw(Exporter);
    our @EXPORT = qw(sub1);
}

sub sub1 { print __PACKAGE__ }

1;
