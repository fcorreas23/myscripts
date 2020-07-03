#!/usr/bin/perl
use strict;
use warnings;

use Getopt::Long;

# Richard Emes University of Nottingham 2013
my $usage = "
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

random split of fastq file
Assumes paired fastq files are sorted ie sequence x is the pair in each file

USAGE:
-f1	fastq file pair one
-f2	fastq file pair two
-c	count of fastq sequences to have in final file.
-h	header of fastq file e.g \"\@HISEQ2_0953\"
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
" ;


my ($file1, $file2, $count, $header);

GetOptions(
        'f1|fastq:s'     => \$file1,
        'f2|fastq:s'     => \$file2,
	'c|count:s'    => \$count,
	'h|header:s'    => \$header,
         );


if( ! defined $file1) {
print "$usage\nWARNING: Cannot proceed without fastq pair one to process\n\n"; exit;
}
if( ! defined $file2) {
print "$usage\nWARNING: Cannot proceed without fastq pair two to process\n\n"; exit;
}
if( ! defined $count) {
print "$usage\nWARNING: Cannot proceed without count (number of sequences to select)\n"; exit;
}
if( ! defined $header) {
print "$usage\nWARNING: Cannot proceed without header details\n"; exit;
}


my $range = 0;
### check number of reads in fastq file
print "[counting reads]\n";
open FASTQ1, "$file1";
while (<FASTQ1>)
{
chomp $_;
if ($_ =~ /^$header/)
	{
	$range++;
	}
}
close FASTQ1;

if ($count > $range)
{print "\nError: count exceeds number of reads\nReads = $range\nCount = $count\n";exit;}


my %lookup_hash;
my $random_count = 0;

## pick random read numbers within file
while ($random_count < $count)
	{
	my $random_number = int(rand($range));
	if (exists $lookup_hash{$random_number}){}
	else 
		{
		$lookup_hash{$random_number} = 1;
		$random_count++;
		}
	}


print "[selecting reads]\n";
open FASTQ1, "$file1";
open OUT1, ">$file1\.selected.fastq";
open OUT2, ">$file1\.unselected.fastq";

my $read_count = 0; 
my $flag = 0;
my $hitreads = 0;
my $missreads = 0;
print "[printing files pair 1]\n";
while (<FASTQ1>)
{
chomp $_;
my $line = $_;
if ($line =~ /^$header/)
	{
	if (exists ($lookup_hash{$read_count}))
		{
		$read_count++;
		$flag = 1;
		$hitreads++;
		}
	else {
		$read_count++;
		$flag = 0;
		$missreads++;
		}
	}	
	
	if ($flag == 1)
		{
		print OUT1 "$line\n";
		}
	elsif ($flag == 0)
		{
		print OUT2 "$line\n";
		}
}
close FASTQ1;
close OUT1;
close OUT2;


open FASTQ2, "$file2";
open OUT3, ">$file2\.selected.fastq";
open OUT4, ">$file2\.unselected.fastq";

$read_count = 0; 
$flag = 0;

print "[printing files pair 2]\n";
while (<FASTQ2>)
{
chomp $_;
my $line = $_;
if ($line =~ /^$header/)
	{
	if (exists ($lookup_hash{$read_count}))
		{
		$read_count++;
		$flag = 1;
		}
	else {
		$read_count++;
		$flag = 0;
		}
	}	
	
	if ($flag == 1)
		{
		print OUT3 "$line\n";
		}
	elsif ($flag == 0)
		{
		print OUT4 "$line\n";
		}
}
close FASTQ2;
close OUT3;
close OUT4;

my $total_sum = ($hitreads+$missreads);

print "[complete]\n";
print "\nTotal Reads: $range\nRead Count requested: $count\nRead Count selected: $hitreads\nRead Count rejected: $missreads\nTotal combined (selected+rejected): $total_sum\n\n";



