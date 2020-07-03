use strict;
use warnings;
use Bio::SeqIO;

my ( $file, %hash, %seen ) = shift;

for my $i ( 0 .. 1 ) {
    my $in = Bio::SeqIO->new( -file   => $file, -format => 'Fasta' );

    while ( my $seq = $in->next_seq() ) {
        if ( !$i ) {
            $hash{ $seq->id } = $seq->desc if !defined $hash{ $seq->id } or length $seq->desc > length $hash{ $seq->id };
        }
        else {
            print '>'. $seq->id . ' ' . $hash{ $seq->id } . "\n" . $seq->seq . "\n" if !$seen{ $seq->id }++;
        }
    }
}

