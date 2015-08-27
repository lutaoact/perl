use warnings; #use strict;
package UseMe2;
use Exporter();
@ISA = qw(Exporter);
@EXPORT = qw(test);
my $callpkg = caller(0);
@test = [1, 2, 3, 4];
sub test{1};
sub import
{
    UseMe2->export_to_level(1, @EXPORT);
}
1;
