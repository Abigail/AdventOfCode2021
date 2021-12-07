#!/opt/perl/bin/perl

use 5.032;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

@ARGV = "input" unless @ARGV;

use List::Util qw [min max sum];
use Statistics::Basic qw [mean median];
use POSIX             qw [ceil floor];

my @nums = <> =~ /[0-9]+/g;

sub cost1 ($target, $nums) {
    sum map {abs ($target - $_)} @$nums;
}

sub cost2 ($target, $nums) {
    sum map {my $n = abs ($target - $_); $n * ($n + 1) / 2} @$nums;
}

my $median = median @nums;
my $mean   =   mean @nums;

say "Solution 1: ",     cost1        $median, \@nums;
say "Solution 2: ", min cost2 (floor ($mean), \@nums),
                        cost2 ( ceil ($mean), \@nums);

__END__
