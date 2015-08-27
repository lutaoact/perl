use warnings; use strict;
my $val;
sub canmod : lvalue
{
    $val;
}
sub nomod{
    $val;
}
canmod() = 5;
#nomod() = 5;
print $val, "\n";
