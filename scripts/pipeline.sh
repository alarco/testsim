#Pipeline para analizar muestras de RNAseq de E.coli.


for sample in $(ls data/*.fastq.gz|cut -d "_" -f1|sed 's:data/::' |sort|uniq)
do 
	bash scripts/analyse_sample.sh $sample
done
