#!/bin/bash
SDIR="$( cd "$( dirname "$0" )" && pwd )"
GENOME=$1
SAMPLE=$2
shift 2

source $SDIR/PEMapper/bin/lsf.sh

TDIR=$(pwd)/_scratch/chipV2/$(uuidgen -t)
mkdir -p $TDIR

if [ -e $SDIR/lib/genomes/$GENOME ]; then
    source $SDIR/lib/genomes/$GENOME
else
    if [ -e $GENOME ]; then
        source $GENOME
    else
        echo
        echo GENOME=$GENOME Not Defined
        echo "Currently available (builtin) genomes"
        ls -1 $SDIR/lib/genomes
        echo
        exit
    fi
fi

TAG=csTAG_$(uuidgen -t)

$SDIR/PEMapper/pipe.sh -s $SAMPLE $GENOME $* >$TDIR/pemapper_${SAMPLE}.log
sleep 2
PETAG=$(egrep "^QTAG=.*__MD" $TDIR/pemapper_${SAMPLE}.log| sed 's/.*=//')
echo PETAG=$PETAG

QRUN 2 ${TAG}___SRTQN___${SAMPLE} HOLD $PETAG VMEM 36 \
    picard.local SortSam SO=queryname \
        I=out___/${SAMPLE}___MD.bam \
        O=out___/${SAMPLE}___MD,SrtQN.bam

QRUN 4 ${TAG}___COV___${SAMPLE} HOLD ${TAG}___SRTQN___${SAMPLE} \
    $SDIR/getCoverage.sh out___/${SAMPLE}___MD,SrtQN.bam ${GENOME_FASTA/.fa/.genome}