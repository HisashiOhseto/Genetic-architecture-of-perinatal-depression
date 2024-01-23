#GCTA
gcta64	--pfile your_pfile \
	--grm-sparse your_sp_grm \
	--keep keep.tsv \
	--pheno pheno.tsv \
	--qcovar qcovar.tsv \
	--extract info0.4_maf0.01.snplist \
	--out your_GWAS_model \
	--fastGWA-mlm-binary \
	--model-only \
	--seed 1 \
	--threads 4 \
	--nofilter

gcta64	--pfile your_pfile \
		--load-model your_GWAS_model.fastGWA \
		--extract info0.4_maf0.01.snplist \
		--out your_GWAS_result \
		--seed 1 \
		--threads 4 \
		--nofilter \

#PRSice
Rscript your_PRSice_directory/PRSice.R \
	--dir your_PRSice_directory \
	--prsice your_PRSice_directory/PRSice_linux \
	--base your_GWAS_result \
	--target your_bed_file \
	--pheno pheno.tsv \
	--out your_clumping_result \
	--extract info0.4_maf0.01.snplist \
	--thread max \
	--chr-id T \
	--clump-p 1e-4 \
	--clump-r2 0.1 \
	--clump-kb 3000 \
	--snp SNP \
	--chr-id c:l_a_b \
	--print-snp \
	--keep-ambig

#Annovar
annotate_variation.pl \
	-out your_annotation \
	-build hg19 your_clumping_result your_annovar_directory


#METAL
marker SNP 
allele A1 A2 
effect BETA
pvalue P 
weight N 
STDERR SE
process Jpav2_result
process Jpav3_result

outfile metal_result.tbl
analyze
quit

#LDSC
list=("Dep" "pregnancyDep" "earlyPostDep" "latePostDep" "chronicDep")
ldsc/munge_sumstats.py \
	--sumstats your_GWAS_result_${list[i]} \
	--snp ID \
	--out your_reformatted_GWAS_result_${list[i]} \
	--merge-alleles w_hm3.snplist

ldsc/ldsc.py \
	--h2 your_reformatted_GWAS_result_${list[i]}.sumstats.gz \
	--ref-ld-chr eas_ldscores/ \
	--w-ld-chr eas_ldscores/ \
	--out ${list[i]} 

list=("Dep" "pregnancyDep" "earlyPostDep" "latePostDep" "chronicDep")
for (( i=0; i<${#list[@]}; i++ )); do
	for (( j=i+1; j<${#list[@]}; j++ )); do
		ldsc/ldsc.py \
			--rg your_reformatted_GWAS_result_${list[i]}.sumstats.gz,your_reformatted_GWAS_result_${list[j]}.sumstats.gz \
			--ref-ld-chr eas_ldscores/ \
			--w-ld-chr eas_ldscores/ \
			--out ${list[i]}_${list[j]}
	done
done

#FOCUS
focus munge \
	your_GWAS_result_${list[i]} \
	--output your_cleaned_GWAS_result_${list[i]}


focus finemap \
	your_cleaned_GWAS_result_${list[i]} \
	your_bed_file \
	focus.db \
	--prior-prob gencode37 \
	--location 37:EUR-EAS \
	--p-threshold 1e-6 \
	--out your_focus_result
