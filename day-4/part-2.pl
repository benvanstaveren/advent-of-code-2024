#!/usr/bin/perl
use strict;
use Mojo::File qw/path/;
use List::Util qw/pairs/;

my $contents = path($ARGV[0])->slurp;
my $total = 0;
my $grid = [];

chomp(my @horizontal = split(/\n/, $contents));
foreach my $line (@horizontal) {
    push(@$grid, [ split(//, $line) ]);
}

my $max_r = scalar(@$grid); 
my $max_c = scalar(@{$grid->[0]}); # assumes each row has the same number of columns 

sub got_cheer {
    my ($row, $column) = (@_);

    # let's do a bounds check, we need at least 1 row and 1 column of margin for
    # this to even be possible
    return undef if($row < 1 || $row > $max_r - 1 || $column < 1 || $column > $max_c - 1);

    # so now we need to check a few coordinates relative to the 'A'; we'll just grab whatever
    # characters are actually there, makes it easier to check
    my $tl_br = $grid->[$row-1]->[$column-1] . $grid->[$row]->[$column] . $grid->[$row+1]->[$column+1];
    my $tr_bl = $grid->[$row-1]->[$column+1] . $grid->[$row]->[$column] . $grid->[$row+1]->[$column-1];

    my $v = 0;

    # if top left to bottom right is either MAS or SAM we bump the return value
    $v += ($tl_br eq 'SAM') 
        ? 1
        : ($tl_br eq 'MAS')
            ? 1
            : 0;

    # and similarly here but for top right to bottom left
    $v += ($tr_bl eq 'SAM')
        ? 1
        : ($tr_bl eq 'MAS')
            ? 1 
            : 0;

    # and if both directions are valid, we found or X-mas cheer! yay. Otherwise no. No cheer.
    return ($v == 2) ? 1 : undef;
}

for(my $r = 0; $r < $max_r; $r++) {
    for(my $c = 0; $c < $max_c; $c++) {
        next unless $grid->[$r]->[$c] eq 'A'; # skip if it's not 'A' 
        $total += 1 if got_cheer($r, $c); # and add 1 to the total if we found the MAS/SAM X
    }
}

print 'Total: ', $total, "\n";
