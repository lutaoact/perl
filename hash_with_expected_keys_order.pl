use warnings;
use strict;

use Data::Dumper;

#$ENV{PERL_HASH_SEED}    = 0x00;
#$ENV{PERL_PERTURB_KEYS} = 0;

print $ENV{PERL_HASH_SEED}, "\n";
print $ENV{PERL_PERTURB_KEYS}, "\n";

# PERL_HASH_SEED=0x00 PERL_PERTURB_KEYS=0 perl test.pl

my $hash1 = {
  keyc => 2,
  key1 => 1,
  keya => 3,
  keyb => 4,
};

my $hash2 = {
  keyc => 2,
  keya => 3,
  keyb => 4,
  key1 => 1,
};

print Dumper $hash1, $hash2;
#print join "\n", (keys %$hash1);
#print "\n";
#print join "\n", (keys %$hash1);
#print join "\n", (keys %$hash2);
