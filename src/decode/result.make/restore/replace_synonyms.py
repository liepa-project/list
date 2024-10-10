#!/usr/bin/env python
import argparse

def replace_code_with_synonym(data_file, dictionary_file):
    """
    Replaces code values in a CSV file with their corresponding synonyms from a dictionary file.

    Args:
        data_file (str): Path to the input CSV file containing data with code values.
        dictionary_file (str): Path to the CSV file containing code-synonym pairs.
        output_file (str): Path to the output CSV file where the modified data will be saved.
    """

    # Load data from CSV files
    with open(data_file, 'r') as f:
        data_lines = f.readlines()
    with open(dictionary_file, 'r') as f:
        synonym_lines = f.readlines()

    # Create a dictionary mapping codes to synonyms
    code_to_synonym = {}
    for line in synonym_lines:
        code, synonym = line.strip().split('\t')
        code_to_synonym[code] = synonym

    # Replace code values with synonyms in the data
    modified_lines = []
    for line in data_lines:
        columns = line.strip().split('\t')
        if len(columns) > 3:
            word_code=columns[2]
            word_synonym=code_to_synonym.get(word_code, word_code)
            #print("columns", word_code, word_synonym)
            columns[2]=word_synonym
        print('\t'.join(columns))
        #code_index = columns.index('code')
        #code = columns[code_index]
        #if code in code_to_synonym:
        #    columns[code_index] = code_to_synonym[code]
        #modified_lines.append('\t'.join(columns) + '\n')

    # Write modified data to the output file
    #with open(output_file, 'w') as f:
    #    f.writelines(modified_lines)

if __name__ == "__main__":
    argparser = argparse.ArgumentParser(description='Semantika Ausis is client')
    # Optional positional argument
    argparser.add_argument('-i', '--input', type=str, 
                    help='input e.g. test/L1.lat', required=True)
    argparser.add_argument('-d', '--dictionary', type=str, 
                    help='input e.g. test/synonyms.csv', required=True)
    args = argparser.parse_args()
    input_file=args.input
    dictionary_file = args.dictionary
    replace_code_with_synonym(input_file, dictionary_file)

