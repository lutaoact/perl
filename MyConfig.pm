package MyConfig;

use strict;
use warnings;
use base qw(Exporter);

my $config;

BEGIN {
    $config = {
        SETTING_COLUMNS => {
            key1 => 'value1',
            key2 => 'value2',
        },
    };
}

use constant $config;
our @EXPORT_OK = keys %{$config};

1;
