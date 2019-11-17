#Pipeline para analizar muestras de RNAseq de E.coli.

#Previamente se ha tenido que preparar el ambiente en conda, 
#instalar los programas fastqc, seqtk, cutadapt, STAR, multiqc

# Download the E.coli genome in the $WD/res/genome y lo descomprimimos
wget -O $WD/res/genome/ecoli.fasta.gz ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/G$
gunzip -k $WD/res/genome/ecoli.fasta.gz

#Creación de los directorios necesarios para el analisis.
mkdir -p out/fastqc original res/genome/star_index out/cutadapt log/cutadapt 


for sample in $(ls data/*.fastq.gz|cut -d "_" -f1|sed 's:data/::' |sort|uniq)
do 
	bash scripts/analyse_sample.sh $sample
done
