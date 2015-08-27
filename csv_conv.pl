use warnings;
use strict;

use YAML::Syck qw//;
use Getopt::Long;
use Text::CSV_XS;
use Path::Class;

GetOptions (
    'd=i' => \my $num_of_days,
    'h:i' => \my $num_of_hours,
) or die "something is wrong in options";
$num_of_days ||= 7;
$num_of_hours ||= 0;
my $offset = $num_of_days * 86400 + $num_of_hours * 3600;

my $work_dir = Path::Class::file($0)->parent();

my $config = YAML::Syck::LoadFile("$work_dir/csv_conv_config.yaml");
if (not -d "$work_dir/csv.beta") {
    `mkdir $work_dir/csv.beta`;
}
`cp $work_dir/csv.kr/* $work_dir/csv.beta/`;

my $csv = new Text::CSV_XS({binary => 1});
my @tables = keys %$config;
foreach my $table (@tables) {
    my @rows;
    open my $in_fh, "<:encoding(utf8)", "$work_dir/csv.kr/$table.csv" or die "$work_dir/csv.kr/$table.csv: $!";
    $csv->column_names($csv->getline($in_fh));
    while (my $row = $csv->getline_hr($in_fh)) {
        foreach my $column ( @{ $config->{$table} } ) {
            $row->{$column} -= $offset;
        }
        push @rows, $row;
    }
    close $in_fh;

    open my $out_fh, ">:encoding(utf8)", "$work_dir/csv.beta/$table.csv" or die "$work_dir/csv.beta/$table.csv: $!";
    $csv->eol("\n");
    $csv->print($out_fh, [$csv->column_names()]);
    $csv->print_hr($out_fh, $_) for @rows;
    close $out_fh;
}
