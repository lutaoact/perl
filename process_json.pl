use warnings;
use strict;

use JSON;
my $JSON_PATH = 'config/zone/step/*.json';
my @files = glob $JSON_PATH;
#my @files = ('1.json');
#print "@files";

my $JSON = JSON->new->allow_nonref;
for my $file (@files) {
    my $json_text = read_file($file);
    my $json_obj = $JSON->decode($json_text);
    write_file($file, $JSON->pretty->encode($json_obj));
}

sub read_file {
    my ($file) = @_;
    return do {
        local $/;
        open my $fh, '<', $file or die "$!";
        <$fh>
    };
}

sub write_file {
    my ($file, $text) = @_;
    open my $fh, '>', $file or die "$!";
    print $fh $text;
    close $fh;
}
