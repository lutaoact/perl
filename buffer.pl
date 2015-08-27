#!/usr/bin/perl
my @buffer;
@buffer = ({next=>1, data=>0}, {next=>2, data=>0}, {next=>3, data=>0}, {next=>0, data=>0});
my ($head, $tail) = (0, 0);
sub store
{
    if ($buffer[$tail]{next} != $head)
    {
        $buffer[$tail]{data} = $_[0];
        $tail = $buffer[$tail]{next};
        return 1;
    }
    else{return 0;}
}
sub retrieve
{
    if ($head != $tail)
    {
        my $data;
        $data = $buffer[$head]{data};
        $head = $buffer[$head]{next};
        return $data;
    }
    else {return undef;}
}
store 0;
store 1;
store 2;
store 3;
print retrieve, "\n";
print retrieve, "\n";
print retrieve, "\n";
