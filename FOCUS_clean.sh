#!/bin/bash

#SBATCH -a 1-70:1
#SBATCH --mem-per-cpu=10G
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

mkdir -p out/meta_${date}/FOCUS_clean

module load bioconda/
cd /home/BirThree/hisashi.ohseto.ae/program/focus
source env/bin/activate
focus munge /share1/home/BirThree/hisashi.ohseto.ae/Genome/GWAS_PerinatalDepression/meta_$date/$cluster/FOCUS/metal_revised.tsv --output /share1/home/BirThree/hisashi.ohseto.ae/Genome/GWAS_PerinatalDepression/meta_$date/$cluster/FOCUS/cleaned.tsv

mv out/out_temp/*_$SLURM_ARRAY_TASK_ID.out out/meta_${date}/FOCUS_clean/$cluster

exit 0
