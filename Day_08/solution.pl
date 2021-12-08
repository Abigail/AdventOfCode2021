#!/opt/perl/bin/perl

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

@ARGV = "input" unless @ARGV;

sub shares ($f, $s) {
    grep {$s =~ /$_/} split // => $f;
}

my $count1 = 0;
my $count2 = 0;
while (<>) {
    chomp;
    my ($input, $output) = split /\s*\|\s*/;

    #
    # Split the input and output, and *normalize* them.
    #
    my @input  = map {join "" => sort split //} split ' ' => $input;
    my @output = map {join "" => sort split //} split ' ' => $output;

    #
    # First, group the inputs based on their length.
    #
    my @buckets;
    foreach my $i (@input) {
        push @{$buckets [length $i]} => $i;
    }

    my @digits;   # String representing a digit.

    #
    # Easy cases
    #
    $digits [1] = $buckets [2] [0];
    $digits [4] = $buckets [4] [0];
    $digits [7] = $buckets [3] [0];
    $digits [8] = $buckets [7] [0];

    #
    # Distingish between 0, 6 and 9. They all have six segments.
    #     The 6 shares 1 line segment  with 1, while 0 and 9 share 2.
    #     The 0 shares 3 line segments with 4, while 9 shares 4.
    #
    foreach my $try (@{$buckets [6]}) {
        $digits [shares ($try, $digits [1]) == 1 ? 6
               : shares ($try, $digits [4]) == 3 ? 0
               :                                   9] = $try;
    }

    #
    # Distinguish between 2, 3, and 5. They all have 5 segments
    #     The 3 shares 2 line segments with 1, while 3 and 5 share 1.
    #     The 5 shares 5 line segments with 9, while 2 share 4.
    #
    foreach my $try (@{$buckets [5]}) {
        $digits [shares ($try, $digits [1]) == 2 ? 3
               : shares ($try, $digits [9]) == 5 ? 5
               :                                   2] = $try;
    }

    #
    # Create a lookup table 
    #
    my %display;
    $display {$digits [$_]} = $_ for keys @digits;

    $count1 += grep {$display {$_} == 1 ||
                     $display {$_} == 4 ||
                     $display {$_} == 7 ||
                     $display {$_} == 8}      @output;

    $count2 += join "" => map {$display {$_}} @output;

}

say "Solution 1: ", $count1;
say "Solution 2: ", $count2;

__END__
