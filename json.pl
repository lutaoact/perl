use warnings;
use strict;
use JSON;
use TT;
use Data::Dumper;
my $file = 'localcn.js';
my $json_text = TT::read_file($file);

my $JSON = JSON->new->allow_nonref;
my $perl_ref = $JSON->decode($json_text);
my $setttings;
for my $key (keys %{$perl_ref->{dbs}}) {
    if ($key =~ /master/) {
        $setttings->{$key} = $perl_ref->{dbs}->{$key};
    }
}

if ($setttings->{common_master}->{isDefaultDb}) {
    print $setttings->{common_master}->{isDefaultDb};
} else {
    print "0";
}
#print Dumper $setttings;
