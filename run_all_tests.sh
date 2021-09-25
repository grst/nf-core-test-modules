#!/bin/bash

RESULTS_DIR="./results"
rm -rf $RESULTS_DIR

nextflow run main.nf \
  -w /data/scratch/sturm/projects/2021/nf-core-modules-test \
  --profile=singularity \
  --modules_dir="/home/sturm/projects/2020/nf-core-modules" \
  --results=$RESULTS_DIR \
  -resume \
  -profile icbi


