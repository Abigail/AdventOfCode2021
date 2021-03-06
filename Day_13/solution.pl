#!/opt/perl/bin/perl

use 5.032;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

@ARGV = "input" unless @ARGV;

my %dots;
while (<>) {
    last unless /\S/;
    /([0-9]+),([0-9]+)/ and $dots {$1, $2} = 1;
}

my @folds = map {[/ ([xy])=([0-9]+)/]} <>;

my $count1 = 0;
my ($max_x, $max_y);
foreach my $fold (@folds) {
    my ($dir, $coordinate) = @$fold;
    $max_x = $coordinate if $dir eq 'x';
    $max_y = $coordinate if $dir eq 'y';
    foreach my $dot (keys %dots) {
        my ($x, $y) = split $; => $dot;
        #
        # Keep the dot if it is above a horizonal fold,
        # or to the left of the a vertical fold.
        #
        next if $dir eq 'x' && $x <= $coordinate ||
                $dir eq 'y' && $y <= $coordinate;

        my $new_x = $dir eq 'x' ? 2 * $coordinate - $x : $x;
        my $new_y = $dir eq 'y' ? 2 * $coordinate - $y : $y;
        
        $dots {$new_x, $new_y} = 1;
        delete $dots {$dot};
    }
    $count1 ||= keys %dots;
}

say "Solution 1: ", $count1;
print "Solution 2: ";

foreach my $y (0 .. $max_y - 1) {
    print "            " if $y;
    foreach my $x (0 .. $max_x - 1) {
        print $dots {$x, $y} ? "#" : " ";
    }
    print "\n";
}
