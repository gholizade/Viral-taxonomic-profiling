# Viral Taxonomic Classification Pipeline (Nextflow)

This pipeline performs quality control, taxonomic classification, and abundance estimation of shotgun metagenomic data using Kraken2 and Bracken (v2.7), specifically with the `k2_viral_20231009` database.

## 📁 Directory Structure

```
.
├── data/                       # Contains input FASTQ files
│   └── ERR2696810.fastq.gz     # Example input file
├── kraken2_db/                # Folder with k2_viral_20231009 DB
├── envs/
│   └── conda.yml              # Conda environment file
├── main.nf                    # Nextflow pipeline
├── nextflow.config            # Configuration file for SLURM HPC
└── README.md
```

## ⚙️ Requirements

- Conda (Miniconda/Anaconda)
- Nextflow `>=22.10`
- Access to `k2_viral_20231009` Kraken2 database
- HPC or Unix system (e.g. SLURM)

## 🚀 Usage

### Step 1: Create Environment

```bash
conda env create -f envs/conda.yml
conda activate viral_taxonomy_env
```

### Step 2: Run the Pipeline

```bash
nextflow run main.nf -profile slurm
```

## 📤 Output Files

- `kraken2.report`, `kraken2.output` — classification outputs
- `bracken_P.txt` to `bracken_S.txt` — taxonomic abundance tables
- `fastqc` HTML and ZIP report

## 💡 Notes

- This pipeline assumes the input reads are untrimmed based on FastQC quality metrics.
- Designed to run on SLURM HPC environments with the provided `nextflow.config`.
- Place your real or synthetic FASTQ file in the `data/` folder.