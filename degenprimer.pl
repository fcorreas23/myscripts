#!/usr/bin/perl  
 use strict;  
 my $degenerate_sequence = $ARGV[0] || die "# usage: $0 <degenerate DNA sequence>\n";  
 my $regenerated_seqs = regenerate($degenerate_sequence);  
 
 foreach my $seq (@$regenerated_seqs)  
 {  
    print "$seq\n";  
 }  

 sub regenerate  
 {  
    my ($primerseq) = @_;  
    my %IUPACdegen = (   
    'A'=>['A'],'C'=>['C'], 'G'=>['G'], 'T'=>['T'],   
    'R'=>['A','G'], 'Y'=>['C','T'], 'S'=>['C','G'], 'W'=>['A','T'], 'K'=>['G','T'], 'M'=>['A','C'],  
    'B'=>['C','G','T'], 'D'=>['A','G','T'], 'V'=>['A','C','G'], 'H'=>['A','C','T'],   
    'N'=>['A','C','G','T']   
    );  
    my @oligo = split(//,uc($primerseq));   
    my @grow = ('');  
    my @newgrow = ('');  
    my ($res,$degen,$x,$n,$seq);  
    foreach $res (0 .. $#oligo){  
       $degen = $IUPACdegen{$oligo[$res]};
   
       if($#{$degen}>0){  
          $x = 0;  
          @newgrow = @grow;  
          while($x<$#{$degen}){  
             push(@newgrow,@grow);  
             $x++;     
          }     
          @grow = @newgrow;  
       }  
       $n=$x=0;   
       foreach $seq (0 .. $#grow){  
          $grow[$seq] .= $degen->[$x];   
          $n++;  
          if($n == (scalar(@grow)/scalar(@$degen))){  
             $n=0;  
             $x++;  
          }     
       }  
    }  
    return \@grow;     
 }            
