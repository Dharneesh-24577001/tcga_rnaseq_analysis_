import glob

input_files = glob.glob("data/*/*.rna_seq.augmented_star_gene_counts.tsv")

rule all:
    input: "box_plot.png"

rule Extracting_tpm:
    input: input_files
    output: "output_folder/extracted.tsv"
    run:
        with open(output[0], 'w') as out_f:
            for input_file in input:
                dir_name = input_file.split('/')[-2]
                with open(input_file) as f:
                    for line in f:
                        fields = line.strip().split()
                        if fields[1:2] == ["NKX2-1"]:
                            out_f.write(f"{dir_name}\t{fields[6]}\n")

rule filtering:
	input:"output_folder/extracted.tsv","gdc_sample_sheet.tsv"
	output:"output_folder/processed_sample_sheet.tsv"
	shell:"python3 filtering.py"

rule graphing:
	input:"output_folder/processed_sample_sheet.tsv"
	output:"box_plot.png"
	shell:"Rscript --vanilla graphing.R {input} {output} "
