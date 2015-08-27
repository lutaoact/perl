use warnings;
use strict;

use List::Util qw/max sum/;
use Data::Dumper;
my $RESULT;
my $float = qr/(\d+(?:\.\d+)?)/;
my $exclusive = qr/(?<!\.js)(?<!\.(?:png|css|jpg))/;
my $regex = qr/(?:GE|POS)T\s+(\S+?)$exclusive(?:\s|\?).+\s$float$/;
while (my $log = <>) {
    if ($log =~ m/$regex/) {
        my ($api, $time) = ($1, $2);
        push @{$RESULT->{$api}->{times}}, $time;
    }
}

for my $api (keys %{$RESULT}) {
    my @times = @{$RESULT->{$api}->{times}};
    $RESULT->{$api}->{cnt} = scalar @times;
    $RESULT->{$api}->{max} = max(@times);
    $RESULT->{$api}->{avg} = sum(@times) / scalar @times;
}

my @sort_by_max = sort {
    $RESULT->{$a}->{max} <=> $RESULT->{$b}->{max}
} keys %{$RESULT};

my @sort_by_avg = sort {
    $RESULT->{$a}->{avg} <=> $RESULT->{$b}->{avg}
} keys %{$RESULT};

print "api,max,avg,cnt\n";
for (@sort_by_avg) {
    print "$_,$RESULT->{$_}->{max},$RESULT->{$_}->{avg},$RESULT->{$_}->{cnt}\n";
}
