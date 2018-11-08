#!/usr/bin/env perl
#
# convert output from `tarsnap --print-stats --csv-file`
# into zabbix-sender format

use strict;
use warnings;
use v5.22.0;

foreach my $line ( <STDIN> ) {
    chomp( $line );
    my @csv = split /,/, $line;

    # no more data
    exit 0 unless @csv;

    # hard-coded conditions for the three expected input lines
    if ($csv[0] eq "Archive name") {
        if (($csv[1] ne "Total size") || ($csv[2] ne "Compressed size")) {
            print STDERR "Invalid first line";
            exit 1;
        }
    }
    elsif ($csv[0] eq "All archives") {
      printf "- tarsnap.all.total %d\n- tarsnap.all.compressed %d\n", ($csv[1], $csv[2])
    }
    elsif ($csv[0] eq "  (unique data)") {
      printf "- tarsnap.unique.total %d\n- tarsnap.unique.compressed %d\n", ($csv[1], $csv[2])
    }
    else {
        print STDERR "Unexpected input";
        exit 1;
    }
}
