#!/usr/bin/perl
use strict;
use List::Util qw/pairs/;
use Mojo::File qw/path/;

my $content = path($ARGV[0])->slurp;

my @values = $content =~ /(\d+)/g;
my (@left, @right);
push(@left, $_->[0]), push(@right, $_->[1]) for(pairs(@values));

@left = sort(@left);
@right = sort(@right);

my $total_dist = 0;

foreach my $left_entry (@left) {
    my $right_entry = shift(@right); # note, destructive operation, alters the list 
    my $dist = ($left_entry >= $right_entry) 
        ? $left_entry - $right_entry
        : $right_entry - $left_entry;
    ;

    $total_dist += $dist;
}

print 'Total distance: ', $total_dist, "\n";
