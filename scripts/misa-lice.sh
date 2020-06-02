#! /usr/bin/env bash

# $1 backbone tree
# $2 instance dir
# $3 true tree

source activate three
export OMP_NUM_THREADS=1
python3 ~/misa/run_misa.py -t $1 -d $2/../dist.mat -o $2/misa.jplace -m OLS -l SIMPJAC -T 0 > $2/log.out 2> $2/log.err

guppy tog -o $2/misa.nwk $2/misa.jplace
~/misa/scripts/measure_RF.sh $2/misa.nwk $2/../things.txt $3 | sort -n > $2/results_MISA.csv
