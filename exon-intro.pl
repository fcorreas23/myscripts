#!/usr/bin/perl
use strict;

my $file = shift;
my $list = shift;
my @idssr;
open(FILE, $file) or die "\nNo se encuentra el archivo n\n";
while (my $linea =<FILE>){
  chomp $linea;
  my @filas = split /\t/,$linea;
  my $id = $filas[1]."-".$filas[2]."-".$filas[0];
  push(@idssr,$id);
}
close(FILE);

my @idprimer;
open(FILE2, $list) or die "ERROR";
while (my $ln =<FILE2>){
	chomp $ln;
	push(@idprimer,$ln);
}
close(FILE2);
#3print scalar(@idssr);
##print "\n";
##print scalar(@idprimer);

for(my $i=0; $i<scalar(@idssr); $i++){
	if($idssr[$i] ~~ @idprimer){
		print "EXON \n";	
	}else{
		print "INTRON \n";	
	}

}
