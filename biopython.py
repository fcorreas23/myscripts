from Bio import SeqIO
from Bio.SeqRecord import SeqRecord

lista = []

for seq_record in SeqIO.parse("TranscriptomaDeNovo.fasta", "fasta"):
    codigo      = seq_record.id
    secuencia   = seq_record.seq
    largo       = len(seq_record.seq)
    record = SeqRecord(secuencia,id=codigo,description="")
    lista.append(record)

SeqIO.write(lista,"prunus.faa","fasta")



