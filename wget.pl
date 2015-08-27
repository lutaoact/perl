use warnings;
use strict;

my $BASE_URL = 'http://netlib.bell-labs.com/cm/cs/pearls/';

my $html = read_file('code.html');

while ($html =~ m/href="(.*\.(?:c[p]{0,2}|java))"/g) {
    print $1, "\n";
    `wget ${BASE_URL}$1`;
}

sub read_file {
    my ($file) = @_;
    return do {
        local $/;
        open my $fh, '<', $file or die "$!";
        <$fh>
    };
}
