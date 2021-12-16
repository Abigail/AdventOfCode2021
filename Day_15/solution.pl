#!/opt/perl/bin/perl

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

@ARGV = "input" unless @ARGV;

my @cave  =  map {[/[0-9]/g]} <>;

my $SIZE_X =   @cave;
my $SIZE_Y = @{$cave [0]};

my %seen;
sub cell ($x, $y, $factor = 1) {
    return if $x < 0 || $x >= $factor * $SIZE_X ||
              $y < 0 || $y >= $factor * $SIZE_Y ||
              $seen {$x, $y};

    my $val = $cave [$x % $SIZE_X] [$y % $SIZE_Y] + int ($x / $SIZE_X) +
                                                    int ($y / $SIZE_Y);
    $val -= 9 if $val > 9;

    $val;
}

my @heap;
sub init_heap () {
    @heap = ([0, 0, 0])
}
sub rebalance_d ($root = 0) {
    return unless 2 * $root + 1 < @heap;
    #
    # Find smaller of the children.
    #
    my $smaller = 2 * $root + 1;
    if (2 * $root + 2 < @heap && $heap [2 * $root + 2] [2] <
                                 $heap [2 * $root + 1] [2]) {
        $smaller ++;
    }
    #
    # If childer are larger, we're done.
    #
    return if $heap [$root] [2] < $heap [$smaller] [2];

    #
    # Swap and recurse
    #
    @heap [$root, $smaller] = @heap [$smaller, $root];

    rebalance_d ($smaller);
}

sub rebalance_u ($index = @heap - 1) {
    #
    # If at root, we're rebalanced.
    #
    return unless $index;

    #
    # If the element is larger than its parent, we're done.
    #
    my $parent = int (($index - 1) / 2);
    return unless $heap [$index] [2] < $heap [$parent] [2];

    #
    # Else, swap and recurse.
    #
    @heap [$index, $parent] = @heap [$parent, $index];
    rebalance_u ($parent);
}

sub extract () {
    #
    # Return the minimum, then rebalance.
    #
    my $min = $heap [0];
    $heap [0] = pop @heap;
    rebalance_d;
    $min;
}
sub add_to_heap ($element) {
    push @heap => $element;
    $::max = @heap if $::max < @heap;
    rebalance_u;
}



sub solve ($factor = 1) {
    %seen = ();
    init_heap; # It's initialized with [0, 0, 0] (top-left, no-risk)

    while (@heap) {
        my ($x, $y, $risk) = @{extract ()};
        if ($x == $SIZE_X * $factor - 1 && $y == $SIZE_Y * $factor - 1) {
            #
            # We are at the bottom-right
            #
            return $risk;
        }

        #
        # We've been here, no further processing needed.
        #
        next if $seen {$x, $y} ++;

        #
        # Try all unvisited neighbours
        #
        for my $diff ([1, 0], [-1, 0], [0, 1], [0, -1]) {
            my $new_x = $x + $$diff [0];
            my $new_y = $y + $$diff [1];
           (my $cell  = cell ($new_x, $new_y, $factor)) // next;
            add_to_heap [$new_x, $new_y, $risk + $cell];
        }
    }
}

say "Solution 1: ", solve 1;
say "Solution 2: ", solve 5;



__END__
