#!/bin/bash

#SBATCH --mem-per-cpu=4G
#SBATCH -o out/out_temp/%x_%j.out

date=$(awk '$1=="date"{print $2}' paramList)

mkdir -p out/meta_${date}/LDSC_geneticCorrelation

mkdir -p LDSC_geneticCorrelation_$date

module load bioconda/
source activate ldsc

list=("Dep" "pregnancyDep" "earlyPostDep" "latePostDep" "chronicDep")

for (( i=0; i<${#list[@]}; i++ )); do
	for (( j=i+1; j<${#list[@]}; j++ )); do
		/share1/home/BirThree/hisashi.ohseto.ae/program/ldsc/ldsc.py \
			--rg meta_$date/pheno_${list[i]}/LDSC_data/chrAll_reformatted.sumstats.gz,meta_$date/pheno_${list[j]}/LDSC_data/chrAll_reformatted.sumstats.gz \
			--ref-ld-chr /home/BirThree/share/downloadedData/eas_ldscores/ \
			--w-ld-chr /home/BirThree/share/downloadedData/eas_ldscores/ \
			--out LDSC_geneticCorrelation_$date/${list[i]}_${list[j]}
	done
done

exit 0
