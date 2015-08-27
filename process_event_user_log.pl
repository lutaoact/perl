use warnings;
use strict;

use Data::Dumper;
use List::Util qw/max sum/;
#open my $fh, '<', '/data/mgsys/log/wait_for_process_present.log';
open my $fh, '<', '/data/mgsys/log/hadoop_log_sap09.12000117.300101.log.[8].20140122';

my $RESULT = {};
while (my $line = <$fh>) {
    my ($user_id, $others) = (split /\t/, $line, 5)[3, -1];
    if ($others =~ /point:(\d+)/) {
        $RESULT->{$user_id} += $1;
    }
}
close $fh;
#print Dumper $RESULT;
my @sqls;
for my $mobage_id (keys %$RESULT) {
    my $total_point = $RESULT->{$mobage_id};
#    push @sqls, (sprintf "update event_user as a, user as b set a.total_point = %s where b.mobage_id = %s and b.id = a.user_id and a.event_id = 3001;", $RESULT->{$mobage_id}, $mobage_id);
    print "update event_user as a, user as b set a.total_point = $total_point where b.mobage_id = $mobage_id and b.id = a.user_id and a.event_id = 3001;", "\n";
}
#print join "\n", @sqls, "\n";
#print "update event_user as a, user as b set a.total_point = ? where b.mobage_id = ? and b.id = a.user_id";
