#!usr/bin/perl
use warnings;
use strict;
use Data::Dumper;
use List::Util qw/sum/;
use Text::SimpleTable;

my @group1_repositories = qw{
};

my @group1_members = qw{
    tao.lu
};

my @repositories;
push(@repositories, @group1_repositories);

my @member_accounts;
push(@member_accounts, @group1_members);

my $since = `date --date="1 month ago" +"%Y-%m-%d"`; chomp $since;
my $until = `date +"%Y-%m-%d"`; chomp $until;
if(@ARGV > 1) {
    $since = $ARGV[0];
    $until = $ARGV[1];
}

my $since_epoch = `date +%s -d"$since"`; chomp $since_epoch;
my $until_epoch = `date +%s -d"$until"`; chomp $until_epoch;

my $summary = {};
my $result_table = {};
for my $member_account (@member_accounts) {
    for my $repo (@repositories) {
        chdir $repo or die "can not chdir to $repo: $!";
        my @branchs = `git branch --no-color`;
        @branchs = map { chomp; s/\*//; s/^\s*//; $_ } @branchs;
        for my $b (@branchs) {
            warn "$member_account in $repo $b\n";
            my $get_log_command = qq{git log --no-merges --format="%H %at" --since="$since 00:00:00" --author="$member_account" heads/$b};

            my @member_logs = `$get_log_command`;
            my @logs;
            for my $member_log (@member_logs) {
                chomp $member_log;
                my ($hash, $timestamp) = split(/\s/, $member_log);

                if($timestamp >= $since_epoch && $timestamp < $until_epoch) {
                    push @logs, $hash;
                }
            }

            my @numstat;
            for my $log (@logs) {
                my @stats = `git show $log --pretty=tformat: --numstat`;
                push @numstat, grep{$_ !~ /^\s*$/} @stats;
            }

            next unless @numstat;

            my $sum=0;
            my $pm_numbers=0;
            my $pl_numbers=0;
            my $js_numbers=0;
            my $t_numbers=0;
            my $tmpl_numbers=0;
            my $java_numbers=0;
            my $xml_numbers=0;
            my $css_numbers=0;
            my $yaml_numbers=0;

            my @alls = get_changed_lines_of_per_file(@numstat);
            $sum = sum @alls;

            next unless $sum;

            my @pms = get_changed_lines_of_per_file(grep {/\.pm$/} @numstat);
            $pm_numbers = sum @pms;

            my @pls = get_changed_lines_of_per_file(grep {/\.pl$/} @numstat);
            $pl_numbers = sum @pls;

            my @javas = get_changed_lines_of_per_file(grep {/\.java$/} @numstat);
            $java_numbers = sum @javas;

            my @jss = get_changed_lines_of_per_file(grep {/\.js$/} @numstat);
            $js_numbers = sum @jss;

            my @ts = get_changed_lines_of_per_file(grep {/\.t$/} @numstat);
            $t_numbers = sum @ts;

            my @tmpls = get_changed_lines_of_per_file(grep {/\.tmpl$/} @numstat);
            $tmpl_numbers = sum @tmpls;

            my @xmls = get_changed_lines_of_per_file(grep {/\.xml$/} @numstat);
            $xml_numbers = sum @xmls;

            my @csss = get_changed_lines_of_per_file(grep {/\.css$/} @numstat);
            $css_numbers = sum @csss;

            my @yamls = get_changed_lines_of_per_file(grep {/\.yaml$/} @numstat);
            $yaml_numbers = sum @yamls;

            $summary->{$member_account}->{$repo}->{$b} = {
                sum           => $sum ||= 0,
                pm_numbers    => $pm_numbers ||= 0,
                pl_numbers    => $pl_numbers ||= 0,
                js_numbers    => $js_numbers ||= 0,
                t_numbers     => $t_numbers ||= 0,
                tmpl_numbers  => $tmpl_numbers ||= 0,
                java_numbers  => $java_numbers ||= 0,
                xml_numbers   => $xml_numbers ||= 0,
                css_numbers   => $css_numbers ||= 0,
                yaml_numbers   => $yaml_numbers ||= 0,
            };

            $result_table->{$member_account}->{sum}             += $sum;
            $result_table->{$member_account}->{pm_numbers}      += $pm_numbers;
            $result_table->{$member_account}->{pl_numbers}      += $pl_numbers;
            $result_table->{$member_account}->{js_numbers}      += $js_numbers;
            $result_table->{$member_account}->{t_numbers}       += $t_numbers;
            $result_table->{$member_account}->{tmpl_numbers}    += $tmpl_numbers;
            $result_table->{$member_account}->{java_numbers}    += $java_numbers;
            $result_table->{$member_account}->{xml_numbers}     += $xml_numbers;
            $result_table->{$member_account}->{css_numbers}     += $css_numbers;
            $result_table->{$member_account}->{yaml_numbers}     += $yaml_numbers;
        }
    }
}

#print Dumper $summary;
#my $result_table = get_result_table_hash($summary);
#print Dumper $result_table;
show_result_table($result_table);

sub show_result_table {
    my ($result_table) = @_;
    my $table = Text::SimpleTable->new(
        [16, 'member_name'],
        [14, 'summary_line'],
        [6,'pm'],
        [6,'pl'],
        [6,'js'],
        [6,'t'],
        [6,'tmpl'],
        [6,'java'],
        [6,'xml'],
        [6,'css'],
        [6,'yaml'],
    );
    for my $member_account(@member_accounts) {
        $table->row(
            $member_account,
            $result_table->{$member_account}->{sum} || 0,
            $result_table->{$member_account}->{pm_numbers} || 0,
            $result_table->{$member_account}->{pl_numbers} || 0,
            $result_table->{$member_account}->{js_numbers} || 0,
            $result_table->{$member_account}->{t_numbers} || 0,
            $result_table->{$member_account}->{tmpl_numbers} || 0,
            $result_table->{$member_account}->{java_numbers} || 0,
            $result_table->{$member_account}->{xml_numbers} || 0,
            $result_table->{$member_account}->{css_numbers} || 0,
            $result_table->{$member_account}->{yaml_numbers} || 0,
        );
    }
    print $table->draw();
}

sub get_changed_lines_of_per_file {
    return map {
        chomp;
        my ($insert, $delete) = (split /\s/, $_)[0, 1];
        $insert + $delete;
    } @_;
}
