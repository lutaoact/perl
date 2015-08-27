use warnings;
use strict;

use Getopt::Long;
use JSON;
use Data::Dumper;

=cut
use this script as follows:
$ perl script/deploy/deploy.pl --method=all/public --region=tw/cn [--cluster=1]
=cut

GetOptions (
    'method=s'  => \my $method,
    'region=s'  => \my $region,
    'cluster:i' => \my $cluster,
) or die "something is wrong in options";
$method or die 'no method is given';
$region or die 'no region is given';
$cluster ||= 1;

my $JSON_PATH = "config/deploy/servers.json";

my $json_text = do {
    local $/;
    open my $fh, '<', $JSON_PATH or die "$!";
    <$fh>
};
my $SERVER_LIST = JSON->new->decode($json_text);

my @commands;
for my $server (@$SERVER_LIST) {
    if ($method             eq 'public'
     && $server->{role}     eq 'nginx'
     && $server->{region}   eq $region
     && $server->{cluster}  eq $cluster
    ) {
        push @commands,
             (sprintf "make deploy-pulic server=%s", $server->{server_name});
    } elsif ($method             eq 'all'
          && $server->{role}     eq 'node'
          && $server->{region}   eq $region
          && $server->{cluster}  eq $cluster
    ) {
        push @commands,
             (sprintf "make deploy-all server=%s", $server->{server_name});
    }
}
my $multile_line_command = join "\n", @commands;
#print "$multile_line_command";
system "$multile_line_command";
