#!/bin/bash

ODIR=$1

if [ $# != "1" ]; then
    echo
    echo "    "usage: delivery.sh /ifs/res/seq/pi/invest/Proj_NNNNN/r_000
    echo
    exit
fi

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

rsync -rvP --size-only out___/*___MD.ba? $ODIR/alignment
rsync -rvP --size-only out___/*COV.txt $ODIR/coverage
rsync -rvP --size-only out___/*___AS.txt $ODIR/metrics
rsync -rvP --size-only out___/*___MD.txt $ODIR/metrics
rsync -rvP --size-only out___/*___INS.txt $ODIR/metrics

LAB=$(echo $ODIR | cut -d/ -f5)
INVEST=$(echo $ODIR | cut -d/ -f6)
PROJNO=$(echo $ODIR | cut -d/ -f7)
SAMBAPATH=$(echo $ODIR | cut -d/ -f6- | perl -pe 's|/$||')

cat <<EOF
=================================================

The output for ChIPSeq Project $PROJNO is now ready and is
available on the BIC server at:

    PC link: \\\\beta.mskcc.org\\$LAB
    MAC link: smb://beta.mskcc.org/$LAB

in the folder:

    /DELIVERY/$SAMBAPATH

If you have any questions let me know.

Nicholas Socci
Bioinformatics Core
MSKCC
soccin@mskcc.org

=======
EOF
