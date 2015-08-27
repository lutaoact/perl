package TT;

use warnings;
use strict;

use JSON;
use Spreadsheet::ParseExcel;
use Spreadsheet::ParseExcel::FmtJapan;
use Data::Dumper;
use ExcelParser;

run() unless caller;

sub run {
    my $book = parse_excel('/tmp/test.xlsx');
    print Dumper $book;
#    print "hello world";
#    my ($x, $y) = (2, 3);
#    swap($x, $y);
#    print $x, " ", $y;
}

sub swap {
    $_[0] = $_[1] ^ $_[0];#a = b ^ a;
    $_[1] = $_[1] ^ $_[0];#b = b ^ a;
    $_[0] = $_[1] ^ $_[0];#a = b ^ a;
}

sub swap1 {
    $_[0] = $_[1] - $_[0];#a = b - a;
    $_[1] = $_[1] - $_[0];#b = b - a;
    $_[0] = $_[1] + $_[0];#a = b + a;
}

sub parse_excel {
    my ($filepath) = @_;
    my $book = ExcelParser::parseFile($filepath, 'utf8', 'utf8');
    return $book;
}

sub parse_xls {
    my ($file, $in_code, $out_code) = @_;
    my $format   = Spreadsheet::ParseExcel::FmtJapan->new(Code => $in_code);
    my $parser   = Spreadsheet::ParseExcel->new();
    my $workbook = $parser->parse($file, $format);
    my $result = +{
        map {
            my $worksheet = $_;
            my $name = $worksheet->get_name();
            my $cols = $worksheet->col_range();
            my $rows = $worksheet->row_range();
            print $cols, " ", $rows, "\n";
            ($worksheet->get_name() => 1);
        } $workbook->worksheets()
    };
    return $result;
}

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
    my $JSON = JSON->new->allow_nonref;
    return $JSON->decode($json_text);
}

sub json_encode {
    my ($json_obj) = @_;
    my $JSON = JSON->new->allow_nonref;
    return $JSON->pretty->encode($json_obj);
}

1;
