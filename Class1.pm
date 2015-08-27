package Class1;
sub new
{
    my ($class) = @_;
    my $self = {};
    $self->{NAME} = 'Christine';
    my $closure = sub {
        my ($obj, $name) = @_;
        if (defined($name))
        {
            $self->{NAME} = $name;
        }
        return $self->{NAME};
    };
    bless $closure, $class;
}
sub name
{
    &{$_[0]};
}
sub data
{
    my ($self, $data) = @_;
    if (defined($data))
    {
        $self->{DATA} = $data;
    }
    return $self->{DATA};
}
1;
