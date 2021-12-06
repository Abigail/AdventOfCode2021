#!/opt/perl/bin/perl

use 5.032;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use List::Util qw [sum];

@ARGV = "input" unless @ARGV;

my $GENERATIONS1 =  80;
my $GENERATIONS2 = 256;
my $TIMERS       =   9;

my @fish = (0) x $TIMERS;
$fish [$_] ++ foreach split /,/ => <>;

for (1 .. $GENERATIONS2) {
    @fish      = @fish [1 .. $TIMERS - 1, 0];
    $fish [6] += $fish [$TIMERS - 1];
    say "Solution 1: ", sum @fish if $_ == $GENERATIONS1;
    say "Solution 2: ", sum @fish if $_ == $GENERATIONS2;
}

__END__
