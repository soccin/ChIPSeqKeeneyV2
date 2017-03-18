#!/usr/bin/env python2.7

import sys

MAX_INSERT_SIZE=10000

for line in sys.stdin:
    (chrom1,start1,end1,
	 chrom2,start2,end2,queryname,
	 mapq,strand1,strand2)=line.strip().split()

    if chrom1==chrom2 and chrom1!="." \
		and strand1!=strand2 \
    	and int(end2)-int(start1)<MAX_INSERT_SIZE:
		    print "\t".join([chrom1, start1, end2])
