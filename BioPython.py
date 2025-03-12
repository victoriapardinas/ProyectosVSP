
from Bio.Blast import NCBIWWW
from Bio import SeqIO
from Bio.Blast import NCBIXML

import pandas as pd

# nombre del fasta (a cambiar para que el usuario lo ingrese)
input_file = "final.fasta"

record = SeqIO.read(input_file, "fasta")  # carga el fasta
sequence = record.seq

# busqueda de blast remota en la base de datos de swissprot de NCBI
result_handle = NCBIWWW.qblast("blastp", "swissprot", sequence)
# guarda blast en un archivo XML
with open("blast_results.xml", "w") as out_handle:
    out_handle.write(result_handle.read())

result_handle.close()

# Abrir el archivo blast en formato XML
blast_file = open("blast_results.xml")
blast_records = NCBIXML.parse(blast_file)

# Crear un nuevo archivo fasta para guardar las secuencias
fasta_file = open("blast_results.fasta", "w")

# Iterar sobre los registros blast
for blast_record in blast_records:
    for alignment in blast_record.alignments:
        for hsp in alignment.hsps:
            # Obtener la secuencia y el identificador
            sequence = hsp.sbjct
            sequence_id = alignment.title

            # Escribir la secuencia en formato fasta en el archivo
            fasta_file.write(">" + sequence_id + "\n")
            fasta_file.write(sequence + "\n")

# Cerrar los archivos
blast_file.close()
fasta_file.close()
from Bio.Blast import NCBIXML
import pandas as pd

# Ruta del archivo XML de BLAST
blast_xml_file = "blast_results.xml"

# Lista para almacenar los resultados
blast_records = []

# Parsear el archivo XML
with open(blast_xml_file) as result_handle:
    blast_record = NCBIXML.read(result_handle)
    for alignment in blast_record.alignments:
        for hsp in alignment.hsps:
            record = {
                'Hit ID': alignment.hit_id,
                'Hit Def': alignment.hit_def,
                'E-value': hsp.expect,
                'Score': hsp.score,
                'Identities': hsp.identities,
                'Positives': hsp.positives,
                'Gaps': hsp.gaps,
                'Alignment Length': hsp.align_length,
            }
            blast_records.append(record)

# Crear un DataFrame de pandas con los resultados
df = pd.DataFrame(blast_records)

# Guardar el DataFrame en un archivo CSV
df.to_csv('blast_results.csv', index=False)

