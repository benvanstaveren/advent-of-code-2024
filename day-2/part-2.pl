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

sub report_is_safe {
    my @levels = (@_);

    return ((is_increasing(@levels) || is_decreasing(@levels)) && is_safe_difference(@levels))
        ? 1
        : undef;
    ;
}

# this is a naive approach that relies on copying the reported values
# and seeing if the modified report is in fact valid after removing
# each element in turn - there's probably a shinier way to do this
# but this works
sub fix_report {
    my @original = (@_);

    for(my $i = 0; $i < scalar(@original); $i++) {
        my @levels = @original; # make a copy
        splice(@levels, $i, 1); # remove an element
        return 1 if report_is_safe(@levels); # 
    }
    return 0;
}

foreach my $report_line (@content) {
    my @levels = split(/\s+/, $report_line);
    $safe_count += (report_is_safe(@levels))
        ? 1
        : fix_report(@levels)
    ;
}

print 'Safe: ', $safe_count, "\n";
