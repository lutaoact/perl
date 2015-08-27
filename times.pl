use Benchmark;
use warnings;
use strict 'refs';
my @start = times;
my @mem   = 1;
my $sum     = 0;
foreach $_ (@mem .. 10000000)
{
    $sum += $_;
}
my @end   = times;
my @diffs = map { $end[$_] - $start[$_] } 0 .. $#end;
print "@diffs";
