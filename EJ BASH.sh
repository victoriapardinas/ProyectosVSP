while true; do
	read -p "Ingrese el codigo de secuencia de referencia en NCBI (sin el NM): " refsec
	if [ -f "NM${refsec}.gb" ]; then
    	echo "$(date) - Se encontró el archivo NM${refsec}.gb" >> auditoria.log
    	break
	else
    	echo "$(date) - No se encontró el archivo NM${refsec}.gb. Por favor, vuelva a ingresar un código válido." >> errores.log
	fi
done

touch nombre.txt
chmod 777 nombre.txt
echo $refsec > nombre.txt

touch $refsec.fasta
chmod 777 $refsec.fasta
> $refsec.fasta

for i in 1 2 3 4 5 6
do
	output=$(python3 Ex1.py "$refsec" "$i")
	id=$(echo "$output" | awk 'NR==1')
	descrip=$(echo "$output" | awk 'NR==2')
	translate=$(echo "$output" | awk 'NR==3')
	new_id=$id"_"$i
	echo ">$new_id | $descrip" >> $refsec.fasta
	echo $translate | fold -w 80 >> $refsec.fasta
done

echo "$(date) - Se creo el archivo $refsec.fasta correctamente" >> auditoria.log

touch final.fasta
chmod 777 final.fasta
> final.fasta

output_2=$(python3 find_trans.py "$refsec.fasta")
ORF_desc=$(echo "$output_2" | awk 'NR==1')
ORF_seq=$(echo "$output_2" | awk 'NR==2')
echo ">$ORF_desc" >> final.fasta
echo $ORF_seq | fold -w 80 >> final.fasta

echo "$(date) - Se creo correctamente el archivo final.fasta" >> auditoria.log

echo "$(date) - Se ejecuto el ejercicio 1" >> auditoria.log

