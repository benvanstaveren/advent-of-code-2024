#!/usr/bin/perl
use strict;
use Mojo::File qw/path/;

my $ordering_rules = [];
my $ruling = 1;

chomp(my @lines = split(/\n/, path($ARGV[0])->slurp));

# So, this pretty much solves both parts in one fell swoop; Perl
# provides custom sort functions, so we use that and the ordering
# rules to properly order the list of pages to print. 
#
# But that's really only necessary for part 2 - for part 1,
# we just need to see which updates are already in the correct
# order, but since there is no thing as an 'is_this_sorted' function
# we'll just do both at the same time 

sub sortfunc {
    # $a and $b are available here due to the sort function
    # making that happen - this also indirectly 
    # fixes whatever is broken
    foreach my $v (@{$ordering_rules->[$b]}) {
        return 1 if ($v == $a); 
    } 
    return -1;
}

sub is_sorted_and_maybe_fix {
    my @update = (@_);
    my @new = sort sortfunc @update;

    my $is_valid = 1;
    # this is a very slow and super naive way of comparing 2 lists to see if the
    # original order is the same as the ordering done by the sortfunc - if that is
    # the case, the list was already ordered properly. 
    for(my $i = 0; $i < scalar(@new); $i++) {
        $is_valid = 0, last unless $new[$i] == $update[$i];
    }

    # we'll tack the 'was it ordered already' flag on the end of the list
    push(@new, $is_valid);
    return @new; 
}

my $valid_s = 0;
my $fixed_s = 0;

foreach my $line (@lines) {
    $ruling = undef, next unless length($line) > 0; # line break = switch from rules to the page list so, easy to do this
    if($ruling) {
        my ($before, $after) = split(/\|/, $line);
        $ordering_rules->[$before] ||= [];
        push(@{$ordering_rules->[$before]}, $after);
    } else {
        my @update = split(/,/, $line); # split out all the pages

        # return the now "fixed" order of pages, and the flag to indicate
        # whether it was already good before we ordered it (part 1), and if not
        # then we do part 2 :D 
        my @t = is_sorted_and_maybe_fix(@update);
        if(pop(@t) == 1) {
            # it was already sorted
            $valid_s += @t[int(scalar(@t)/2)];
        } else {
            # it wasn't already sorted, got fixed, so we can do this for the part 2 solution
            $fixed_s += @t[int(scalar(@t)/2)];
        }
    }
}

print "Solution 1: ", $valid_s, "\n";
print "Solution 2: ", $fixed_s, "\n";



