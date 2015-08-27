use strict;
use warnings;
use JSON;
use Data::Dumper;

my $basic_xinqiao_info = read_file('basic_xinqiao_info.txt');
my @infos = split /\s+-+\s+/, $basic_xinqiao_info;
#print Dumper @infos;
#print $infos[3];
my $map = {
  'Institue:' => 'institues',
  'Majors:'   => 'majors',
  'History:'  => 'histories',
  'Leaders'   => 'leaders'
};

my $middle_result = {};
for my $info (@infos) {
  if ($info =~ /(\S+):*/) {
    my $category = $map->{$1};
    while ($info =~ /private\s+static\s+String\s+(\S+)\s+=\s*"(.+?)";/sg) {
      my ($key, $content) = ($1, $2);
      $content =~ s/\\n"\s+\+\s+"\s*//g;
      $middle_result->{ $category }->{ $key } = $content;
    }
  }
}
#print Dumper $middle_result;

my $final_result = {name => '新侨'};
for my $key (keys %{ $middle_result->{majors} }) {
  if ($key =~ /(.*)detail/) {
    my $name = $1;
    push @{ $final_result->{majors} }, {
      name   => $middle_result->{majors}->{"${name}Zhu"},
      desc   => $middle_result->{majors}->{"${name}Fu"},
      detail => $middle_result->{majors}->{"${name}detail"},
    };
  }
}
for my $key (keys %{ $middle_result->{institues} }) {
  if ($key =~ /(.*)detail/) {
    my $name = $1;
    push @{ $final_result->{institues} }, {
      name   => $middle_result->{institues}->{"${name}"},
      detail => $middle_result->{institues}->{"${name}detail"},
    };
  }
}
for my $key (keys %{ $middle_result->{leaders} }) {
  if ($key =~ /(.*)detail/) {
    my $name = $1;
    push @{ $final_result->{leaders} }, {
      desc   => $middle_result->{leaders}->{"${name}"},
      detail => $middle_result->{leaders}->{"${name}detail"},
    };
  }
}
for my $key (keys %{ $middle_result->{histories} }) {
  if ($key =~ /(\d+)/) {
    my $year = $1;
    push @{ $final_result->{histories} }, {
      year   => ~~$year,
      desc   => $middle_result->{histories}->{"Str${year}"},
    };
  }
}
print Dumper $final_result;
write_file('basic_xinqiao_info.json', json_encode($final_result));
#print Dumper json_decode(read_file('basic_xinqiao_info.json'));
#print read_file('basic_xinqiao_info.json');


sub read_file {
    my ($file) = @_;
    return do {
        local $/;
        open my $fh, '<', $file or die "$!";
        <$fh>
    };
}

sub write_file {
    my ($file, $text) = @_;
    open my $fh, '>', $file or die "$!";
    print $fh $text;
    close $fh;
}

sub json_decode {
    my ($json_text) = @_;
    my $JSON = JSON->new->utf8(1)->allow_nonref;
    return $JSON->decode($json_text);
}

sub json_encode {
    my ($json_obj) = @_;
    my $JSON = JSON->new->allow_nonref;
    return $JSON->pretty->encode($json_obj);
}
