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

sub diffsum1 ($target, $nums) {
    sum map {abs ($target - $_)} @$nums;
}

sub diffsum2 ($target, $nums) {
    sum map {my $n = abs ($target - $_); $n * ($n + 1) / 2} @$nums;
}

say "Solution 1: ", min map {diffsum1 $_, \@nums} min (@nums) .. max (@nums);
say "Solution 2: ", min map {diffsum2 $_, \@nums} min (@nums) .. max (@nums);


__END__
