#!/opt/perl/bin/perl

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use List::Util qw [min max];

@ARGV = "input" unless @ARGV;
@ARGV = "t/input-1";

chomp (my $template = <>);

sub next_gen ($rules, $pairs) {
    my %new;
    while (my ($pair, $count) = each %pairs) {

my %rule;
while (<>) {
    /^([A-Z])([A-Z]) \s* -> \s* ([A-Z])/x or next;
    $rule {$1} {$2} = $3;
}

my %pairs;
   $pairs {"$1$2"} ++ while $template =~ /(.)(?=(.))/g;

use YAML;
print Dump \%pairs;

__END__

$template =~ s/(.)\K(?=(.))/$rule{"$1$2"} if $rule {"$1$2"}/eg
    for 1 .. 10;

my %count;
   $count {$_} = eval "\$template =~ y/$_/$_/" for 'A' .. 'Z';

my $max = max grep {$_} values %count;
my $min = min grep {$_} values %count;

say "Solution 1: ", $max - $min;

__END__
