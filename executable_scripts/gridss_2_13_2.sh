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

rm -rf $WORKING_DIR/gridss_2_13_2
mkdir $WORKING_DIR/gridss_2_13_2

set -e

JAVA_HEAP_SIZE=$MAX_MEMORY"G"

gridss -r $FASTA_REF \
  -o $WORKING_DIR/gridss_2_13_2/all.vcf --workingdir $WORKING_DIR/gridss_2_13_2 \
  -t $NUM_CORES \
  --jvmheap $JAVA_HEAP_SIZE \
  $NORMAL_SAMPLE

cp $WORKING_DIR/gridss_2_13_2/all.vcf $OUTPUT_DIR/gridss_2_13_2.vcf

# If the output file does not exist or empty, exit with 1
if [ ! -s $OUTPUT_DIR/gridss_2_13_2.vcf ]; then
    echo "ERROR: $OUTPUT_DIR/gridss_2_13_2.vcf is empty"
    exit 1
fi
