import sys,os
import re
import csv
import json
from datetime import date
from Bio import SeqIO
from Bio.Seq import Seq
from Bio.SeqRecord import SeqRecord
from Bio.Alphabet import generic_protein



'''
Filtra el Archivo generado por eggNOG
0: #query_name              10: KEGG_Module     20: COG Functional cat.	
1: seed_eggNOG_ortholog	    11: KEGG_Reaction   21: eggNOG free text desc
2: seed_ortholog_evalue     12: KEGG_rclass
3: seed_ortholog_score      13: BRITE
4: best_tax_level           14: KEGG_TC	
5: Preferred_name           15: CAZy
6: GOs	                    16: BiGG_Reaction
7: EC                       17: taxonomic scope
8: KEGG_ko                  18: eggNOG OGs
9: KEGG_Pathway             19: best eggNOG OG	

Funcion para leer archivos eggNOG
'''


def getEggnogResult(file):
    result = []
    with open(file) as tsvFile:
        rows = csv.reader(tsvFile, delimiter='\t')
        line_count = 0
        for row in rows:
            if line_count == 0:
                line_count += 1 
            else:
                result.append([row[0],row[21],row[5],row[20],row[6],row[8],row[9],row[17]])
                line_count += 1
    
    return result

#Blast output en formato 6
def getBlastResult(file):
    result = []
    with open(file) as tsvFile:
        rows = csv.reader(tsvFile, delimiter='\t')
        line_count = 0
        for row in rows:
            if line_count == 0:
                line_count += 1 
            else:
                result.append([row[0],f'{row[2]}|{row[3]}'])
                line_count += 1
    
    return result



def updateDescFasta(id,eggnog,blast):
    default_array = ['','','','','','','',"",""]
    for row in eggnog:        
        if id == row[0]:
            default_array = [row[1],row[2],row[3],row[4],row[5],row[6],row[7]]
            break
    for row in blast:
        if id == row[0]:
            default_array.extend([row[1]])
    return default_array

def makeDirOutput(name):
    today = date.today()
    directory = f'{name}-{today}'
    path = os.path.join(os.getcwd(), directory)
    try:
        os.mkdir(path)
        return path
    except OSError:
        print (f'No se pudo crear el directorio {directory}')





def main():
    
    fastaFile = sys.argv[1]
    eggNOG = sys.argv[2]
    blastFile = sys.argv[3]
    nameFile = os.path.basename(sys.argv[1]) #name fasta file    
    outName = os.path.splitext(nameFile)[0] #prefix output name
    new_fasta =[]
    anotacion = []
    array = []
    #Obtiene las descripciones del archivo gerenado por eggNOG
    eggnNOG_desc = getEggnogResult(eggNOG)
    blast_result = getBlastResult(blastFile)


    #Lee el archivo fasta 
    for sequence in SeqIO.parse(fastaFile, "fasta"):
        #obtener descripcion por defecto
        default_desc = sequence.description.split(sequence.id)
        #obtner la descripcion de eggNOG
        eggNOG_anotacion = updateDescFasta(sequence.id, eggnNOG_desc,blast_result)
        #concatenar las descripciones 
        new_desc = f'{default_desc[1]}|{eggNOG_anotacion[0]}|{eggNOG_anotacion[1]}'
        #Generar un objeto para el archivo fasta
        rec = SeqRecord(Seq(str(sequence.seq),generic_protein),id=sequence.id,description=new_desc)
        new_fasta.append(rec)
        anotacion.append([sequence.id, str(sequence.seq), len(sequence), new_desc, eggNOG_anotacion[1], eggNOG_anotacion[2], eggNOG_anotacion[3], eggNOG_anotacion[4], eggNOG_anotacion[5], eggNOG_anotacion[6],eggNOG_anotacion[7]])
        
        anotacionDict = dict(id=sequence.id,
        sequence=str(sequence.seq),
        lenght=len(sequence),
        desc=new_desc,
        preferred_name=eggNOG_anotacion[1],
        funcional_COG=eggNOG_anotacion[2],
        GOs=eggNOG_anotacion[3],
        KEGG_ko=eggNOG_anotacion[4],
        KEGG_pathway=eggNOG_anotacion[5],
        tax_scope=eggNOG_anotacion[6],
        best_blast=eggNOG_anotacion[7])
        
        array.append(anotacionDict)
    
    path_out = makeDirOutput(outName)
    print(f'Generado resultados en {path_out}')
         
    #Genera el nuevo archivo fasta
    SeqIO.write(new_fasta, f'{path_out}/{outName}_new.fasta', "fasta")

   
   #Genera el archivo tsv
    with open(f'{path_out}/{outName}.tsv', 'w') as tsv:
        writer = csv.writer(tsv, delimiter='\t')
        writer.writerow(['id', 'sequence','length','desc','preferred_name','funcional_COG','GOs','KEGG_ko','KEGG_pathway','tax_scope','best_blast'])
        for row in anotacion:
            writer.writerow(row)
    
    #Genera el archivo json
    with open(f'{path_out}/{outName}.json', "w") as f:
        f.write(json.dumps(array))




    print(f'Numero de secuencias: {len(new_fasta)}')
    print(f'Numero de secuencias anotadas: {len(eggnNOG_desc)}')
    print(f'Numero de secuencias Blasteadas: {len(blast_result)}')

if __name__ == '__main__':
      main()
