#!/bin/bash

#SBATCH -a 1-70:1
#SBATCH --mem-per-cpu=4G
#SBATCH -o out/out_temp/%x_%j_%a.out

a=$SLURM_ARRAY_TASK_ID
N=$(awk '$1=="N"{print $2}' paramList)

if [ $N -lt $a ]; then
        rm out/out_temp/*_$a.out
        exit 0
fi

date=$(awk '$1=="date"{print $2}' paramList)
clusters=($(ls meta_${date}/))
cluster=${clusters[$((a-1))]}

mkdir -p out/meta_${date}/LDSC_LDscoreRegression

cd meta_${date}/${cluster}/

mkdir -p LDSC_result

module load bioconda/
source activate ldsc

/share1/home/BirThree/hisashi.ohseto.ae/program/ldsc/ldsc.py \
	--h2 LDSC_data/chrAll_reformatted.sumstats.gz \
	--ref-ld-chr /home/BirThree/share/downloadedData/eas_ldscores/ \
	--w-ld-chr /home/BirThree/share/downloadedData/eas_ldscores/ \
	--out LDSC_result/LDscoreRegression 

cd ../../
mv out/out_temp/*_$SLURM_ARRAY_TASK_ID.out out/meta_${date}/LDSC_LDscoreRegression/$cluster

exit 0
