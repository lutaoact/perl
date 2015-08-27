use warnings; use strict;
package UseMe;
sub import
{
    my $callpkg = caller(0);#get the name of the current package
    *{$callpkg::test} = [1, 2, 3, 4];
    *{$callpkg::test} = sub { 1 };
}
1;
