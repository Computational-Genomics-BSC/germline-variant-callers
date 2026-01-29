#!/bin/bash
# Check if the number of arguments is correct
if [ $# -ne 8 ]; then
    echo "ERROR: Wrong number of arguments"
    echo "USAGE: script.sh WORKING_DIR OUTPUT_DIR EXTRA_DATA_DIR REF_VERSION NORMAL_SAMPLE FASTA_REF NUM_CORES MAX_MEMORY"
    exit 1
fi
WORKING_DIR=$1
OUTPUT_DIR=$2
EXTRA_DATA_DIR=$3  # Not used in this script
REF_VERSION=$4  # Not used in this script
NORMAL_SAMPLE=$5
FASTA_REF=$6
NUM_CORES=$7  # Not used in this script
MAX_MEMORY=$8

mkdir $WORKING_DIR/ngsepcore_5_0_1

JAVA_OPTS="-Xmx"$MAX_MEMORY"G"

java $JAVA_OPTS -jar /app/NGSEPcore_5.0.1.jar SingleSampleVariantsDetector -i $NORMAL_SAMPLE -r $FASTA_REF -o $WORKING_DIR/ngsepcore_5_0_1/ngsepcore_5_0_1 -runRP

cp $WORKING_DIR/ngsepcore_5_0_1/ngsepcore_5_0_1.vcf $OUTPUT_DIR/ngsepcore_5_0_1.vcf

# If the output file does not exist or empty, exit with 1
if [ ! -s $OUTPUT_DIR/ngsepcore_5_0_1.vcf ]; then
    echo "ERROR: $OUTPUT_DIR/ngsepcore_5_0_1.vcf is empty"
    exit 1
fi
