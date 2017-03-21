#!/bin/bash
SDIR="$( cd "$( dirname "$0" )" && pwd )"

MAX_INSERT_SIZE=$1
BAM=$2
GENOME_BEDTOOLS=$3

#
# -f2 Proper Pairing Flag
#

samtools view -f2 -b ${BAM} \
    | bedtools bamtobed -bedpe -i - \
    | $SDIR/pebed2fragbed.py $MAX_INSERT_SIZE | bedtools sort -i - \
    | bedtools genomecov  -i - -g $GENOME_BEDTOOLS -d \
    > ${BAM/.bam/___COV.txt}

