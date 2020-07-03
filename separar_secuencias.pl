use strict;
use Bio::Seq;
use Bio::SeqIO;

my $file = shift;
my $numero = shift;
my $contador = 0;
my $contador2 = 0;
my $prefijo = 1;
my $f_out = "seq_papa";

my $objSeq = Bio::SeqIO->new(-file => "<$file", -format => 'fasta');

while(my $seq = $objSeq->next_seq ){
	my $id = $seq->id();
  open(OUT, ">>$f_out-".$prefijo."fasta");
	print OUT ">".$id."\n";
	print OUT $seq->seq."\n";
  $contador++;
  $contador2++;
  if($contador == $numero){
    $contador = 0;
    $prefijo++;
  }
}
close(OUT);
print "total secuencias: $contador2";
