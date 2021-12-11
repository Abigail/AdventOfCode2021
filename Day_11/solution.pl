#!/opt/perl/bin/perl

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

@ARGV = "input" unless @ARGV;

my $MIN    = -~0;
my $CYCLES = 100;
my $LIMIT  =   9;

my @octopusses = map {[/[0-9]/g, $MIN]} <>;
my $SIZE = @octopusses;
push @octopusses => [($MIN) x ($SIZE + 1)];

sub cycle ($octopusses) {
    my %flashed;  # Prevent flashing twice during a cycle
    my @todo;

    #
    # First, increment all by 1, keep track of which octopusses
    # are about to flash.
    #
    foreach my $x (0 .. ($SIZE - 1)) {
        foreach my $y (0 .. ($SIZE - 1)) {
            if (++ $$octopusses [$x] [$y] > $LIMIT) {
                push @todo => [$x, $y];
                $$octopusses [$x] [$y] = 0;
            }
        }
    }
    #
    # Flash them, increment neighbours. Don't flash twice.
    #
    while (@todo) {
        my ($x, $y) = @{shift @todo};
        next if $flashed {$x, $y} ++;
        foreach my $dx (-1 .. 1) {
            foreach my $dy (-1 .. 1) {
                next if $dx == 0 && 0 == $dy;
                if (   $$octopusses [$x + $dx] [$y + $dy] &&
                    ++ $$octopusses [$x + $dx] [$y + $dy] > $LIMIT) {
                    push @todo => [$x + $dx, $y + $dy];
                }
            }
        }
        $$octopusses [$x] [$y] = 0;
    }

    scalar keys %flashed;
}


my $first_cycle = 0;
my $flashes     = 0;
{
    state $cycles = 0;
    $cycles ++;
    my $cycle_flashes = cycle \@octopusses;
    if ($cycle_flashes == $SIZE * $SIZE) {
        $first_cycle = $cycles;
    }
    $flashes += $cycle_flashes if $cycles <= $CYCLES;
    redo unless $first_cycle && $cycles >= $CYCLES;
}


say "Solution 1: ", $flashes;
say "Solution 2: ", $first_cycle;

__END__
