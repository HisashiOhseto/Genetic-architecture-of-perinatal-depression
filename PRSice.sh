#!/bin/bash

#SBATCH -a 1-70:1
#SBATCH -c 20 --mem-per-cpu=1G
#SBATCH -o out/out_temp/%j.out

j=$SLURM_JOBID
a=$SLURM_ARRAY_TASK_ID
N=$(awk '$1=="N"{print $2}' paramList)

if [ $N -lt $a ]; then
	rm out/out_temp/$j.out
	exit 0
fi

date=$(awk '$1=="date"{print $2}' paramList)
Jpav=$(awk '$1=="Jpav"{print $2}' paramList)
clusters=($(ls GWAS_${Jpav}_${date}/))
cluster=${clusters[$((a-1))]}

mkdir -p out/GWAS_${Jpav}_${date}/PRSice
mkdir -p GWAS_${Jpav}_${date}/$cluster/clumping

module load R41-Rstudio-recommended/2022.02.1-461

Rscript /home/BirThree/hisashi.ohseto.ae/program/PRSice/2.3.5/PRSice.R \
	--dir /home/BirThree/hisashi.ohseto.ae/program/PRSice/2.3.5 \
	--prsice /home/BirThree/hisashi.ohseto.ae/program/PRSice/2.3.5/PRSice_linux \
	--base GWAS_${Jpav}_${date}/$cluster/chrAll \
	--target /home/BirThree/share/ToMMoData/bed/${Jpav}/bed/chr# \
	--pheno GWAS_${Jpav}_${date}/$cluster/dataset/pheno.tsv \
	--out GWAS_${Jpav}_${date}/$cluster/clumping/result \
	--extract /share1/home/BirThree/share/ToMMoData/extractSNP/${Jpav}/result_info0.4_maf0.01/chrAll.snplist \
	--thread max \
	--chr-id T \
	--clump-p 1e-4 \
	--clump-r2 0.1 \
	--clump-kb 3000 \
	--snp SNP \
	--chr-id c:l_a_b \
	--print-snp \
	--keep-ambig

mv out/out_temp/$j.out out/GWAS_${Jpav}_${date}/PRSice/$cluster.out

exit 0
