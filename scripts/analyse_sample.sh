#Script para el análisis de datos de RNAseq de E.coli
#Previamente se ha tenido que preparar el ambiente en conda, 
#instalar los programas fastqc, seqtk, cutadapt, STAR, multiqc

# Download the E.coli genome in the $WD/res/genome
wget -o $WD/res/genome/ecoli.fasta.gz ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.fna.gz

#Creación de los directorios necesarios para el analisis.
mkdir -p out/fastqc original res/genome/star_index out/cutadapt log/cutadapt 



if [ "$#" -eq 1 ]
then
    sampleid=$1
    echo "Running FastQC..."
    fastqc -o out/fastqc data/${sampleid}*.fastq.gz
    echo
    echo "Running cutadapt..."
    cutadapt -m 20 -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT -o out/cutadapt/${sampleid}_1.trimmed.fastq.gz -p out/cutadapt/${sampleid}_2.trimmed.fastq.gz data/${sampleid}_1.fastq.gz data/${sampleid}_2.fastq.gz > log/cutadapt/${sampleid}.log
    echo
    echo "Running STAR index..."
    STAR --runThreadN 4 --runMode genomeGenerate --genomeDir res/genome/star_index/ --genomeFastaFiles res/genome/ecoli.fasta --genomeSAindexNbases 9
    echo
    echo "Running STAR alignment..."
    mkdir -p out/star/${sampleid}
    STAR --runThreadN 4 --genomeDir res/genome/star_index/ --readFilesIn out/cutadapt/${sampleid}_1.trimmed.fastq.gz out/cutadapt/${sampleid}_2.trimmed.fastq.gz --readFilesCommand zcat --outFileNamePrefix out/star/${sampleid}/
    echo
else
    echo "Usage: $0 <sampleid>"
    exit 1
fi
