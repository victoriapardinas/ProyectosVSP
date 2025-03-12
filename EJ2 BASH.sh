pip install pandas

k=$(ls | grep final.fasta | wc -l)
if [ $k -eq 0 ]; then
        echo "Error! No existe el archivo final.fasta"
	echo "$(date) No se encontro el archivo final.fasta" >> errores.log
	echo "$(date) No se ejecuto Ex2.sh correctamente" >> auditoria.log
	exit 1
fi

> blast_results.fasta
> blast_results.xml
> blast_results.csv

translate2=$(python3 ej2.py)
echo "$(date) - Se crearon blast_results.fasta y blast_results.xml correctamente" >> auditoria.log
echo "$(date) - Se ejecuto el ejercicio 2" >> auditoria.log

