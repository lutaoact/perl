use warnings; use strict;
use DBI;
my $dsn = "DBI:mysql:database=test_lutao;host=localhost";
my $username = "root";
my $password = "111111";
my $dbh = DBI->connect($dsn, $username, $password, {RaiseError => 1, printError=>0});
my $sth = $dbh->prepare("select * from Student");
$sth->execute();
my @matrix;
while (my @ary = $sth->fetchrow_array())
{
    push @matrix, [@ary];#匿名数组的使用，@matrix中的值是数组的引用
}
$sth->finish;
my $rows = scalar(@matrix);
my $cols = ($rows == 0 ? 0 : scalar(@{$matrix[0]}));#$matrix[0]是一个数组引用
for (my $i = 0; $i < $rows; $i++)
{
    for (my $j = 0; $j < $cols; $j++)
    {
        print "$matrix[$i][$j]\t";
    }
    print "\n";
}
