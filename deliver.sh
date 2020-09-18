#!/bin/bash

ODIR=$1

SPECIESCOUNTS=$(ls | egrep "__SpeciesCounts.xlsx$")

mkdir -p $ODIR/alignment
mkdir -p $ODIR/coverage
mkdir -p $ODIR/metrics

if [ "$SPECIESCOUNTS" != "" ]; then
    cp $SPECIESCOUNTS $ODIR/metrics
fi

MAPPINGFILE=$(find . | egrep "_sample_mapping.txt$")
if [ "$MAPPINGFILE" != "" ]; then
    cp *_sample_mapping.txt $ODIR
fi

rsync -rvP out___/*___MD.ba? $ODIR/alignment
rsync -rvP out___/*COV.txt $ODIR/coverage
rsync -rvP out___/*___AS.txt $ODIR/metrics
rsync -rvP out___/*___MD.txt $ODIR/metrics
rsync -rvP out___/*___INS.txt $ODIR/metrics

LAB=$(echo $ODIR | cut -d/ -f5)
INVEST=$(echo $ODIR | cut -d/ -f6)
PROJNO=$(echo $ODIR | cut -d/ -f7)
SAMBAPATH=$(echo $ODIR | cut -d/ -f6- | perl -pe 's|/$||')

cat <<EOF
=================================================

The output for ChIPSeq Project $PROJNO is now ready and is
available on the BIC server at:

    PC link: \\\\bic.mskcc.org\\$LAB
    MAC link: smb://bic.cbio.mskcc.org/$LAB

in the folder:

    /RESULTS/$SAMBAPATH

If you have any questions let me know.

Nicholas Socci
Bioinformatics Core
MSKCC
soccin@mskcc.org

=======
EOF
