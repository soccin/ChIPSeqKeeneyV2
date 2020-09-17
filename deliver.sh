#!/bin/bash

ODIR=$1

mkdir $ODIR/alignment
mkdir $ODIR/coverage
mkdir $ODIR/metrics

cp *_sample_mapping.txt $ODIR

rsync -rvP out___/*___MD.ba? $ODIR/alignment
rsync -rvP out___/*COV.txt $ODIR/coverage
rsync -rvP out___/*___AS.txt $ODIR/metrics
rsync -rvP out___/*___MD.txt $ODIR/metrics
rsync -rvP out___/*___INS.txt $ODIR/metrics
