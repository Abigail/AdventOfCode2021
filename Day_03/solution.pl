#!/opt/perl/bin/perl

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use List::Util 'sum0';

@ARGV = "input" unless @ARGV;

my $input   = [map {chomp; [split //]} <>];
my $nr_bits = @{$$input [0]};

sub most_used ($pos, $list) {
    my $ones = sum0 map {$$_ [$pos]} @$list;
    $ones >= @$list / 2 ? 1 : 0
}

my @max = map {most_used $_, $input} 0 .. $nr_bits - 1;
my @min = map {1 - $_} @max;

my @oxygen    = @$input;
my @co2       = @$input;
for (my $pos  = 0; $pos < $nr_bits; $pos ++) {
    my $o_bit =     most_used $pos, \@oxygen;
    my $c_bit = 1 - most_used $pos, \@co2;
    @oxygen   = grep {$$_ [$pos] == $o_bit} @oxygen if @oxygen > 1;
    @co2      = grep {$$_ [$pos] == $c_bit} @co2    if @co2    > 1;
}

local $" = "";
my $gamma   = oct "0b@max";
my $epsilon = oct "0b@min";
my $oxygen  = oct "0b@{$oxygen [0]}";
my $co2     = oct "0b@{$co2    [0]}";

say "Solution 1: ", $gamma  * $epsilon;
say "Solution 2: ", $oxygen * $co2;

__END__
