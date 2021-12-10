#!/opt/perl/bin/perl

use 5.032;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

@ARGV = "input" unless @ARGV;


my %scores = qw ! ( 1 )     3 [ 2 ]    57 { 3 }  1197 < 4 > 25137 !;
my $score  = 0;
my @scores;
while (<>) {
    chomp;
    1 while s/ \(\) | \[\] | <> | \{\} //xg;
    if (/[])}>]/) {
        $score += $scores {$&};
    }
    else {
        my $score = 0;
           $score = 5 * $score + $scores {$_} for reverse split //;
        push @scores => $score;
    }
}


say "Solution 1: ", $score;
say "Solution 2: ", (sort {$a <=> $b} @scores) [@scores / 2];
