#!/bin/bash
# Check if the number of arguments is correct
if [ $# -ne 8 ]; then
    echo "ERROR: Wrong number of arguments"
    echo "USAGE: script.sh WORKING_DIR OUTPUT_DIR EXTRA_DATA_DIR REF_VERSION NORMAL_SAMPLE FASTA_REF NUM_CORES MAX_MEMORY"
    exit 1
fi
WORKING_DIR=$1
OUTPUT_DIR=$2
EXTRA_DATA_DIR=$3
REF_VERSION=$4
NORMAL_SAMPLE=$5
FASTA_REF=$6
NUM_CORES=$7
MAX_MEMORY=$8

mkdir $WORKING_DIR/delly_1_1_6

if [ -s  $WORKING_DIR/delly_1_1_6/delly_1_1_6_DEL.bcf.csi ]; then
    echo Skipping DEL
else
    echo Running DELLY on DEL
    delly call -x $EXTRA_DATA_DIR/delly/$REF_VERSION/human.excl.tsv -o $WORKING_DIR/delly_1_1_6/delly_1_1_6_DEL.bcf -t DEL -g $FASTA_REF $NORMAL_SAMPLE &
fi
if [ -s  $WORKING_DIR/delly_1_1_6/delly_1_1_6_DUP.bcf.csi ]; then
    echo Skipping DUP
else
    echo Running DELLY on DUP
    delly call -x $EXTRA_DATA_DIR/delly/$REF_VERSION/human.excl.tsv -o $WORKING_DIR/delly_1_1_6/delly_1_1_6_DUP.bcf -t DUP -g $FASTA_REF $NORMAL_SAMPLE &
fi
if [ -s  $WORKING_DIR/delly_1_1_6/delly_1_1_6_INV.bcf.csi ]; then
    echo Skipping INV
else
    echo Running DELLY on INV
    delly call -x $EXTRA_DATA_DIR/delly/$REF_VERSION/human.excl.tsv -o $WORKING_DIR/delly_1_1_6/delly_1_1_6_INV.bcf -t INV -g $FASTA_REF $NORMAL_SAMPLE &
fi
if [ -s  $WORKING_DIR/delly_1_1_6/delly_1_1_6_BND.bcf.csi ]; then
    echo Skipping BND
else
    echo Running DELLY on BND
    delly call -x $EXTRA_DATA_DIR/delly/$REF_VERSION/human.excl.tsv -o $WORKING_DIR/delly_1_1_6/delly_1_1_6_BND.bcf -t BND -g $FASTA_REF $NORMAL_SAMPLE &
fi
if [ -s  $WORKING_DIR/delly_1_1_6/delly_1_1_6_INS.bcf.csi ]; then
    echo Skipping INS
else
    echo Running DELLY on INS
    delly call -x $EXTRA_DATA_DIR/delly/$REF_VERSION/human.excl.tsv -o $WORKING_DIR/delly_1_1_6/delly_1_1_6_INS.bcf -t INS -g $FASTA_REF $NORMAL_SAMPLE &
fi
wait

bcftools concat $WORKING_DIR/delly_1_1_6/delly_1_1_6_DEL.bcf $WORKING_DIR/delly_1_1_6/delly_1_1_6_INS.bcf $WORKING_DIR/delly_1_1_6/delly_1_1_6_DUP.bcf $WORKING_DIR/delly_1_1_6/delly_1_1_6_INV.bcf $WORKING_DIR/delly_1_1_6/delly_1_1_6_BND.bcf --threads $NUM_CORES -a -O b -o $WORKING_DIR/delly_1_1_6/delly_1_1_6_unfiltered.bcf
bcftools index $WORKING_DIR/delly_1_1_6/delly_1_1_6_unfiltered.bcf

cp $WORKING_DIR/delly_1_1_6/delly_1_1_6_unfiltered.bcf $OUTPUT_DIR/delly_1_1_6.bcf

# If the output file does not exist or empty, exit with 1
if [ ! -s $OUTPUT_DIR/delly_1_1_6.bcf ]; then
    echo "ERROR: $OUTPUT_DIR/delly_1_1_6.bcf is empty"
    exit 1
fi
