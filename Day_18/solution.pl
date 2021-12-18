#!/opt/perl/bin/perl

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

@ARGV = "input" unless @ARGV;

#
# Given a snailfish, return a string to print it out.
#
sub snailfish_to_str ($snailfish) {
    local $" = ",";
    "@$snailfish" =~ s/\[,/[/gr =~ s/,\]/]/gr =~ s/,$//r;
}

#
# Given a string, turn it into a snailfish
#
sub str_to_snailfish ($string) {
    [$string =~ /[][0-9]/g]
}

#
# Do the explode functionality. We'll be going through $snailfish,
# keeping track of the depth (increase on '[', decrease on ']).
# If we are deep enough to explode, search backwards and forwards
# for a number (if any) to add the left/right parts of the exploding
# number. Then replace the four tokens ('[', left number, right number, ']')
# with a 0. Modifies its argument.
#
sub explode ($snailfish) {
    my $depth = 0;
    foreach my $i (keys @$snailfish) {
        my $part = $$snailfish [$i];
        $depth ++, next if $part eq '[';
        $depth --, next if $part eq ']';
        if ($depth > 4) {
            #
            # We can explode
            #
            my $left  = $part;
            my $right = $$snailfish [$i + 1];
            my $j = $i;
            while (-- $j) {
                next if $$snailfish [$j] eq '[' || $$snailfish [$j] eq ']';
                $$snailfish [$j] += $left;
                last;
            }
            my $k = $i + 1;
            while (++ $k < @$snailfish) {
                next if $$snailfish [$k] eq '[' || $$snailfish [$k] eq ']';
                $$snailfish [$k] += $right;
                last;
            }
            splice @$snailfish, $i - 1, 4, 0;
            return 1;
        }
    }
}


#
# Search through $snailfish for the first number equal or greater than 10.
# Replace this by a pair by dividing the number as equally as possible.
# Modifies its argument.
#
sub mysplit ($snailfish) {
    use POSIX qw [ceil floor];
    foreach my $i (keys @$snailfish) {
        my $part = $$snailfish [$i];
        next if $part eq '[' || $part eq ']' || $part < 10;
        splice @$snailfish, $i, 1, '[', floor ($$snailfish [$i] / 2),
                                        ceil  ($$snailfish [$i] / 2), ']';
        return 1;
    }
}

#
# Reduce a snailfish by repeatedly exploding and splitting, until
# we no longer can. Modifies its argument.
#
sub reduce ($snailfish) {
    1 while explode ($snailfish) || mysplit ($snailfish);
    $snailfish;
}

#
# Add two snailfishes, returning a reduced sum. If either argument
# is false, return the other.
#
sub add ($snailfish1, $snailfish2) {
    my $add;
    if    (!$snailfish1) {$add = $snailfish2}
    elsif (!$snailfish2) {$add = $snailfish1}
    else                 {$add = ['[', @$snailfish1, @$snailfish2, ']']}
    reduce $add;
}


#
# Returns the magnitude of a snailfish. Does this by turning a snailfish
# into a string, then repeatedly modifying '[NNN,MMM]' by the result
# of 3 * NNN + 2 * MMM.
#
sub magnitude ($snailfish) {
    my $str = snailfish_to_str $snailfish;
    1 while $str =~ s/\[([0-9]+),([0-9]+)\]/3 * $1 + 2 * $2/e;
    $str;
}

my @snailfishes = map {str_to_snailfish $_} <>;

my $sum;
foreach my $snailfish (@snailfishes) {
    $sum = add ($sum, $snailfish);
}


my $max = 0;
foreach my $i (keys @snailfishes) {
    foreach my $j (keys @snailfishes) {
        next if $i == $j;
        my $sum = add ($snailfishes [$i], $snailfishes [$j]);
        my $magnitude = magnitude $sum;
        $max = $magnitude if $magnitude > $max;
    }
}

say "Solution 1: ", magnitude $sum;
say "Solution 2: ", $max;


__END__
