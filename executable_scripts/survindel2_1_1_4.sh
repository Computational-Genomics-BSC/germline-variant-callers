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

mkdir $WORKING_DIR/survindel2_1_1_4

python /home/survindel2.py \
    --threads $NUM_CORES \
    $NORMAL_SAMPLE \
    $WORKING_DIR/survindel2_1_1_4 \
    $FASTA_REF

cp $WORKING_DIR/survindel2_1_1_4/out.pass.vcf.gz $OUTPUT_DIR/survindel2_1_1_4.vcf.gz

# If the output file does not exist or empty, exit with 1
if [ ! -s $OUTPUT_DIR/survindel2_1_1_4.vcf.gz ]; then
    echo "ERROR: $OUTPUT_DIR/survindel2_1_1_4.vcf.gz is empty"
    exit 1
fi
