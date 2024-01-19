#!/bin/bash

#SBATCH -a 1-70:1
#SBATCH -c 4
#SBATCH -o out/out_temp/%j.out

a=$SLURM_ARRAY_TASK_ID
j=$SLURM_JOBID
b=1
N=$(awk '$1=="N"{print $2}' paramList)

if [ $N -lt $a ]; then
	rm out/out_temp/$j.out
	exit 0
fi

date=$(awk '$1=="date"{print $2}' paramList)
Jpav=$(awk '$1=="Jpav"{print $2}' paramList)
clusters=($(ls GWAS_${Jpav}_${date}/))
cluster=${clusters[$((a-1))]}

mkdir -p out/GWAS_${Jpav}_${date}/GWAS_model
mkdir -p GWAS_${Jpav}_${date}/$cluster/GWAS_model

module load gcta/

gcta64	--pfile /home/BirThree/share/ToMMoData/bgenpgen/${Jpav}/pgen/chr$b \
	--grm-sparse /share1/home/BirThree/share/ToMMoData/GRM/${Jpav}/result_sparseGRM_modifiedFID/sp_grm \
	--keep GWAS_${Jpav}_${date}/$cluster/dataset/keep.tsv \
	--pheno GWAS_${Jpav}_${date}/$cluster/dataset/pheno.tsv \
	--qcovar GWAS_${Jpav}_${date}/$cluster/dataset/qcovar.tsv \
	--extract /share1/home/BirThree/share/ToMMoData/extractSNP/${Jpav}/result_info0.4_maf0.01/chr$b.snplist \
	--out GWAS_${Jpav}_${date}/$cluster/GWAS_model/GWAS_model \
	--fastGWA-mlm-binary \
	--model-only \
	--seed 1 \
	--threads 4 \
	--nofilter \ 
	
mv out/out_temp/$j.out out/GWAS_${Jpav}_${date}/GWAS_model/$cluster.out

exit 0
