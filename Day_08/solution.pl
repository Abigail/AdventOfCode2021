#!/opt/perl/bin/perl

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

@ARGV = "t/input-1" unless @ARGV;
# @ARGV = "input";

sub shares ($f, $s) {
    my $c = 0;
    foreach my $char (split // => $f) {
        $c ++ if $s =~ /$char/
    }
    $c;
}

my $count = 0;
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

    my %display;
    my @digits;   # String representing a digit.

    #
    # Easy cases
    #
    $digits [1] = $buckets [2] [0];
    $digits [4] = $buckets [4] [0];
    $digits [7] = $buckets [3] [0];
    $digits [8] = $buckets [7] [0];

    $display {$digits [$_]} = $_ for 1, 4, 7, 8;

    #
    # Distingish between 0, 6 and 9. They all have six segments.
    #     The 6 shares 1 line segment  with 1, while 0 and 9 share 2.
    #     The 0 shares 3 line segments with 4, while 9 shares 4.
    #
    foreach my $try (@{$buckets [6]}) {
        if (shares ($try, $digits [1]) == 1) {
            $digits [6] = $try;
        }
        elsif (shares ($try, $digits [4]) == 3) {
            $digits [0] = $try;
        }
        else {
            $digits [9] = $try;
        }
    }

    $count += grep {$display {$_} && (
                        $display {$_} == 1 ||
                        $display {$_} == 4 ||
                        $display {$_} == 7 ||
                        $display {$_} == 8)} @output;

}

say "Solution 1: ", $count;

__END__
