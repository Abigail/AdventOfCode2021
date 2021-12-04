#!/opt/perl/bin/perl

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

package BingoCard {
    use Hash::Util::FieldHash qw [fieldhash];
    fieldhash my %card;
    fieldhash my %size;
    fieldhash my %finished;

    sub new ($class) {bless do {\my $var} => $class}
    sub init ($self, $input) {
        $card {$self} = [map {[/[0-9]+/g]} split /\n/ => $input];
        $size {$self} = @{$card {$self}};
        $self
    }
    sub bingo ($self) {
        my $card = $card {$self};
        my $size = $size {$self};
        foreach my $r (0 .. $size - 1) {
            return 1 unless grep {$_ >= 0} @{$$card [$r]};
        }
        foreach my $c (0 .. $size - 1) {
            return 1 unless grep {$_ >= 0}
                             map {$$card [$_] [$c]} 0 .. $size - 1;
        }
        return 0;
    }
    sub play ($self, $number) {
        foreach my $row (@{$card {$self}}) {
            foreach my $i (keys @$row) {
                $$row [$i] = -1 if $$row [$i] == $number;
            }
        }
        $self
    }
    sub left ($self) {
        my $sum = 0;
        foreach my $row (@{$card {$self}}) {
            foreach my $num (@$row) {
                $sum += $num if $num >= 0;
            }
        }
        $sum
    }
    sub finished ($self) {
        $finished {$self}
    }
    sub set_finished ($self) {
        $finished {$self} = 1
    }
}

@ARGV = "input" unless @ARGV;
$/ = "";  # Paragraph mode

my @numbers = <> =~ /[0-9]+/g;

my @cards = map {BingoCard:: -> new -> init ($_)} <>;

my $first_win = 0;
my $last_win  = 0;

foreach my $number (@numbers) {
    foreach my $i (keys @cards) {
        my $card = $cards [$i];
        next if $card -> finished;
        if ($card -> play ($number) -> bingo) {
            $first_win ||= $number * $card -> left;
            $last_win    = $number * $card -> left;
            $card -> set_finished;
        }
    }
}

say "Solution 1: $first_win";
say "Solution 2: $last_win";


__END__
