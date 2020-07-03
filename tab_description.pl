use strict;
use Bio::SeqIO;
use Bio::Seq;

my $file = shift;

my $seq_in = Bio::SeqIO->new(-file   => "<$file",-format => "fasta");
while (my $inseq = $seq_in->next_seq) {
      print $inseq->display_id."\t".$inseq->desc;
      print "\n";
}
