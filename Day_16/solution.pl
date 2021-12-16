#!/opt/perl/bin/perl

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use List::Util qw [min max sum product];

@ARGV = "input" unless @ARGV;

my $SUM          = 0;
my $PRODUCT      = 1;
my $MINIMUM      = 2;
my $MAXIMUM      = 3;
my $VALUE        = 4;
my $GREATER_THAN = 5;
my $LESS_THAN    = 6;
my $EQUAL        = 7;

my $TYPE_LENGTH  = 0;
my $TYPE_COUNT   = 1;


#
# Read input, turn it into bits
#
my $bits = join "" => map {sprintf "%04b" => hex} split // => <>;

sub parse ($bits, $count = undef) {
    my $return;

    while (defined ($count) ? $count -- : $bits =~ /1/) {
        my $version = oct "0b" . substr $bits, 0, 3, "";
        my $id      = oct "0b" . substr $bits, 0, 3, "";

        if ($id == $VALUE) {
            $bits =~ s/^((?:1[01]{4})*0[01]{4})//;
            my $value = $1 =~ s/[01]([01]{4})/$1/rg;
            no warnings 'portable';
            push @$return => [$version, $id => oct "0b$value"];
        }
        else {
            my $type = substr $bits, 0, 1, "";
            my ($rec, $left);
            if ($type == $TYPE_LENGTH) {
                my $length = oct ("0b" . substr $bits, 0, 15, "");
                my $chunk  = substr $bits, 0, $length, "";
                ($rec)     = parse ($chunk);
            }
            else {
                my $count     = oct ("0b" . substr $bits, 0, 11, "");
                ($rec, $left) = parse ($bits, $count);
                $bits         = $left;
            }
            push @$return => [$version, $id => $rec];
        }
    }
   ($return, $bits);
}


sub walk ($chunk) {
    my ($version, $id, $payload) = @$chunk;
    my $sum   = $version;
    my $value = 0;

    if ($id == $VALUE) {
        $value = $payload;
    }
    else {
        #
        # Recursively walk the the payload
        #
        my @rec = map {walk ($_)} @$payload;
        $sum += $$_ [0] for @rec;
        my @val_list = map {$$_ [1]} @rec;
        
        #
        # Calculate the values
        #
        if ($id == $SUM)          {$value = sum     @val_list}
        if ($id == $PRODUCT)      {$value = product @val_list}
        if ($id == $MINIMUM)      {$value = min     @val_list}
        if ($id == $MAXIMUM)      {$value = max     @val_list}
        if ($id == $GREATER_THAN) {$value = $val_list [0]  > $val_list [1]}
        if ($id == $LESS_THAN)    {$value = $val_list [0]  < $val_list [1]}
        if ($id == $EQUAL)        {$value = $val_list [0] == $val_list [1]}
    }
    [$sum, $value || 0];
}


my $result = walk +(parse $bits) [0] [0];

say "Solution 1: ", $$result [0];
say "Solution 2: ", $$result [1];


__END__
