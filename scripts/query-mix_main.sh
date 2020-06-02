#!/usr/bin/env bash

#$1 things file directory

source activate three

if ls $1/dist* 1> /dev/null 2>&1; then

    echo "dist exists"
    exit

else
	cd $1
	mrg=`mktemp -t "XXXXXX.fastq"`
	#cat $i/queries/$j/$k/things.txt | paste -s -d ' ' | xargs cat  > \$mrg; \n
	while read cons; do
		cat /oasis/projects/nsf/uot138/balaban/mixture/processed/${cons}.fastq
	done < ./things.txt > $mrg
	python3 /home/balaban/Skmer/skmer/__main__.py query -m $mrg /oasis/tscc/scratch/balaban/mixture/lice/skmer-4000M/library
	rm $mrg
	~/misa/scripts/convert_to_tsv.sh `ls . | grep "dist-"` > dist.mat
fi
