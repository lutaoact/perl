#!/usr/bin/perl
use warnings;
use strict;

my $filename = $ARGV[0];
my $content = read_file($filename);

print qq{checking sql content: \033[1;32m$filename\033[0m\n};
while ($content =~ /(["'])((?:\\\1|.)*?)\1/g) {
  #print qq{\033[1;32m$&\033[0m\n};
  my $match = $2;
  if ($match =~ /\),\(/) {
    print qq{\033[1;31merror occured\033[0m, content is: \n$match\n};
    exit 1;
  }
}
print qq{check result: \033[1;32mok\033[0m\n};

sub read_file {
    my ($file) = @_;
    return do {
        local $/;
        open my $fh, '<', $file or die "$!";
        <$fh>;
    };
}
