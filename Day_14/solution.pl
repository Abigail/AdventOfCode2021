#!/opt/perl/bin/perl

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use List::Util qw [min max];

@ARGV = "input" unless @ARGV;

#
# Given a set of rules, and a set of pairs with their counts,
# calculate the pairs and their counts of the next generation.
#
sub next_gen ($rules, $pairs) {
    my %new;
    while (my ($pair, $count) = each %$pairs) {
        foreach my $new_pairs (@{$$rules {$pair}}) {
            $new {$new_pairs} += $count;
        }
    }
    \%new;
}

#
# Find the difference between the maximim and minimum occurance
# of each element. Note that every element of the final polymere
# occurs exactly once as the first element of a pair. Except the
# last element of the polymere (which will be the same as the
# last element of the template).
#
sub minmax ($pairs, $template) {
    my %count;
    $count {substr $_, 0, 1} += $$pairs {$_} for keys %$pairs;
    $count {substr $template, -1} ++;
    my $min = min values %count;
    my $max = max values %count;
    $max - $min;
}

chomp (my $template = <>);
my $pairs;
  $$pairs {"$1$2"} ++ while $template =~ /(.)(?=(.))/g;

my $rules;
while (<>) {
    /^([A-Z])([A-Z]) \s* -> \s* ([A-Z])/x or next;
    $$rules {"$1$2"} = ["$1$3", "$3$2"];
}

$pairs = next_gen $rules, $pairs for  1 .. 10;
say "Solution 1: ", minmax $pairs, $template;

$pairs = next_gen $rules, $pairs for 11 .. 40;
say "Solution 2: ", minmax $pairs, $template;


__END__
