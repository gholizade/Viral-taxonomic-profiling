nextflow.enable.dsl=2

params {
    reads = "data/ERR2696810.fastq.gz"          // path to input reads
    database = "kraken2_db/k2_viral_20231009"     // path to k2_viral database
    output = "results"
    threads = 8
    confidence = 0.1
    kmer_len = 35
    minimizer_len = 31
    read_length = 151
    bracken_threshold = 10
    taxonomic_levels = ['P', 'C', 'O', 'F', 'G', 'S']
}

process FastQC {
    tag "FastQC on ${params.reads}"
    input:
    path reads

    output:
    path "*.html", emit: html
    path "*.zip", emit: zip

    conda "bioconda::fastqc=0.11.9"

    script:
    """
    fastqc ${reads}
    """
}

process Kraken2 {
    tag "Kraken2 classification"
    input:
    path reads

    output:
    path "kraken2.report"
    path "kraken2.output"

    conda "bioconda::kraken2=2.1.2"

    script:
    """
    kraken2 \
      --db ${params.database} \
      --confidence ${params.confidence} \
      --minimum-hit-groups 3 \
      --kmer-len ${params.kmer_len} \
      --minimizer-len ${params.minimizer_len} \
      --threads ${params.threads} \
      --report kraken2.report \
      --output kraken2.output \
      ${reads}
    """
}

process Bracken {
    tag "Bracken abundance estimation at all levels"
    input:
    path report from Kraken2.out.report

    output:
    path "bracken_*.txt"

    conda "bioconda::bracken=2.7"

    script:
    def cmds = params.taxonomic_levels.collect { level ->
      """
      bracken \
        -d ${params.database} \
        -i ${report} \
        -o bracken_${level}.txt \
        -r ${params.read_length} \
        -l ${level} \
        -t ${params.bracken_threshold}
      """.stripIndent()
    }.join("\n")

    """
    ${cmds}
    """
}

workflow {
    reads_ch = Channel.fromPath(params.reads)

    fastqc = FastQC(reads_ch)
    kraken2 = Kraken2(reads_ch)
    bracken = Bracken(kraken2.report)
}

// Notes for HPC:
// This pipeline is designed to be executed in an HPC environment using Nextflow's executor config.
// Adjust queue, time, CPUs and memory in nextflow.config as needed for your HPC scheduler (e.g. SLURM, PBS, etc).