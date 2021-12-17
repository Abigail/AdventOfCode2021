#!/opt/perl/bin/perl

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';
use List::Util qw [min max];

@ARGV = "input" unless @ARGV;

  my ($xmin, $xmax, $ymin, $ymax) = <> =~ /-?[0-9]+/g;
# my ($xmin, $xmax, $ymin, $ymax) = (20, 30, -10, -5);


#
# The maximum height of is reached if the probe hits level 0
# with a speed equal to -$ymin -- that way, it reach the target
# area in one step.
#
# When level 0 is reached, the probe has identical speed (but in
# the opposite direction) as when it was shot.
#
# Hence, the height is (-$ymin - 1) * (-$ymin) / 2.
#
# This is under the assumption there is a triangle number in
# the range $xmin -- $xmax. (And there is).
#

say "Solution 1: ", (-$ymin - 1) * (-$ymin) / 2;

#
# For each possible dx, find the number of steps it reaches the target,
# if at all. The maximum number of steps will be -ymin * 2
#
# We're doing brute force, but the numbers are small...
#
my $max_steps = -$ymin * 2;
my $xspeeds;
foreach my $dx (1 .. $xmax) {
    my $dist  = 0;
    my $steps = 0;
    my $dxx   = $dx;
    my @ok;
    while ($dist <= $xmax && $steps < $max_steps) {
        $steps ++;
        $dist += $dxx;
        $dxx -- if $dxx > 0;
        push @ok => $steps if $xmin <= $dist && $dist <= $xmax;
    }
    foreach my $steps (@ok) {
        push @{$$xspeeds {$steps}} => $dx;
    }
}

#
# Do the same for dy, ranging from ymin to -ymin - 1
#
my $yspeeds;
foreach my $dy ($ymin .. -$ymin - 1) {
    my $dist  = 0;
    my $steps = 0;
    my $dyy   = $dy;
    my @ok;
    while ($dist >= $ymin) {
        $steps ++;
        $dist += $dyy;
        $dyy --;
        push @ok => $steps if $ymin <= $dist && $dist <= $ymax;
    }
    foreach my $steps (@ok) {
        push @{$$yspeeds {$steps}} => $dy;
    }
}

#
# Find all combination which end in the target area, and dedup them.
#
my %target;
foreach my $step (sort {$a <=> $b} keys %$xspeeds) {
    my @dx = @{$$xspeeds {$step}};
    my @dy = @{$$yspeeds {$step} || []};
    foreach my $dx (@dx) {
        foreach my $dy (@dy) {
            $target {$dx, $dy} ++;
        }
    }
}

say "Solution 2: ", scalar keys %target;
