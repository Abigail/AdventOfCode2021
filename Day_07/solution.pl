#!/opt/perl/bin/perl

use 5.032;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

@ARGV = "input" unless @ARGV;

use List::Util qw [min max sum];

my @nums = <> =~ /[0-9]+/g;

sub cost1 ($target, $nums) {
    sum map {abs ($target - $_)} @$nums;
}

sub cost2 ($target, $nums) {
    sum map {my $n = abs ($target - $_); $n * ($n + 1) / 2} @$nums;
}

say "Solution 1: ", min map {cost1 $_, \@nums} min (@nums) .. max (@nums);
say "Solution 2: ", min map {cost2 $_, \@nums} min (@nums) .. max (@nums);


__END__
