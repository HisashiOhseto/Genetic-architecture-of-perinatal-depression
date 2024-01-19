#!/bin/bash

#SBATCH -a 1-70:1
#SBATCH -c 10
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

mkdir -p out/meta_${date}/FOCUS_fineMapping

module load python3.9/
cd /home/BirThree/hisashi.ohseto.ae/program/focus
source env/bin/activate

for i in {1..22}
do
	focus finemap \
		/share1/home/BirThree/hisashi.ohseto.ae/Genome/GWAS_PerinatalDepression/meta_$date/$cluster/FOCUS/cleaned.tsv.sumstats.gz \
		/home/BirThree/share/ToMMoData/bed/Jpav3/bed_rsID/chr$i \
		/home/BirThree/hisashi.ohseto.ae/program/focus/focus.db \
		--chr $i \
		--prior-prob gencode37 \
		--location 37:EUR-EAS \
		--p-threshold 1e-6 \
		--out /share1/home/BirThree/hisashi.ohseto.ae/Genome/GWAS_PerinatalDepression/meta_$date/$cluster/FOCUS/finemap_chr$i
done

cd /share1/home/BirThree/hisashi.ohseto.ae/Genome/GWAS_PerinatalDepression/
mv out/out_temp/*_$SLURM_ARRAY_TASK_ID.out out/meta_${date}/FOCUS_fineMapping/$cluster

exit 0
