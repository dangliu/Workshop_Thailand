#!/bin/bash

input1=$1 #info file
input2=$2 #plink file prefix

for p in $(cut -f3 $input1 | grep -v Pop | sort -u)
do
	echo "Working on $p"
	awk -v var="$p" '$3==var' $input1 > tmp.info
	plink --bfile $input2 --allow-no-sex --keep tmp.info --make-bed --out tmp
	plink --bfile tmp --hardy --out tmp
	awk '$3=="ALL" || $3 == "ALL(NP)"' tmp.hwe | awk '$9 < 1' | awk -v var=$p '{print var"\t"$0}' >> $input2.within.hwe
	#awk -v var=$p '{print var"\t"$0}' tmp.hwe >> $input2.within.hwe
done

#cat $input2.within.$input3.hwe | awk '{print $2}' | sort -u > $input2.within.$input3.hwe.snp

rm tmp* 