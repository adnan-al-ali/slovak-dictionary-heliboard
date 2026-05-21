#!/usr/bin/env perl

# Reweigh the words
# Sample: word="", f=8671269 to word="", f=200
# Source: command line argument
# Output to terminal

use strict;
use warnings;
use utf8;

my $path = $ARGV[0] or die "Usage: $0 <input-file>\n";

open my $source, "<:encoding(utf8)", $path or die $!;

my $first_line = <$source>;
defined $first_line or exit 0;

my ($max_freq) = $first_line =~ /f=(\d+(?:\.\d+)?)/;
$max_freq = 0 if !defined $max_freq;
my $max_log = $max_freq > 0 ? log($max_freq) : 0;

sub is_integer { $_[0] =~ /^[+-]?\d+$/ }

seek $source, 0, 0 or die $!;

while (my $line = <$source>) {
    next unless $line =~ /f=/;

    my ($name) = $line =~ m/=(.*),/;
    next if !defined $name || length($name) <= 1 || is_integer($name);

    my ($freq) = $line =~ /f=(\d+(?:\.\d+)?)/;
    next if !defined $freq;

    my $weighed = $max_log > 0
        ? int((log($freq) / $max_log) * 204 + 50)
        : 50;

    $line =~ s/(\d*[.])?\d+/$weighed/g;
    utf8::encode($line);
    print $line;
}

close $source;
