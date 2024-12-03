#!/usr/bin/perl
use strict;
use Mojo::File qw/path/;
use List::Util qw/pairs/;

my $memory = path($ARGV[0])->slurp;
my @valid = $memory =~ /(?:(do\(\)|don't\(\)|mul\(\d{1,3},\d{1,3}\)))/g;

my $doing = 1;
my $total = 0;

# this gets a little more expansive since we need to toggle the flag;
# the do/dont toggle could be written shorter and way more unreadably Perlish 
foreach my $fragment (@valid) {
    $doing = 1, next if($fragment eq 'do()');
    $doing = undef, next if($fragment eq 'don\'t()');
    next unless $doing;
    @numbers = $fragment =~ /mul\((\d+),(\d+)\)/;
    $total += $numbers[0] * $numbers[1];
}

print 'Total: ', $total, "\n";




