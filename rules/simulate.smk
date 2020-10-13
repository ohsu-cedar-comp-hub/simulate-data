rule chr_fasta:
    input:
        fa = "input/genome.fa"
    output:
        expand("input/genome/{chr}.fa", chr = CHRS)
    conda:
        "../envs/samtools.yaml"
    shell:
        """
        chr=$(seq 1 1 22)" X Y"
        for i in $chr ; do 
            samtools faidx {input} chr$i > input/genome/chr$i.fa
        done
        """

rule rep_par:
    input:
        "input/myParameters.par"
    output:
        "input/Sample{rep}.par"
    shell:
        "cp {input} {output}"

rule simulate:
    input:
        fa = expand("input/genome/{chr}.fa", chr = CHRS),
        gtf = "input/annot.gtf",
        par = "input/Sample{rep}.par"
    output:
        "input/Sample{rep}.fastq"
    conda:
        "../envs/fluxsim.yaml"
    shell:
        """
        export FLUX_MEM="100G"
        flux-simulator -p {input.par}
        """

rule split_reads:
    input:
        "input/Sample{rep}.fastq"
    output:
        R1 = "output/Sample{rep}_R1.fastq",
        R2 = "output/Sample{rep}_R2.fastq"
    shell:
        """
        grep -A 3 '/1' {input} | sed '/^--/d' > {output.R1}
        grep -A 3 '/2' {input} | sed '/^--/d' > {output.R2}
        """

