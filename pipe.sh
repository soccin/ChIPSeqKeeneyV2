#!/bin/bash
SDIR="$( cd "$( dirname "$0" )" && pwd )"

if [ "$#" -lt "3" ]; then
    echo "usage: ./ChIPSeqKeeneyV2/pipe.sh GENOME SAMPLE_NAME FASTQ_DIR"
    exit
fi

GENOME=$1
SAMPLE=$2
shift 2

if [ ! -e $SDIR/PEMapper/bin/lsf.sh ]; then
    echo
    echo "   Remember to do submodule to get PEMapper submod"
    echo "      git clone --recurse-submodules gitURL"
    exit
fi

source $SDIR/PEMapper/bin/lsf.sh

module load bedtools

TDIR=$(pwd)/_scratch/chipV2/$(uuidgen -t)
mkdir -p $TDIR

if [ -e $SDIR/genomes/$GENOME ]; then
    source $SDIR/genomes/$GENOME
else
    if [ -e $GENOME ]; then
        source $GENOME
    else
        echo
        echo GENOME=$GENOME Not Defined
        echo "Currently available (builtin) genomes"
        ls -1 $SDIR/genomes
        echo
        exit
    fi
fi

TAG=csTAG_$(uuidgen -t)

$SDIR/PEMapper/pipe.sh -s $SAMPLE $GENOME $* >$TDIR/pemapper_${SAMPLE}.log


#
# Get final TAG from PEMapper run to hold on
#
sleep 2
PETAG=$(egrep "^QTAG=" $TDIR/pemapper_${SAMPLE}.log | tail -1 | sed 's/.*=//')
echo PETAG=$PETAG

QRUN 2 ${TAG}___SRTQN___${SAMPLE} HOLD $PETAG VMEM 36 \
    picardV2 SortSam SO=queryname \
        I=out___/${SAMPLE}___MD.bam \
        O=out___/${SAMPLE}___MD,SrtQN.bam

#
# Set insert size
#

MAX_INSERT_SIZE=250

QRUN 4 ${TAG}___COV___${SAMPLE} HOLD ${TAG}___SRTQN___${SAMPLE} VMEM 16 \
    $SDIR/getCoverage.sh $MAX_INSERT_SIZE out___/${SAMPLE}___MD,SrtQN.bam ${GENOME_FASTA/.fa/.genome}
