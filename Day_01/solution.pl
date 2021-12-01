#!/opt/perl/bin/perl

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use List::Util qw [sum];

@ARGV = "input" unless @ARGV;

my @depths = <>;
my $count1 = grep {$depths [$_] > $depths [$_ - 1]} 1 .. $#depths;
my $count2 = grep {sum (@depths [$_,     $_ - 1, $_ - 2]) >
                   sum (@depths [$_ - 1, $_ - 2, $_ - 3])} 3 .. $#depths;

say "Solution 1: $count1";
say "Solution 1: $count2";

__END__
