use warnings;
use strict;

#perl rename.pl tmp temp
my ($origin, $replace) = @ARGV[0, 1];

foreach my $file (glob '*') {
    if ($file =~ m/^(.*)($origin)(.*)$/i) {
        my $new_file = "$1$replace$3";
        print $new_file, "\n";
        rename $file, $new_file;
    }
}
