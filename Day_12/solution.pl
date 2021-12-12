#!/opt/perl/bin/perl

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

@ARGV = "input" unless @ARGV;

my $START = "start";
my $END   = "end";

my %caves;
while (<>) {
    my ($from, $to) = /[A-Z]+/gi;
    $caves {$from} {$to} = 1 unless $from eq $END   || $to eq $START;
    $caves {$to} {$from} = 1 unless $from eq $START || $to eq $END;
}

my @todo = ([$START,        # Next cave to visit
             {},            # Caves we've seen on the current path.
             0,             # If we have visited a small cave twice.
]);

my $paths1 = 0;
my $paths2 = 0;
while (@todo) {
    my ($next, $seen, $twice) = @{shift @todo};
    #
    # If $next is the end cave, this path is done. Count it.
    #
    if ($next eq $END) {
        $paths1 ++ if !$twice;
        $paths2 ++;
        next;
    }

    #
    # If the next cave is forbidden, skip this path
    #
    next if $next eq lc $next && $$seen {$next} && $twice ++;

    #
    # Recurse with all neighbours
    #
    push @todo => map {[$_, {%$seen, $next => 1}, $twice]}
                  keys %{$caves {$next}};
}

say "Solution 1: ", $paths1;
say "Solution 2: ", $paths2;

__END__
