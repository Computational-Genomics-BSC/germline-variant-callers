# Computational Genomics - Germline variant callers<!-- omit in toc -->

CITATION: WIP

This repository contains the scripts to run germline variant callers. The variant callers are executed from Bash scripts that use Singularity containers. The scripts are located in the [`executable_scripts/`](executable_scripts/) folder of this repository. The containers references are available in the [variant callers list](#variant-callers-list) below.

The scripts for running the variant callers are Bash scripts that can be executed directly from the command line in almost any Unix-based system. The only dependency is Singularity ([`singularity-ce`](https://sylabs.io/singularity/) version +3.9.0). The scripts are optimized for running in HPC environments without root privileges.

## Table of Contents<!-- omit in toc -->
- [Variant callers list](#variant-callers-list)
- [Downloading the variant callers](#downloading-the-variant-callers)
- [Executing the variant callers](#executing-the-variant-callers)
  - [Parameters](#parameters)
  - [Extra data](#extra-data)
  - [Example of execution](#example-of-execution)


## Variant callers list

| Variant caller                                                                                                                   | Variant types | Version | Singularity containers                                                                                                                                 | License                                                                      | Notes |
| -------------------------------------------------------------------------------------------------------------------------------- | ------------- | ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------- | ----- |
| [DeepVariant](https://github.com/google/deepvariant)                                                                             | SNV/Indel     | 1.6.1   | [`bsc_cg_deepvariant:1.6.1`](https://ghcr.io/computational-genomics-bsc/bsc_cg_deepvariant:1.6.1)                                                      | [BSD-3](https://github.com/google/deepvariant/blob/r1.6.1/LICENSE)           |       |
| [HaplotypeCaller (from GATK)](https://gatk.broadinstitute.org/hc/en-us/articles/360037593851-Mutect2)                            | SNV/Indel     | 4.2.6.1 | [`bsc_cg_gatk:4.2.6.1`](https://ghcr.io/computational-genomics-bsc/bsc_cg_gatk:4.2.6.1)                                                                | [Apache 2.0](https://github.com/broadinstitute/gatk/blob/master/LICENSE.TXT) |       |
| [Strelka2](https://github.com/Illumina/strelka)                                                                                  | SNV/Indel     | 2.9.10  | [`bsc_cg_strelka:2.9.10`](https://ghcr.io/computational-genomics-bsc/bsc_cg_strelka:2.9.10)                                                            | [GPL-3.0](https://github.com/Illumina/strelka/blob/v2.9.x/LICENSE.txt)       |       |
| [Delly](https://github.com/dellytools/delly)                                                                                     | SV            | 1.1.6   | [`bsc_cg_delly:1.1.6`](https://ghcr.io/computational-genomics-bsc/bsc_cg_delly:1.1.6)                                                                  | [BSD-3](https://github.com/dellytools/delly/blob/main/LICENSE)               |       |
| [GRIDSS2](https://github.com/PapenfussLab/gridss) (with [GRIPSS](https://github.com/hartwigmedical/hmftools/tree/master/gripss)) | SV            | 2.13.2  | [`bsc_cg_gridss:2.13.2`](https://ghcr.io/computational-genomics-bsc/bsc_cg_gridss:2.13.2) / [GRIPSS JAR](./required_extra_data/gridss2/gripss_2_2.jar) | [GPL-3.0](https://github.com/PapenfussLab/gridss/blob/master/COPYING)        |       |
| [Manta](https://github.com/Illumina/manta)                                                                                       | SV            | 1.6.0   | [`bsc_cg_manta:1.6.0`](https://ghcr.io/computational-genomics-bsc/bsc_cg_manta:1.6.0)                                                                  | [GPL-3.0](https://github.com/Illumina/manta/blob/master/LICENSE.txt)         |                                  |


## Downloading the variant callers

Downloading Singularity containers (using ORAS) does not require root privileges. For downloading any of the Singularity containers provided in this repository, you can use the following command:

```
singularity pull <variant_caller_name_version>.sif oras://ghcr.io/computational-genomics-bsc/<container_name:tag>
```

It is important that the container is named after the script that executes it. For example, the script [`executable_scripts/muse_2_0.sh`](executable_scripts/muse_2_0.sh) requires the singularity container to be named `muse_2_0.sif`.

**WARNING**. Your institution may not allow you to download files directly from computing nodes. If that is the case, you will need to download the container in a different machine and then copy it to the computing node. For example, you could download the container in your local machine and then copy it to the computing node using `scp`:

```
scp <variant_caller_name_version>.sif <username>@<hostname>:<path_to_singularity_containers_storage_dir>
```

## Executing the variant callers

Running Singularity containers does not require root privileges. All the scripts to execute the variant callers are located in the [`executable_scripts/`](executable_scripts/) folder of this repository. The scripts are named after the variant caller they execute and its version. For example, the script to execute MuSE v2.0 is located in [`executable_scripts/muse_2.0.sh`](executable_scripts/muse_2.0.sh).

### Parameters

All the scripts require the following parameters to be passed in the following order:

```bash
$WORKING_DIR # path to working directory
$OUTPUT_DIR # path to output directory
$EXTRA_DATA_DIR # path to extra data directory
$REF_VERSION # reference version (i.e. 37)
$NORMAL_SAMPLE # path to normal sample SAM/BAM/CRAM file
$FASTA_REF # path to reference FASTA file
$NUM_CORES # number of cores to use
$MAX_MEMORY # maximum memory to use (in GB) (i.e 8)
```

### Extra data

Some variant callers require extra data to be executed. The extra data required by each variant caller is available in the [`required_extra_data/`](required_extra_data/) folder of this repository. If you were running the variant caller from the root of this repository, you could use the following command to set the `$EXTRA_DATA_DIR` environment variable:

```bash
export EXTRA_DATA_DIR=required_extra_data
```

_Note: Due to size limitations, some files are not available in this repository and need to be downloaded from external sources. For these cases, a file with the same name but ending with `.download` will be present instead. This file contains the instructions and links to download the file._

### Example of execution

The following example shows how to execute any of the variant callers from the root of this repository:

```bash
WORKING_DIR=/path/to/working/directory
OUTPUT_DIR=/path/to/output/directory
EXTRA_DATA_DIR=./required_extra_data
REF_VERSION=37
NORMAL_SAMPLE=/path/to/normal/sample.bam
FASTA_REF=/path/to/reference.fasta
NUM_CORES=8
MAX_MEMORY=32

singularity exec -e <SINGULARITY_CONTAINER> bash ./executable_scripts/variant_caller_X_X_X.sh $WORKING_DIR $OUTPUT_DIR $EXTRA_DATA_DIR $REF_VERSION $NORMAL_SAMPLE $FASTA_REF $NUM_CORES $MAX_MEMORY

# The above command might not work in some HPC environments. In that case, you can use the following command instead:
singularity exec -c --bind $WORKING_DIR,$OUTPUT_DIR,$EXTRA_DATA_DIR,$(dirname $NORMAL_SAMPLE),$(dirname $FASTA_REF) <SINGULARITY_CONTAINER> bash ./executable_scripts/variant_caller_X_X_X.sh $WORKING_DIR $OUTPUT_DIR $EXTRA_DATA_DIR $REF_VERSION $NORMAL_SAMPLE $FASTA_REF $NUM_CORES $MAX_MEMORY
```
