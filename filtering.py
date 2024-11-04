import pandas as pd

def process_sample_sheet(input_file, sample_sheet, output_file):
    # Read the input files
    tpm_data = pd.read_csv(input_file, sep='\t', header=None)
    sample_data = pd.read_csv(sample_sheet, sep='\t')

    # Rename columns for clarity
    tpm_data.columns = ['Identifier', 'TPM_Value']

    # Merge the DataFrames on 'Identifier'
    merged_data = sample_data.merge(tpm_data, left_on='File ID', right_on='Identifier', how='inner')

    # Filter based on Sample Type
    filtered_data = merged_data[merged_data['Sample Type'].isin(['Solid Tissue Normal', 'Primary Tumor'])]

    # Select relevant columns for output
    final_output = filtered_data[['File ID', 'Sample Type', 'TPM_Value']]

    # Write to output file
    final_output.to_csv(output_file, sep='\t', index=False)

# Example usage
process_sample_sheet("output_folder/extracted.tsv", "gdc_sample_sheet.tsv", "output_folder/processed_sample_sheet.tsv")

