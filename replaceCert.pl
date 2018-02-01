use warnings;
use strict;

my $crt = read_file('/data/tmp/certs_for_git/token.crt');
chomp $crt;
my $key = read_file('/data/tmp/certs_for_git/token.key');
chomp $key;

my @files = @ARGV;
for my $file (@files) {
    print $file, "\n";
    my $content = read_file($file);
    $content =~ s/ {4}-----BEGIN CERTIFICATE-----.*-----END CERTIFICATE-----/$crt/s;
    $content =~ s/ {4}-----BEGIN RSA PRIVATE KEY-----.*-----END RSA PRIVATE KEY-----/$key/s;
    print $content;
    write_file($file, $content);
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
