#!/usr/bin/perl -w
use strict;
use warnings;

my $files_ids 	= shift or die "ERROR: FILE IDS";
my $file 		= shift or die "ERROR: FILE NOT FOUND";

open(FILE,$files_ids) or die "ERROR: FILE NOT OPEN";
while (my $row = <FILE>){
	chomp($row);
	my $aux = filter_by_id($row);
	if($aux == 0){
		print $row."\n";
	}
}
close(FILE);


sub filter_by_id{

	my $id = shift;
	my $count = 0;
	open(FILE2, $file) or die "ERROR: FILE NOT OPEN 2";
	while (my $row = <FILE2>){
		chomp($row);
		my @rows = split /\t/, $row;
		if ($rows[0] eq $id) {
			print $row;
			print "\n";
            $count++;
			last;
			
		}
	}
	close(FILE2);
	return $count;
}
