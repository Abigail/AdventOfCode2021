#!/opt/perl/bin/perl

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use List::Util qw [min max];

@ARGV = "input" unless @ARGV;

my %vents1;
my %vents2;
while (<>) {
    my ($x1, $y1, $x2, $y2) = /[0-9]+/g;

    #
    # Slope
    #
    my $dx = $x2 <=> $x1;
    my $dy = $y2 <=> $y1;

    #
    # Hit all the points on the line. This stops when we reach the
    # end of the line segment...
    #
    for (my ($x, $y) = ($x1, $y1);
             $x != $x2 || $y != $y2;
             $x += $dx, $y += $dy) {
        $vents1 {$x, $y} ++ if $x1 == $x2 || $y1 == $y2;
        $vents2 {$x, $y} ++
    }
    #
    # ... so be sure to mark the endpoint.
    #
    $vents1 {$x2, $y2} ++ if $x1 == $x2 || $y1 == $y2;
    $vents2 {$x2, $y2} ++
}

say "Solution 1: ", scalar grep {$_ > 1} values %vents1;
say "Solution 2: ", scalar grep {$_ > 1} values %vents2;

__END__
