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

mkdir $WORKING_DIR/gatk_4_2_6_1

JAVA_OPTS="-Xmx"$MAX_MEMORY"G"
# Run in parallel
cut -f1 $FASTA_REF.fai | xargs -n 1 -P $NUM_CORES -I {} gatk --java-options ${JAVA_OPTS} HaplotypeCaller -L {} -R $FASTA_REF -I $NORMAL_SAMPLE -O $WORKING_DIR/gatk_4_2_6_1/{}.germline.vcf.gz

# Every contig in the reference must have a non-empty vcf file
for contig in $(cut -f1 $FASTA_REF.fai); do
  if [ ! -s $WORKING_DIR/gatk_4_2_6_1/$contig.germline.vcf.gz ]; then
    echo "ERROR: $contig.germline.vcf.gz is empty"
    exit 1
  fi
done

ls $WORKING_DIR/gatk_4_2_6_1/*.germline.vcf.gz | head -c -1 > $WORKING_DIR/gatk_4_2_6_1/vcf.list

gatk MergeVcfs -I $WORKING_DIR/gatk_4_2_6_1/vcf.list -O $WORKING_DIR/gatk_4_2_6_1/merged.vcf.gz

if gzip -t $WORKING_DIR/gatk_4_2_6_1/merged.vcf.gz; then
  echo "SUCCESS"
else
  echo "ERROR: merged.vcf.gz is not a valid gzip file"
  exit 1
fi

cp $WORKING_DIR/gatk_4_2_6_1/merged.vcf.gz $OUTPUT_DIR/gatk_4_2_6_1.vcf.gz

# If the output file does not exist or empty, exit with 1
if [ ! -s $OUTPUT_DIR/gatk_4_2_6_1.vcf.gz ]; then
    echo "ERROR: $OUTPUT_DIR/gatk_4_2_6_1.vcf.gz is empty"
    exit 1
fi
