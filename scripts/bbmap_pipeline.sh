#!/usr/bin/env bash

# $1 mate1
# $2 mate2
# $3 subsample size in Mb
# $4 output

source activate three;

x=`head -n 2 $1 | tail -n 1 | wc -c`
n=$(python -c "print(int($3/(2*$x) * 1000000))")


out_1=`mktemp -t "XXXXXX.fq"`
out_2=`mktemp -t "XXXXXX.fq"`

#seqtk sample -s150 $1 $n > ${out_1}
#seqtk sample -s150 $2 $n > ${out_2}

cat $1 > ${out_1}
cat $2 > ${out_2}

out1=`mktemp -t "XXXXXX_1.fq"`
out2=`mktemp -t "XXXXXX_2.fq"`
~/bbmap/bbduk.sh in1=${out_1} in2=${out_2} out1=$out1 out2=$out2 ref=adapters,phix ktrim=r k=23 mink=11 hdist=1 tpe tbo overwrite=true

rm ${out_1} ${out_2}

out3=`mktemp -t "XXXXXX_3.fq"`
~/bbmap/dedupe.sh in1=$out1 in2=$out2 out=$out3 overwrite=true

rm $out1 $out2

out4=`mktemp -t "XXXXXX_4.fq"`
out5=`mktemp -t "XXXXXX_5.fq"`
~/bbmap/reformat.sh in=$out3 out1=$out4 out2=$out5 overwrite=true

rm $out3


~/bbmap/bbmerge.sh in1=$out4 in2=$out5 out1=$4 overwrite=true mix=t


rm  $out4 $out5 
