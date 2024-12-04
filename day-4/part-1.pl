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

sub check_cheer {
    my ($row, $column, $row_offset, $column_offset) = (@_);
    my @wants = (qw/X M A S/); 
    for my $i (0..3) {
        my $nr = $row + $row_offset * $i;
        my $nc = $column + $column_offset * $i;

        return 0 if($nr < 0 || $nr > $max_r || $nc < 0 || $nc > $max_c); # out of bounds
        return 0 unless $grid->[$nr]->[$nc] eq $wants[$i]; 
    }
    return 1;
}

my $directions = [
    [-1, 0],        # north
    [-1, 1],        # north-east
    [0, 1],         # east
    [1, 1],         # south-east
    [1, 0],         # south
    [1, -1],        # south-west
    [0, -1],        # west
    [-1, -1]        # north-west
];

for(my $r = 0; $r < $max_r; $r++) {
    for(my $c = 0; $c < $max_c; $c++) {
        next unless $grid->[$r]->[$c] eq 'X'; # since we're looking for that christmas cheer, skip everything that isn't cheerful to begin with! 
       
        # okay we have potential cheer, now see if we can find the word XMAS starting at our current grid coordinates, in all directions
        foreach my $dir (@$directions) {
            $total += check_cheer($r, $c, $dir->[0], $dir->[1]);
        }
    }
}

print 'Total: ', $total, "\n";
