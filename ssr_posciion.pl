#!/usr/bin/perl
use strict;

#Arrays
my @scaffolds;
my @posicion;
my @genes;
my @idEncontrados;
my @tipo;
#variables;
my $con1;
my $con2;
my $marca;
my($genomic,$exon,$intron,$utr3,$utr5)=0;


sub tipo{
	my $scaffold = shift;
	my $pos = shift;

	open(FILE2, "Ppersica_139_gene.gff3") or die;
		while (my $linea =<FILE2>){
			chomp $linea;
			my @fields = split /\t/,$linea;

			if($fields[0] eq $scaffold){
				if($pos >= $fields[3] and $pos <= $fields[4]){
					if($fields[2] eq "CDS"){
						return "exon";
					}elsif($fields[2] eq "gene"){

					}elsif($fields[2] eq "mRNA"){

					}elsif($fields[2] eq "three_prime_UTR"){
						return "three_prime_UTR";
					}elsif($fields[2] eq "five_prime_UTR"){
						return "five_prime_UTR";
					}else{
						print "intron\n";
					}
				}
			}
		}
	close(FILE2);
}

################### MAIN ####################################
my $usage  = "Uso: SNP.pl fileSNP \n" ;
my $infile = shift or die $usage;

print "Identify genes.......";
open(FILE,$infile) or die "[Error]File not found\n";
	while (my $linea = <FILE>){
		chomp($linea);
		my ($sca,$pos) = split(/\t/,$linea);
		push(@scaffolds,$sca);
		push(@posicion,$pos);
	}
close(FILE);

for (my $i =0; $i<scalar(@posicion);$i++) {
	my $gen = conexio_bd($scaffolds[$i],$posicion[$i]);

	if (!$gen){
		push(@genes,"NA");
		$con1++;
	}else{
		push(@genes,$gen);
		$con2++;

		if($gen ~~ @idfindings){ #checks whether the gene is already in the array

		}else{
			push(@idEncontrados,$gen);
		}
	}
}
print "\nIdentifying Regions of SNPs........";
my $j=0;
foreach my $i (@posicion){

	if($genes[$j] eq "NA"){
		push(@tipo,"Intergenica");
		print "Intergenica\n";
	}else{
		$marca = tipo($scaffolds[$j],$i);
		push(@tipo,$marca);
		print "$marca\n";
	}
	$j++;
}
open(FILEOUT,">snpFinal.csv");
print FILEOUT "Scaffold\tPosicion\tGen\tRegion\t\n";
for (my $i =0; $i<scalar(@posicion); $i++) {
	print FILEOUT "$scaffolds[$i]\t$posicion[$i]\t$genes[$i]\t$tipo[$i]\n"
}
close(FILEOUT);
print "\n\ncreating file log.........\n";
foreach my $x (@tipo){

	if ($x eq "Intergenica"){
		$genomica++;
	}
	if ($x eq "1"){
		$intron++;
	}
	if ($x eq "exon"){
		$exon++;
	}
	if ($x eq "three_prime_UTR"){
		$utr3++;
	}
	if ($x eq "five_prime_UTR"){
		$utr5++;
	}
}
open (LOG,">result.log");
print LOG "RESULTS\n\n";
print LOG "Total number of SNPs: ".scalar(@posicion)."\n";
print LOG "Number of not associated genes: $con2 \n";
print LOG "Number of associated genes: $con1 \n";
print LOG "Number of different genes: ".scalar(@idfindings);
print LOG "\n\nREGIONES\n\n";
print LOG "Intergeni: $genomic \n";
print LOG "Exon: $exon \n";
print LOG "Intron: $intron \n";
print LOG "3'UTR: $utr3 \n";
print LOG "5'UTR: $utr5 \n";
close(LOG);
print "\n FINISH\n"
