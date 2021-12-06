#!/opt/perl/bin/perl

use 5.032;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use Math::Matrix;

@ARGV = "input" unless @ARGV;

my $GENERATIONS1 =  80;
my $GENERATIONS2 = 256;
my $TIMERS       =   9;

my @fish = (0) x $TIMERS;
   $fish [$_] ++ foreach split /,/ => <>;
my $fish = Math::Matrix:: -> new (map {[$_ || 0]} @fish);

my $matrix = Math::Matrix:: -> new ([0, 1, 0, 0, 0, 0, 0, 0, 0],
                                    [0, 0, 1, 0, 0, 0, 0, 0, 0],
                                    [0, 0, 0, 1, 0, 0, 0, 0, 0],
                                    [0, 0, 0, 0, 1, 0, 0, 0, 0],
                                    [0, 0, 0, 0, 0, 1, 0, 0, 0],
                                    [0, 0, 0, 0, 0, 0, 1, 0, 0],
                                    [1, 0, 0, 0, 0, 0, 0, 1, 0],
                                    [0, 0, 0, 0, 0, 0, 0, 0, 1],
                                    [1, 0, 0, 0, 0, 0, 0, 0, 0],);

say "Solution 1: ", (($matrix ** $GENERATIONS1 * $fish) -> sum) =~ s/\.0*\s*//r;
say "Solution 2: ", (($matrix ** $GENERATIONS2 * $fish) -> sum) =~ s/\.0*\s*//r;


__END__
