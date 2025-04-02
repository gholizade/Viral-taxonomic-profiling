# Viral Taxonomic Classification Pipeline (Nextflow)

Viral Taxonomic Profiling Workflow
This is a fully reproducible Nextflow pipeline for taxonomic profiling of shotgun metagenomic data.
It focuses on identifying and estimating the abundance of viral species using the k2_viral_20231009 database through Kraken2 and Bracken.

## This workflow is designed to:

- Run on SLURM-based HPC environments
- Use conda for environment management
- Handle untrimmed FASTQ shotgun reads
- Output taxonomy tables at all classification levels (phylum to species)


## Prerequisites
Make sure the following are installed or available:
Nextflow >= 22.10
conda (Miniconda or Anaconda)
Access to a HPC or Unix system (e.g. SLURM) 
Prebuilt Kraken2 database: k2_viral_20231009 (Download link)

## Usage

### Step 1: Create Environment

```bash
conda env create -f envs/conda.yml
conda activate viral_taxonomy_env
```

### Step 2: Run the Pipeline

```bash
nextflow run main.nf -profile slurm
```

## Output Files

- `kraken2.report`, `kraken2.output` — classification outputs
- `bracken_P.txt` to `bracken_S.txt` — taxonomic abundance tables
- `fastqc` HTML and ZIP report

## 💡 Notes

- This pipeline assumes the input reads are untrimmed based on FastQC quality metrics.
- Designed to run on SLURM HPC environments with the provided `nextflow.config`.
- Place your real or synthetic FASTQ file in the `data/` folder.
- 
## Shell commands you can copy-paste to run this pipeline step-by-step on your HPC
The following instructions provide step-by-step shell commands you can copy and paste directly into your terminal to run the entire workflow on an HPC cluster (with SLURM).
It includes setting up the environment, downloading input data and the viral Kraken2 database, and running the pipeline using Nextflow.
This ensures your run is fully reproducible and aligned with the workflow described in our publication.

### 1. Set Up the Project
bash
Copy
Edit
git clone https://github.com/your-username/viral-taxonomy-pipeline.git
cd viral-taxonomy-pipeline
Or unzip the provided archive.

### 2. Download Sample Data
bash
Copy
Edit
mkdir -p data
wget -O data/ERR2696810.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR269/ERR2696810/ERR2696810.fastq.gz

### 3. Download Kraken2 Viral Database
bash
Copy
Edit
mkdir -p kraken2_db
cd kraken2_db
wget https://genome-idx.s3.amazonaws.com/kraken/k2_viral_20231009.tar.gz
tar -xvzf k2_viral_20231009.tar.gz
cd ..
Note: This database is already prebuilt and doesn’t require kraken2-build.

### 4. Create the Conda Environment
bash
Copy
Edit
conda env create -f envs/conda.yml
conda activate viral_taxonomy_env

### 5. Run the Pipeline
bash
Copy
Edit
nextflow run main.nf -profile slurm
This will:
- Run FastQC to assess read quality
- Classify viral reads with Kraken2 (custom parameters)
- Estimate abundances at all levels (P → S) using Bracken

### 6. Collect Results
You’ll find:

- kraken2.report, kraken2.output — classification details
- bracken_P.txt to bracken_S.txt — abundance per taxonomic level
- fastqc HTML and ZIP reports

