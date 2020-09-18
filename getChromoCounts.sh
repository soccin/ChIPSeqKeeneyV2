#!/bin/bash
SDIR="$( cd "$( dirname "$0" )" && pwd )"

MAX_INSERT_SIZE=$1
BAM=$2

module load bedtools

#
# -f2 Proper Pairing Flag
# -F2048 !secondary alignments

samtools view -f2 -F2048 -b ${BAM} \
    | bedtools bamtobed -bedpe -i - \
    | $SDIR/pebed2fragbed.py $MAX_INSERT_SIZE | bedtools sort -i - \
    | cut -f1 \
    | sort -V \
    | uniq -c \
    | awk 'BEGIN{print "Contig\tCount"}{print $2"\t"$1}' \
    > ${BAM/.bam/___Count.txt}

