#!/bin/bash

#SBATCH -a 1-70:1
#SBATCH -c 1 --mem-per-cpu=20G
#SBATCH -o out/out_temp/%j.out

a=$SLURM_ARRAY_TASK_ID
j=$SLURM_JOBID
N=$(awk '$1=="N"{print $2}' paramList)

if [ $N -lt $a ]; then
	rm out/out_temp/$j.out
	exit 0
fi

date=$(awk '$1=="date"{print $2}' paramList)
clusters=($(ls GWAS_Jpav2_${date}/))
cluster=${clusters[$((a-1))]}

mkdir -p meta_${date}
mkdir -p meta_${date}/$cluster
mkdir -p out/meta_${date}/metal


module load metal/
metal <<EOF 
SCHEME STDERR

marker SNP 
allele A1 A2 
effect BETA
pvalue P 
weight N 
STDERR SE
process GWAS_Jpav2_${date}/$cluster/chrAll
process GWAS_Jpav3_${date}/$cluster/chrAll


outfile meta_${date}/${cluster}/metal2_ .tbl
analyze

quit
EOF

mv out/out_temp/$j.out out/meta_${date}/metal/$cluster.out

exit 0
