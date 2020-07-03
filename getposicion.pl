#!/usr/bin/perl
use strict;
use DBI;

my $filessr 		= shift;
my $estructura = shift;


my @id;
my @ssr;
my @start;
my @end;

open(FILE, $filessr) or die "ERROR";
while (my $linea =<FILE>) {
	chomp($linea);
	my @filas = split /\t/,$linea;
	push(@id,$filas[0]);
	push(@ssr,$filas[3]);
	push(@start,$filas[5]);
	push(@end,$filas[6]);
}
close(FILE);

#my($cromosoma,$inicio,$fin) = consulta($id[0]);
#print $id[0]."\t".$ssr[0]."\t".$start[0]."\t".$end[0];
#print "\n";
#print $id[0]."\t".$inicio."\t".$fin;
#my $x = $start[0]+$inicio;
#my $y = $end[0]+$inicio;
#print "\n";
#print $id[0]."\t".$ssr[0]."\t".$x."\t".$y;
#tipo($id[0],$x,$y);

for (my $i = 0; $i < scalar(@id); $i++) {
	my($inicio,$fin) = consulta($id[$i]);
	my $x = $start[$i]+$inicio;
	my $y = $end[$i]+$inicio;
	tipo($id[$i],$x,$y);
}



sub consulta{
	my $id_gen = shift;
	my $dbh = DBI->connect('DBI:mysql:solanaceae', 'root', 'ceafito') || die "Could not connect to database: $DBI::errstr";
	my $sth = $dbh->prepare("SELECT start,end FROM papa WHERE name = '$id_gen'");
	$sth->execute();
	my $result = $sth->fetchrow_hashref();
	my $inicio = $result->{start};
	my $fin = $result->{end};
	$sth->finish;
	$dbh->disconnect();
	return ($inicio,$fin);
}

sub tipo{
	my $name = shift;
	my $inicio = shift;
	my $end = shift;
	my $cont=0;
	open(FILE,"exon-papa.csv") or die "ERROR";
	while (my $linea =<FILE>){
		chomp($linea);
		my @filas = split /\t/,$linea;
		#print $filas[1];
		if($filas[1] eq $name){
			if(($inicio >= $filas[2] and $end <= $filas[3])){
				$cont++;
			}
		}		
	}
	close(FILE);
	if($cont > 0){
		print "$name \t EXON\n";
	}else{
		print "$name \t INTRON\n"
	}
	#print "EXON: ".$start."-".$end."\n";

}
