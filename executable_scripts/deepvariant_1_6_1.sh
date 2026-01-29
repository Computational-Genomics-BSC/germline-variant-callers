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

mkdir $WORKING_DIR/deepvariant_1_6_1

/opt/deepvariant/bin/run_deepvariant \
    --model_type=WGS \
    --ref=$FASTA_REF \
    --reads=$NORMAL_SAMPLE \
    --output_vcf=$WORKING_DIR/deepvariant_1_6_1/deepvariant_1_6_1.vcf \
    --num_shards=$NUM_CORES \
    --haploid_contigs="X,Y" \
    --intermediate_results_dir=$WORKING_DIR/deepvariant_1_6_1/tmp \
    --logging_dir=$WORKING_DIR/deepvariant_1_6_1/logs \
    --par_regions_bed=$EXTRA_DATA_DIR/deepvariant/$REF_VERSION/PAR.bed

cp $WORKING_DIR/deepvariant_1_6_1/deepvariant_1_6_1.vcf $OUTPUT_DIR/deepvariant_1_6_1.vcf

# If the output file does not exist or empty, exit with 1
if [ ! -s $OUTPUT_DIR/deepvariant_1_6_1.vcf ]; then
    echo "ERROR: $OUTPUT_DIR/deepvariant_1_6_1.vcf is empty"
    exit 1
fi
