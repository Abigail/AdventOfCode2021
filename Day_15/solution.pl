#!/opt/perl/bin/perl

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

@ARGV = "input" unless @ARGV;
@ARGV = "t/input-1";

my $MAX = 1 << 30;

my @cave  =  map {[/[0-9]/g]} <>;

my $cave1 = [map ({[@$_, $MAX]} @cave), [($MAX) x (1 + @{$cave [0]})]];

# push @cave => [($MAX) x @{$cave [0]}];

# my $SIZE_X =   @cave      - 1;
# my $SIZE_Y = @{$cave [0]} - 1;

sub solve ($cave) {
    my $SIZE_X =   @$cave      - 1;
    my $SIZE_Y = @{$$cave [0]} - 1;
    my @todo   = ([0, 0, 0]);   # x/y coordinate of current point, sum of risk

    while (@todo) {
        my ($x, $y, $risk) = @{shift @todo};
        if ($x == $SIZE_X - 1 && $y == $SIZE_Y - 1) {
            #
            # We are at the bottom
            #
            return $risk;
        }

        #
        # We've been here, no further processing needed.
        #
        next if $cave [$x] [$y] == $MAX;

        #
        # Mark current point as visited.
        #
        $cave [$x] [$y] = $MAX;

        #
        # Try all unvisited neighbours
        #
        for my $diff ([1, 0], [-1, 0], [0, 1], [0, -1]) {
            my $new_x = $x + $$diff [0];
            my $new_y = $y + $$diff [1];
            next if $cave [$new_x] [$new_y] == $MAX;
            push @todo => [$new_x, $new_y, $risk + $cave [$new_x] [$new_y]];
        }

        #
        # Sort @todo on risk. This is linear (!)
        #
        @todo = sort {$$a [2] <=> $$b [2]} @todo;
    }
}

say "Solution 1: ", solve $cave1;






__END__
