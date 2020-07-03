#!/usr/bin/perl

use strict;
use Bio::Seq;
use Bio::SeqIO;

my $file = shift;

my $objSeq = Bio::SeqIO->new(-file => "<$file", -format => 'fasta');

while(my $seq = $objSeq->next_seq ){
	my $id = $seq->id();
	print ">".$id."\n";
	print $seq->seq."\n";
}
