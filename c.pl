#!/usr/bin/perl
use warnings; use strict;
$_ = "ftp://ftp.uu.net/pub/systems";
if (m#^ftp://([^/]+)(/[^/]*)+#) {
    print "$1 \n";
    print "$2 \n"
}
__END__
my $file = do {
    local $/;
    open my $fh, '<', 'a.pl' or die;
    <$fh>;
};
print $file;

my $file;
{
    local $/;
    open my $fh, '<', 'a.pl' or die;
    $file = <$fh>;
}
