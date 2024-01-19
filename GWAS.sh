#!/bin/bash

#SBATCH -a 1-1540:1
#SBATCH -c 4
#SBATCH -o out/out_temp/%j.out

j=$SLURM_JOBID
a=$(($((SLURM_ARRAY_TASK_ID-1))%70))
b=$(($((SLURM_ARRAY_TASK_ID-a-1))/70+1))

N=$(awk '$1=="N"{print $2}' paramList)

if [ $N -lt $((a+1)) ]; then
        rm out/out_temp/$j.out
        exit 0
fi

date=$(awk '$1=="date"{print $2}' paramList)
Jpav=$(awk '$1=="Jpav"{print $2}' paramList)
clusters=($(ls GWAS_${Jpav}_${date}))
cluster=${clusters[$a]}

echo "task id = $SLURM_ARRAY_TASK_ID"
echo "a = $a"
echo "b = $b"

mkdir -p GWAS_${Jpav}_${date}/$cluster/eachChr
mkdir -p GWAS_${Jpav}_${date}/$cluster/eachChr/chr$b
mkdir -p out/GWAS_${Jpav}_${date}/GWAS
mkdir -p out/GWAS_${Jpav}_${date}/GWAS/$cluster

module load gcta/

err=1
i=0

while [ $err -eq 1 -a $i -le 10 ]
do

	i=$((i+1))
	echo $i
	gcta64	--pfile /home/BirThree/share/ToMMoData/bgenpgen/${Jpav}/pgen/chr$b \
		--load-model GWAS_${Jpav}_${date}/$cluster/GWAS_model/GWAS_model.fastGWA \
		--extract /share1/home/BirThree/share/ToMMoData/extractSNP/${Jpav}/result_info0.4_maf0.01/chr$b.snplist \
		--out GWAS_${Jpav}_${date}/$cluster/eachChr/chr$b/result \
		--seed 1 \
		--threads 4 \
		--nofilter \ 
	if [ $? -eq 0 ] ; then
		err=0
	fi
done

mv out/out_temp/$j.out out/GWAS_${Jpav}_${date}/GWAS/$cluster/chr$b.out

exit 0
