#!/opt/perl/bin/perl

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

@ARGV = "input" unless @ARGV;

my @start = map {/([0-9]+)$/} <>;

sub move ($positions, $scores, $player, @rolls) {
    $$positions [$player]  += $_ for @rolls;
    $$positions [$player]  %= 10;
    $$positions [$player] ||= 10;
    $$scores    [$player]  += $$positions [$player];
}


sub part_one (@position) {
    my @score  = (0, 0);
    my @rolls  = (1 .. 100);
    my $rolls  = 0;

    my $player = 0;
    {
        #
        # Move player and adjust score
        #
        move \@position, \@score, $player, splice @rolls => 0, 3;

        #
        # Adjust roll count
        #
        $rolls                   +=  3;

        #
        # Exit loop if last
        #
        last if $score [$player] >= 1000;

        #
        # Replenish rolls if needed
        #
        push @rolls => (1 .. 100) if @rolls < 3;

        #
        # Next player and redo
        #
        $player = 1 - $player;
        redo;
    }

    #
    # $player is the winning player, and 1 - $player is the losing one
    #
    $score [1 - $player] * $rolls;
}

#
# Possible rolls:
#     3:     1   (1, 1, 1)
#     4:     3   (2, 1, 1)
#     5:     6   (3, 1, 1); (2, 2, 1)
#     6:     7   (3, 2, 1); (2, 2, 2)
#     7:     6   (3, 3, 1); (3, 2, 2)
#     8:     3   (3, 3, 2)
#     9:     1   (3, 3, 3)
#

sub part_two ($position0, $position1, $score0 = 0, $score1 = 0, $player = 0) {
    state $cache;
    $$cache {$position0, $position1, $score0, $score1, $player} //= do {
        my $out;
        $out = [1, 0] if $score0 >= 21;
        $out = [0, 1] if $score1 >= 21;
        if (!$out) {
            $out = [0, 0];
            foreach my $roll ([3, 1], [4, 3], [5, 6], [6, 7],
                              [7, 6], [8, 3], [9, 1]) {
                my ($roll, $frequency)  = @$roll;
                my @position = ($position0, $position1);
                my @score    = ($score0,    $score1);
                move \@position, \@score, $player, $roll;
                my $results = part_two (@position, @score, 1 - $player);
                $$out [$_] += $$results [$_] * $frequency for 0, 1;
            }
        }
        $out;
    }
}

use List::Util qw [max];


say "Solution 1: ",       part_one @start;
say "Solution 2: ", max @{part_two @start};


__END__
