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


rm -rf $WORKING_DIR/manta_1_6_0
mkdir $WORKING_DIR/manta_1_6_0

/manta-1.6.0.centos6_x86_64/bin/configManta.py --normalBam=$NORMAL_SAMPLE --referenceFasta=$FASTA_REF --runDir=$WORKING_DIR/manta_1_6_0
$WORKING_DIR/manta_1_6_0/runWorkflow.py -j $NUM_CORES

cp $WORKING_DIR/manta_1_6_0/results/variants/diploidSV.vcf.gz $OUTPUT_DIR/manta_1_6_0.vcf.gz

# If the output file does not exist or empty, exit with 1
if [ ! -s $OUTPUT_DIR/manta_1_6_0.vcf.gz ]; then
    echo "ERROR: $OUTPUT_DIR/manta_1_6_0.vcf.gz is empty"
    exit 1
fi
