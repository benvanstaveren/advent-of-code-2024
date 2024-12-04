#!/usr/bin/perl
use strict;
use List::Util qw/pairs/;
use Mojo::File qw/path/;

my $content = path($ARGV[0])->slurp;
my @values = $content =~ /(\d+)/g;

my (@left, @right);
push(@left, $_->[0]), push(@right, $_->[1]) for(pairs(@values));

# the below 2 lines are a way to get the occurrence counts into
# an associative hash, this makes looking up how often a number occurs
# in the right list quite trivial 
my %occurs = ();
$occurs{$_}++ for(@right); 

my $sim_score = 0;

foreach my $left_entry (@left) {
    my $occur_count = $occurs{$left_entry} || 0;
    $sim_score += $left_entry * $occur_count;
}

print 'Similarity score: ', $sim_score, "\n";
