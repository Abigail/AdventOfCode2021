#!/opt/perl/bin/perl

use 5.032;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

@ARGV = "input" unless @ARGV;

my $TIMERS = 9;

my @fish = (0) x $TIMERS;
   $fish [$_] ++ foreach split /,/ => <>;

say "Solution 1: ",
          1421 * $fish [0] +       1401 * $fish [1] +       1191 * $fish [2] + 
          1154 * $fish [3] +       1034 * $fish [4] +        950 * $fish [5] +
           905 * $fish [6] +        779 * $fish [7] +        768 * $fish [8];

say "Solution 2: ",
    6703087164 * $fish [0] + 6206821033 * $fish [1] + 5617089148 * $fish [2] + 
    5217223242 * $fish [3] + 4726100874 * $fish [4] + 4368232009 * $fish [5] +
    3989468462 * $fish [6] + 3649885552 * $fish [7] + 3369186778 * $fish [8];


__END__
