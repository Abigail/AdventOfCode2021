#!/opt/perl/bin/perl

use 5.032;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

@ARGV = "input" unless @ARGV;
# @ARGV = "t/input-1";

my @floor = map {[(/[0-9]/g), 9]} <>;
push @floor => [(9) x @{$floor [0]}];

my $X =   @floor      - 1;
my $Y = @{$floor [0]} - 1;

my $sum;

#
# Give the problem description, we can assume a basin is bounded by a 9.
#
sub basin_size ($x, $y, $floor) {
    my $size = 0;
    my @todo = ([$x, $y]);
    while (my $point = shift @todo) {
        my ($px, $py) = @$point;
        next if $$floor [$px] [$py] == 9;
        $$floor [$px] [$py] = 9;
        $size ++;
        push @todo =>  [$px - 1, $py],     [$px + 1, $py],
                       [$px,     $py - 1], [$px,     $py + 1];
    }
    $size;
}

my @basins;

foreach my $x (0 .. $X - 1) {
    foreach my $y (0 .. $Y - 1) {
        if ($floor [$x] [$y] < $floor [$x - 1] [$y]     &&
            $floor [$x] [$y] < $floor [$x + 1] [$y]     &&
            $floor [$x] [$y] < $floor [$x]     [$y - 1] &&
            $floor [$x] [$y] < $floor [$x]     [$y + 1]) {
            $sum += $floor [$x] [$y] + 1;
            push @basins => basin_size $x, $y, \@floor;
        }
    }
}

@basins = sort {$a <=> $b} @basins;

say "Solution 1: ", $sum;
say "Solution 2: ", $basins [-1] * $basins [-2] * $basins [-3];

__END__
