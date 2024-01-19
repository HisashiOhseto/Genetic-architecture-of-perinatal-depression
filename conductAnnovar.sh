#!/bin/bash

#SBATCH -a 1-70:1
#SBATCH --mem-per-cpu=20G
#SBATCH -o out/out_temp/%j.out

j=$SLURM_JOBID
a=$SLURM_ARRAY_TASK_ID
b=1
N=$(awk '$1=="N"{print $2}' paramList)

if [ $N -lt $a ]; then          
        rm out/out_temp/$j.out
        exit 0
fi

date=$(awk '$1=="date"{print $2}' paramList)
clusters=($(ls meta_${date}/))
cluster=${clusters[$((a-1))]}

mkdir -p out/meta_${date}/conductAnnovar

export PATH="$PATH:/home/BirThree/hisashi.ohseto.ae/program/annovar"

annotate_variation.pl \
	-out meta_${date}/$cluster/annovar/annotation \
	-build hg19 meta_${date}/$cluster/annovar/afterClumping.tsv /home/BirThree/hisashi.ohseto.ae/program/annovar/humandb/

mv out/out_temp/$j.out out/meta_${date}/conductAnnovar/$cluster.out

exit 0
