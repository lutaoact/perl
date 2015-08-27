package ExcelDiff;
use strict;
use warnings;

use Data::Dumper;
use Text::CSV_XS;
use List::MoreUtils qw/uniq all/;

use lib 'script/parameter';
use DiffToHTML qw/diff_files diff_css/;
use ExcelParser;

=pod
  # test_diff.pl
  use lib 'script/parameter';
  use ExcelDiff;

  ExcelDiff::diff_by_revision("tmp.xls", HEAD^1, HEAD);

  ExcelDiff::diff_file("tmp1.xls", "tmp2.xls");

  ExcelDiff::diff_by_table_name("item", "tmp1.xls", "tmp2.xls");

  # the diff result can write to file
  $ perl script/parameter/ExcelDiff.pm | tee result.html
=cut

run() unless caller;

sub run {
}

sub diff_to_html {
    my ($diff) = @_;
    my $css = qq{<style type='text/css'>\n@{[diff_css()]}</style>\n};
    my $head = <<HERE;
<head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
    $css
</head>
HERE
    return $head . $diff;
}

#########################################
# 基于不同版本号比较文件
#########################################
sub diff_by_revision {
    my ($path, $file, $rev1, $rev2) = @_;
    my ($tmp_a, $tmp_b) = qw{/tmp/1.xls /tmp/2.xls};
    system "cd $path && git show $rev1:$file > $tmp_a" and die;
    system "cd $path && git show $rev2:$file > $tmp_b" and die;
    return diff_file($tmp_a, $tmp_b);
}

#########################################
# 根据指定表名比较其数据
#########################################
sub diff_by_table_name {
    my ($name, $xls_a, $xls_b) = @_;
    my ($book_a, $book_b) = parse_2files($xls_a, $xls_b);
    my ($table_a,               $table_b              )
     = ($book_a->{$name} || [], $book_b->{$name} || []);
    return diff_table($name, $table_a, $table_b);
}

#########################################
# 比较不同文件
#########################################
sub diff_file {
    my ($xls_a, $xls_b) = @_;
    my ($book_a, $book_b) = parse_2files($xls_a, $xls_b);
    return diff_book($book_a, $book_b);
}

sub diff_book {
    my ($book_a, $book_b) = @_;
    my @tables = uniq(keys %$book_a, keys %$book_b);
    my @diffs;
    for my $name (@tables) {
        my ($table_a,               $table_b              )
         = ($book_a->{$name} || [], $book_b->{$name} || []);
        my $diff = diff_table($name, $table_a, $table_b);
        push @diffs, $diff if $diff;
    }
    @diffs = sort { length $a <=> length $b } @diffs;
    my $HR = q{<hr>};
    return join $HR, @diffs;
}

sub diff_table {
    my ($name, $table_a, $table_b) = @_;
    my ($file_a, $file_b) = ("/tmp/${name}_a.csv", "/tmp/${name}_b.csv");
    write2csv($file_a, $table_a);
    write2csv($file_b, $table_b);
#    return qx{git diff $file_a $file_b};
    return qq{<b>$name</b>} . diff_files($file_a, $file_b);
}

sub parse_excel {
    my ($filepath) = @_;
    my $book = ExcelParser::parseFile($filepath, 'utf8', 'utf8');
    return $book;
}

sub parse_2files {
    my ($xls_a, $xls_b) = @_;
    my $book_a = parse_excel($xls_a);
    my $book_b = parse_excel($xls_b);
    return ($book_a, $book_b);
}

sub write2csv {
    my ($filepath, $table_data) = @_;
    open my $out_fh, ">", $filepath or die "$!";
    unless (scalar @$table_data) {
        close $out_fh;
        return;
    }

    my $CSV = new Text::CSV_XS({binary => 1});

    my @column_names = keys %{$table_data->[1]};
    $CSV->column_names(\@column_names);
    $CSV->eol("\n");
    $CSV->print($out_fh, \@column_names);
    for my $row (@$table_data) {
        next if all { not $_ } values %$row;
        $CSV->print_hr($out_fh, $row);
    }
    close $out_fh;
    return;
}

1;
