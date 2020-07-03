use strict;
use Bio::SeqIO;
use Bio::Seq;

my $file = shift;
my $start = shift;
my $end = shift;

my $seq_in = Bio::SeqIO->new(-file   => "<$file",-format => "fasta");
my $seq_out = Bio::SeqIO->new(-file   => ">$file.out.fasta",-format => "fasta",);
while (my $inseq = $seq_in->next_seq) {
      my $seq_obj = Bio::Seq->new(-seq => $inseq->subseq($start,$end ),
                -display_id => $inseq->display_id,
                -desc => "[$start....$end]",
                -alphabet => "dna" );
      $seq_out->write_seq($seq_obj);
}
