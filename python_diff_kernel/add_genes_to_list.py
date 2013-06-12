'''
Created on 2013-06-12

@author: jyeung
Read many files and create a list of genes to be written to file.
We'll put these genes into one file which will be read to 'shrink'
interaction network. 
'''

import sys
import os
import csv
from utilities import set_directories
from shrink_interaction_network import extract_gene_names_from_textfile


# Set constants
input_folder = 'input'
output_folder = 'output'
genename_colname = 'Name'
output_colnames = ['ensembl_id', 'Name']

# Set dirs
mydirs = set_directories.paths(input_folder, output_folder)

def write_gene_list_to_file(output_fullpath, gene_list, write_ensembl_id=False):
    '''
    In order to make output file look closer to what Fan has provided me, 
    I have added a dummy first column... Not ideal, but it may help later
    by keeping all the formatting the same. 
    '''
    writecount = 0
    if write_ensembl_id == False:
        pass
    else:
        print('Writing ensembl ID not yet implemented in code...')
        sys.exit()
    with open(output_fullpath, 'wb') as output_file:
        output_writer = csv.writer(output_file, delimiter='\t')
        # Writer header
        output_writer.writerow(output_colnames)
        for gene in gene_list:
            # First row is ensembl_id, but we ignoreit. 
            output_writer.writerow(['did_not_read_ensembl_id', gene])
            writecount += 1
    print('%s rows written, no more genes to write.' %writecount)
    print('File written to %s' %output_fullpath)
    return None

if __name__ == '__main__':
    if len(sys.argv) < 3:
        print('List of comma-separated input filenames (partial paths relative to input folder)'\
              ' and output filename (relative to output folder) must be specified'\
              ' in command line.')
        sys.exit()
    
    comma_separated_input_partialpaths = sys.argv[1]
    output_partialpath = sys.argv[2]
    
    # Parse comma-separated inputs
    input_partialpaths = comma_separated_input_partialpaths.split(',')
    input_fullpaths = []
    for i in input_partialpaths:
        input_fullpaths.append(os.path.join(mydirs.inputdir, i))
    output_fullpath = os.path.join(mydirs.inputdir, output_partialpath)
    
    gene_list = []
    for filepath in input_fullpaths:
        gene_list += extract_gene_names_from_textfile(filepath, genename_colname)
    
    write_gene_list_to_file(output_fullpath, gene_list, write_ensembl_id=False)
    