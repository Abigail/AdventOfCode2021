#!/opt/perl/bin/perl

use 5.032;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

@ARGV = "input" unless @ARGV;
@ARGV = "t/input-1";


my $bits = join "" => map {sprintf "%04b" => hex} split // => <>;

$bits = "110100101111111000101000";
$bits = "00111000000000000110111101000101001010010001001000000000";


sub gimme ($bits) {
    my $version = oct "0b" . substr $bits, 0, 3, "";
    my $id      = oct "0b" . substr $bits, 0, 3, "";

    if ($id == 4) {
        say "Got id = $id";
        $bits =~ s/^((?:1[01]{4})*0[01]{4})//;
        my $value = $1 =~ s/[01]([01]{4})/$1/rg;
        say "Value = $value (" . oct ("0b$value") . ")";
    }
    elsif ($id == 6) {
        my $t = substr $bits, 0, 1, "";
        my $length = oct ("0b" . substr $bits, 0, $t ? 11 : 15, "");
        say "Length = $length";
    }
    $bits =~ s/^0+$//r;
}


say $bits;
$bits = gimme $bits;
say $bits;
