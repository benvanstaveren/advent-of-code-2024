#!/usr/bin/perl
use Mojo::File qw/path/;
use List::Util qw/pairs/;

my $memory = path($ARGV[0])->slurp;
my @valid = $memory =~ /mul\((\d{1,3}),(\d{1,3})\)/g;
my $total = 0;

$total += $_->[0] * $_->[1] for(pairs(@valid));

print 'Total: ', $total, "\n";



