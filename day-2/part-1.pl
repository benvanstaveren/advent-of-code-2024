#!/usr/bin/perl
use strict;
use List::Util qw/pairs/;
use Mojo::File qw/path/;

chomp(my @content = split(/\n/, path($ARGV[0])->slurp));
my $safe_count = 0;

sub is_increasing {
    my @levels = (@_); 
    my $i = 0;

    for(my $i = 0; $i < scalar(@levels) - 1; $i++) {
        return undef unless $levels[$i+1] < $levels[$i];
    }
    return 1;
}

sub is_decreasing {
    my @levels = (@_); 
    my $i = 0;

    for(my $i = 0; $i < scalar(@levels) - 1; $i++) {
        return undef unless $levels[$i+1] > $levels[$i];
    }
    return 1;
}

sub diff {
    my $a = shift;
    my $b = shift;

    return ($a > $b) 
        ? $a - $b
        : $b - $a;
}

sub is_safe_difference {
    my @levels = (@_);

    for(my $i = 0; $i < scalar(@levels) - 1; $i++) {
        my $d = diff($levels[$i], $levels[$i + 1]);
        return undef unless ($d >= 1 && $d <= 3);
    }
    return 1;
}

foreach my $report_line (@content) {
    my @levels = split(/\s+/, $report_line);
    # just to note, perl is relatively clever in the sense that when using &&, shortcut behaviour
    # is enabled which means if the left part of the evaluation fails, the right side isn't evaluated at 
    # all, which means that is_safe_difference is only called *if* is_increasing || is_decreasing 
    # evaluates to true 
    $safe_count += ((is_increasing(@levels) || is_decreasing(@levels)) && is_safe_difference(@levels))
        ? 1
        : 0;
}

print 'Safe: ', $safe_count, "\n";
