import sys,os
import json
from Bio import SeqIO


def main():
	
	fastaFile = sys.argv[1]
	nameFile = os.path.basename(sys.argv[1]) #name fasta file    
    #outName = os.path.splitext(nameFile)[0] #prefix output name

	
	fastaObjeto = []

	for sequence in SeqIO.parse(fastaFile, "fasta"):

		default_desc = sequence.description.split(sequence.id)
		fastaDic = dict(id=sequence.id, sequence=str(sequence.seq), lenght=len(sequence), desc=default_desc[1])
		fastaObjeto.append(fastaDic)

	with open(f'{nameFile}.json', "w") as f:
		f.write(json.dumps(fastaObjeto))


if __name__ == '__main__':
      main()