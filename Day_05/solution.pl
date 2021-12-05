#!/opt/perl/bin/perl

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

@ARGV = "input" unless @ARGV;

my %vents1;
my %vents2;
while (<>) {
    my ($x1, $y1, $x2, $y2) = /[0-9]+/g;

    #
    # Slope and distance.
    #
    my ($dx, $dy) = ($x2 <=> $x1, $y2 <=> $y1);
    my $dist = abs ($x1 - $x2) || abs ($y1 - $y2);

    #
    # Mark all points of the line segment. For part one, we only
    # do horizontal and vertical lines, which happens if one of
    # $dx or $dy is 0.
    #
    unless ($dx * $dy) {
        $vents1 {$x1 + $_ * $dx, $y1 + $_ * $dy} ++ for 0 .. $dist;
    }
    $vents2 {$x1 + $_ * $dx, $y1 + $_ * $dy} ++ for 0 .. $dist;
}

say "Solution 1: ", scalar grep {$_ > 1} values %vents1;
say "Solution 2: ", scalar grep {$_ > 1} values %vents2;

__END__
