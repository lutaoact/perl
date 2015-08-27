#!/usr/bin/perl
use warnings; use strict;
use File::Find;
sub create_find_callbacks_that_sum_the_size
{
    my $total_size = 0;
    return (sub {print $File::Find::dir, "\n";
                 print $_, "\n";
                 print $File::Find::name, "\n";
                 $total_size += -s if -f;},
            sub { return $total_size}
            );
}#闭包应用，$total_size变量在函数结束之后不会释放，因为仍然存在对它的引用，这也是变量私有的一种操作方式
my ($count_em, $get_results) = create_find_callbacks_that_sum_the_size();
my $file = "./";
find($count_em, $file);
my $total_size = &$get_results();#匿名子例程调用，子例程中的$total_size仍然有效
print "total size of $file is $total_size\n";
