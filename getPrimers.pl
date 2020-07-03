#!/usr/bin/perl
use strict;

my $file = shift;

open(FILE, $file) or die "\nNo se encuentra el archivo n\n";
while (my $linea =<FILE>){
  chomp $linea;
  my @filas = split /\t/,$linea;
  print ">".$filas[1]."-".$filas[4];
  print "\n";
  print $filas[11]."\n";
}
