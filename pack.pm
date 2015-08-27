{
    package D; 
    use strict;
    use warnings;
    sub a { print "I am in D\n";}
    1;
}
{
    package E;
    use strict;
    use warnings;
    use base qw/D/;
    sub new
    {
        my $self = {};
        bless $self;
    }
    sub a
    {
        my $class = $_[0];
        $class->SUPER::a unless (ref $class);
    }
    1;
}
my $obj = E->new;
E->a;
