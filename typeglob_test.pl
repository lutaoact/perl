use warnings; use strict;
package TypeGlob;
package main;
use Data::Dumper;
*TypeGlob::a_simple_name = [1, 2, 3, 4];
*TypeGlob::a_simple_name = sub {1};
foreach (keys %TypeGlob::)
{
#print $_, "\n";
    local *TypeGlob::sym = $TypeGlob::{$_};
    if ($_ eq 'a_simple_name')
    {
        print "\@$_ is nonnull\n" if @TypeGlob::sym;
        print "\&$_ is nonnull\n" if &TypeGlob::sym;
    }
}
*TypeGlob::alias_to_simple_name = \@TypeGlob::a_simple_name;
*TypeGlob::alias_to_simple_name = \&TypeGlob::a_simple_name;
#print Data::Dumper->Dump([*TypeGlob::alias_to_simple_name{ARRAY}], [qw(*alias_to_simple_name)]);
#print Dumper(\@TypeGlob::alias_to_simple_name);
print &{*TypeGlob::alias_to_simple_name{CODE}};#typeglob本身就是一个散列，它的值就是各种类型的引用
#print Dumper(\%TypeGlob::);
