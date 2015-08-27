use warnings;
use strict;

use JSON;
use Data::Dumper;

#cat tmp.txt | perl script/util/create_asset_version.pl

my $asset_version_path = 'config/asset/version.json';

my $JSON = JSON->new()->allow_nonref();
my $json_text = read_file($asset_version_path);
my $asset_versions = $JSON->decode($json_text);

my $current_time = qx{date +'%Y%m%d%H%M'}; chomp $current_time;
my @images = map { chomp; $_ } <>;
push @$asset_versions, {
    assetVersion => "V$current_time",
    fileList     => \@images,
};
#print Dumper $asset_versions;
write_file($asset_version_path, $JSON->pretty->encode($asset_versions));

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
