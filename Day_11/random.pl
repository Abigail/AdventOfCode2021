#!/opt/perl/bin/perl

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use Getopt::Long;
use Time::HiRes qw [time];

GetOptions ('runs=i'   =>  \(my $RUNS      =      10),
            'size=i'   =>  \(my $SIZE      =      10),
            'max=i'    =>  \(my $MAX_STEPS = 100_000),
);

@ARGV = "input" unless @ARGV;

my $MIN        =     -~0;
my $LIMIT      =       9;

sub new {
    my @octopusses;
    foreach my $x (0 .. ($SIZE - 1)) {
        foreach my $y (0 .. ($SIZE - 1)) {
            $octopusses [$x] [$y] = int rand (1 + $LIMIT);
        }
        $octopusses [$x] [$SIZE] = $MIN;
    }
    foreach my $y (0 .. $SIZE) {
        $octopusses [$SIZE] [$y] = $MIN;
    }
    \@octopusses;
}

sub pp ($octopusses) {
    my $out = "";
    foreach my $x (0 .. ($SIZE - 1)) {
        foreach my $y (0 .. ($SIZE - 1)) {
            $out .= $$octopusses [$x] [$y];
        }
        $out .= "\n";
    }
    $out;
}


sub step ($octopusses) {
    my %flashed;  # Prevent flashing twice during a step
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

local $| = 1;

my $synced     = 0;
my $max_synced = 0;
my $min_synced = $MAX_STEPS + 1;
my $start      = time;
RUN: foreach my $run (1 .. $RUNS) {
    my $octopussses = new;
    foreach my $step (1 .. $MAX_STEPS) {
        if (step ($octopussses) == $SIZE * $SIZE) {
            print $step >= 1000 ? '*' : int ($step / 100);
            $synced ++;
            $max_synced = $step if $max_synced < $step;
            $min_synced = $step if $min_synced > $step;
            next RUN;
        }
    }
    print ".";
}
continue {
    print "\n" if $run % 70 == 0;
}
print "\n";
my $end = time;

printf "Synchronized %.2f%% of the time.\n" .
       "Min steps before synchronization: %4d\n" .
       "Max steps before synchronization: %4d\n" .
       "Run time: %.2fsec\n"
            => 100 * $synced / $RUNS,
                 $min_synced,
                 $max_synced, $end - $start;
