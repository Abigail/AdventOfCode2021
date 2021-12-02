#!/opt/perl/bin/perl

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

@ARGV = "input" unless @ARGV;

my $forward = 0;
my $depth1  = 0;
my $depth2  = 0;

while (<>) {
    my ($cmd, $amount) = split;
    if ($cmd =~ /^f/) {$forward += $amount; $depth2 += $amount * $depth1}
    if ($cmd =~ /^d/) {$depth1  += $amount}
    if ($cmd =~ /^u/) {$depth1  -= $amount}
}

say "Solution 1: ", $forward * $depth1;
say "Solution 2: ", $forward * $depth2;

__END__
