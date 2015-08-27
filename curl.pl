use warnings;
use strict;

my $file = $ARGV[0] or die "no file name";

my $path = 'http://support.mobage.cn/autosign';
my $command = sprintf q{curl -F "signtype=autosign" -F "file=@%s" %s/upload_file.php}, $file, $path;
print $command;
my $response = qx{$command};
if ($response =~ m/href="(.*\.ipa)"/) {
    my $ipa = $1;
    qx{curl -O $path/$ipa};
}
__END__
perl curl.pl filename
