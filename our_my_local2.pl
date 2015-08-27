use warnings; #use strict;#会报错
package A;
our $value1 = 1;
my $value2 = 2;
local $value3 = 3;
print join(", ", keys %A::);
