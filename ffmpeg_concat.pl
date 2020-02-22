use warnings;
use strict;

# ffmpeg -i "concat:file1.mp3|file2.mp3" -acodec copy output.mp3

my $count = 0;
my $group;
my $command;
while (my $line = <>) {
  chomp $line;
  $count++;
  push @$group, "mp3_dup5/" . $line;
  if ($count % 5 == 0) {
    $command = qq{ffmpeg -i "concat:@{[join "|", @$group]}" -acodec copy mp3_out/@{[sprintf "%02d", int $count/5]}.mp3};
    print $command, "\n";
    system($command);
    $group = [];
    next;
  }
}

$command = qq{ffmpeg -i "concat:@{[join "|", @$group]}" -acodec copy mp3_out/@{[sprintf "%02d", (int $count/5) + 1]}.mp3};
print $command, "\n";
