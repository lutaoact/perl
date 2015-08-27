use Spreadsheet::ParseExcel::Stream::XLSX;
use JSON;

my $xlsx_file = '/tmp/sample.xlsx';
print json_encode(parse_xlsx($xlsx_file));

sub parse_xlsx {
    my ($file_path) = @_;
    my $XLSX = Spreadsheet::ParseExcel::Stream::XLSX->new($file_path);
    my $book = {};

    OUTER:
    while ( my $sheet = $XLSX->sheet() ) {
        my $name = $sheet->name();
        my $col_names = [ grep { s/^\s+|\s+$//g; $_ } @{ $sheet->row } ];

        INNER:
        while ( my $row = $sheet->row ) {
            next INNER unless grep { $_ } @$row;
            my $record = {
                map { $col_names->[$_] => $row->[$_] } (0 .. @$col_names - 1)
            };
            push @{ $book->{$name} }, $record;
        }
    }
    return $book;
}

sub json_encode {
    my ($json_obj) = @_;
    my $JSON = JSON->new->allow_nonref;
    return $JSON->pretty->encode($json_obj);
}
