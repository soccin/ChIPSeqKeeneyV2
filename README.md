# ChIPSeqKeeneyV2
ChIP-seq pipeline for Keeney Lab (Version 2; LUNA)

Pipeline steps:

* Reads trimmed with cutadapt
* Mapped with BWA MEM
* Sort by Queryname with PICARD
* Compute coverage using a custom script of bedtools and custom python code
