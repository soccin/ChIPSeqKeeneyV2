#!/bin/bash
SDIR="$( cd "$( dirname "$0" )" && pwd )"

BAM=$1
GENOME_BEDTOOLS=$2

bedtools bamtobed -bedpe -i ${BAM} \
    | $SDIR/pebed2fragbed.py | bedtools sort -i - \
    | bedtools genomecov  -i - -g $GENOME_BEDTOOLS -d \
    > ${BAM/.bam/___COV.txt}

