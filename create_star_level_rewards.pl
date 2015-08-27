use warnings;
use strict;

use JSON;
use Data::Dumper;

# perl perl/create_star_level_rewards.pl > config/event/star_level_rewards.json 
my $rewards = {};
for my $star_level (qw/20 30 40 50/) {
    $rewards->{"star$star_level"} = {
        id => 1122,
        type => 2,
        value => 1,
    };
}
$rewards->{star10} = {
    id => '',
    type => 4,
    value => 100,
};

$rewards->{star5} = {
    id => '',
    type => 4,
    value => 50,
};

my $JSON = JSON->new()->allow_nonref();
print $JSON->pretty->encode($rewards);
