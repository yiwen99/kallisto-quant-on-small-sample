# This snakefile is aimed to run kallisto quant on multiple paired-read samples
# the folder results need to be made in the current directory

BASE = '/u/project/zarlab/hjp/geuvadis_data'
SAMPLE_KEYS = sorted(os.listdir(BASE+'/rna'))

rule all:
    input:
        expand('/u/project/zarlab/yiwen99/quant/results/{sample}/abundance.h5',sample=SAMPLE_KEYS)
rule kallisto_quant:
    input:
        fq= [BASE+'/rna/{sample}/{sample}_1.fastq.gz',BASE+'/rna/{sample}/{sample}_2.fastq.gz'],
        idx= "/u/project/zarlab/yiwen99/gencode.v34.idx"
    output:
        "/u/project/zarlab/yiwen99/quant/results/{sample}/abundance.h5"
    log:
        "/u/project/zarlab/yiwen99/quant/logs/kallisto/{sample}.log"
    conda:
        "/u/project/zarlab/yiwen99/quant/kallisto.yaml"
    threads:
        1
    params:
        extra=""
    shell:"""

        kallisto quant -i {input.idx} -o /u/project/zarlab/yiwen99/quant/results/{wildcards.sample} {params.extra} {input.fq}
        """
