BASE = '/u/project/zarlab/hjp/geuvadis_data'
#SAMPLE_NAMES = dict()
#with open('/u/project/zarlab/hjp/geuvadis_data/metadata/clean.tsv') as file_handle:
    #for line in file_handle:
        #line=line.split('\t')
        #SAMPLE_NAMES[line[0]] = line[1:3]
#SAMPLE_KEYS = sorted(os.listdir(BASE+'/rna'))
#need to change above for running all samples

SAMPLE_NAMES = dict()
with open('/u/project/zarlab/hjp/geuvadis_data/annotation/yri_sample_intersection.txt') as file_handle:
    for line in file_handle:
        line=line.split('\n')
        SAMPLE_NAMES[line[0]] = line

SAMPLE_KEYS=sorted(SAMPLE_NAMES)

rule all:
    input:
        expand('/u/project/zarlab/yiwen99/quant/results/{sample}/abundance.h5',sample=SAMPLE_KEYS)
rule kallisto_quant:
    input:
        fq= [BASE+'/rna/{sample}/{sample}_1.fastq.gz',BASE+'/rna/{sample}/{sample}_2.fastq.gz'],
        idx= "/u/project/zarlab/yiwen99/quant/transcriptome.idx"
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
