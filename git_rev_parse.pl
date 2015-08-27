use warnings;
use strict;

chdir '/home/mgsys/code_test';
print `pwd`;
chomp (my $HEAD_0 = `git rev-parse HEAD\@{0}`);
chomp (my $HEAD_1 = `git rev-parse HEAD\@{1}`);
print "HEAD\@{0} => $HEAD_0";
print "\n";
print "HEAD\@{1} => $HEAD_1";
