use warnings;
use strict;
use Data::Dumper;

use Hash::Ordered;
use Data::Structure::Util qw/unbless/;

my $oh = Hash::Ordered->new( a => 1 );
$oh->get( 'a' );
$oh->set( 'a' => 2 );
$oh->push( c => 3, d => 4 );

print Dumper unbless($oh);
