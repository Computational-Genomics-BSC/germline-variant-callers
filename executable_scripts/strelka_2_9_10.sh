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

rm -rf $WORKING_DIR/strelka_2_9_10
mkdir $WORKING_DIR/strelka_2_9_10

/strelka-2.9.10.centos6_x86_64/bin/configureStrelkaGermlineWorkflow.py --bam=$NORMAL_SAMPLE --referenceFasta=$FASTA_REF --runDir=$WORKING_DIR/strelka_2_9_10
$WORKING_DIR/strelka_2_9_10/runWorkflow.py -m local -j $NUM_CORES
cp $WORKING_DIR/strelka_2_9_10/results/variants/variants.vcf.gz $OUTPUT_DIR/strelka_2_9_10.vcf.gz


# If the output file does not exist or empty, exit with 1
if [ ! -s $OUTPUT_DIR/strelka_2_9_10.vcf.gz ]; then
    echo "ERROR: $OUTPUT_DIR/strelka_2_9_10.vcf.gz is empty"
    exit 1
fi
