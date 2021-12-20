#!/opt/perl/bin/perl

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

@ARGV = "input" unless @ARGV;

my $rule_integer = [map {/#/ ? 1 : 0} split // => scalar <>];<>;

my $universe;
my $x = 0;
while (<>) {
    my $y = 0;
    foreach my $cell (/[.#]/g) {
        $$universe {$x, $y} = 1 if $cell eq '#';
        $y ++;
    }
    $x ++;
}

sub next_gen ($universe, $rule_integer, $generation) {
    my $new_universe;
    my $seen;

    foreach my $cell (keys %$universe) {
        next unless $$universe {$cell};
        my ($X, $Y) = split $; => $cell;

        #
        # Calculate each cell in a 5 x 5 neighbourhood
        #
        foreach my $dX (-2 .. 2) {
            my $x = $X + $dX;
            foreach my $dY (-2 .. 2) {
                my $y = $Y + $dY;
                next if $$seen {$x, $y} ++;

                #
                # For each cell to inspect, we need the
                # cells in a 3 x 3 neighbourhood
                #
                my $bits = "0b";
                foreach my $dx (-1 .. 1) {
                    my $xp = $x + $dx;
                    foreach my $dy (-1 .. 1) {
                        my $yp = $y + $dy;
                        $bits .= $$universe {$xp, $yp} //
                                    ($$rule_integer [0] * ($generation % 2));
                    }
                }
                $$new_universe {$x, $y} = $$rule_integer [oct $bits];
            }
        }
    }
    $new_universe;
}


$universe = next_gen $universe, $rule_integer, $_ for 0 ..  1;
say "Solution 1: ", scalar grep {$_} values %$universe;

$universe = next_gen $universe, $rule_integer, $_ for 2 .. 49;
say "Solution 2: ", scalar grep {$_} values %$universe;



__END__
