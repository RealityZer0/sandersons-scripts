#!/usr/bin/perl -w
use strict;

foreach (`scselect 2>&1`) {
    next unless /^\s*\*/;
    if (/\((\w+)/) {
        print "$1\n";
        exit;
    }
}

print "dunno\n";
