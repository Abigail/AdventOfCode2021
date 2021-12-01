#!/opt/perl/bin/perl

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

@ARGV = "input" unless @ARGV;

my @depths = <>;
my $count1 = grep {$depths [$_] > $depths [$_ - 1]} 1 .. $#depths;
my $count2 = grep {$depths [$_] > $depths [$_ - 3]} 3 .. $#depths;

say "Solution 1: $count1";
say "Solution 2: $count2";

__END__
