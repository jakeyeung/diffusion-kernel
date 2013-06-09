'''
Created on 2013-06-08

@author: jyeung
Using influence graph, try to get the influence of aberrant genes on outliers. 
'''


import sys
import os
from shrink_interaction_network import extract_gene_names_from_textfile
from utilities import set_directories, read_write_data

# Set constants
input_folder = 'input'
output_folder = 'output'
genename_colname = 'Name'

# Set dirs
mydirs = set_directories.paths(input_folder, output_folder)


def get_influence(influence_fullpath, row_genes, col_genes, output_fullpath):
    '''
    Reads influence matrix and extracts rownames and column names specified
    by row_genes and col_genes respectively. Output is then written to file. 
    '''
    influence = read_write_data.read_write(influence_fullpath, output_fullpath, 
                                           header=True)
    unmapped_genes = []
    with influence:
        '''
        Get column and row gene indices and rearrange column and row 
        genes according to indices.
        
        We will also likely have more row_genes and col_genes than we
        can map onto the interaction network. Therefore, we also need
        to filter the two gene lists. 
        
        Why? So we can reorder row and column genes in the same order
        as the interaction network.
        Why? So when we iterate by row, we will catch the row genes
        in order, without having to check all row genes every single 
        iteration. 
        '''
        # Insert dummy variable X to beginning of column headers so that
        # the length of column names and subsequent rows are equal. 
        influence.inputcolnames.insert(0, 'X')
        
        col_indices = []
        col_genes_filtered = []
        for cgene in col_genes:
            try:
                col_indices.append(influence.inputcolnames.index(cgene))
                col_genes_filtered.append(cgene)
            except ValueError:
                unmapped_genes.append(cgene)
        row_indices = []
        row_genes_filtered = []
        for rgene in row_genes:
            try:
                row_indices.append(influence.inputcolnames.index(rgene))
                row_genes_filtered.append(rgene)
            except ValueError:
                unmapped_genes.append(rgene)
        
        col_genes = [cgene for (_, cgene) in sorted(zip(col_indices, col_genes_filtered))]
        col_indices = [i for (i, _) in sorted(zip(col_indices, col_genes_filtered))]
        row_genes = [rgene for (_, rgene) in sorted(zip(row_indices, row_genes_filtered))]
        row_indices = [i for (i, _) in sorted(zip(row_indices, row_genes_filtered))]
        
        # Write columns to file.
        col_genes_to_file = col_genes
        col_genes_to_file.insert(0, 'X')
        influence.writenext(col_genes)
        
        '''
        Iterate rows in interaction network and extract row genes and column genes
        '''
        current_row = influence.readnext()
        current_gene = current_row[0]    # First element contains gene name.
        for rgene in row_genes:
            while current_gene != rgene:
                try:
                    current_row = influence.readnext()
                    current_gene = current_row[0]
                except StopIteration:
                    print('%s was not found in interaction network.' %rgene)
                    print('StopIteration at %s rows read, %s written.' \
                          %(influence.readrowcount, influence.writerowcount))
                    sys.exit()
            influence_on_cgenes = []
            for i in col_indices:
                influence_on_cgenes.append(current_row[i])
            influence.writenext([current_gene] + influence_on_cgenes)
        print('%s rows read, %s written.' %(influence.readrowcount, 
                                            influence.writerowcount))
        
if __name__ == '__main__':
    if len(sys.argv) < 5:
        print('4 files: influence matrix, aberrant, outlier, and outputfile '\
              'must be specified in command line. \nPaths relative to input folder.')
        sys.exit()
    
    influence_partialpath = sys.argv[1]
    aberrant_partialpath = sys.argv[2]
    outlier_partialpath = sys.argv[3]
    output_partialpath = sys.argv[4]
    
    influence_fullpath = os.path.join(mydirs.outputdir, influence_partialpath)
    aberrant_fullpath = os.path.join(mydirs.inputdir, aberrant_partialpath)
    outlier_fullpath = os.path.join(mydirs.inputdir, outlier_partialpath)
    output_fullpath = os.path.join(mydirs.outputdir, output_partialpath)
    
    # Get list of aberrant and list of outlier genes.
    aberrant_genes = extract_gene_names_from_textfile(aberrant_fullpath, 
                                                      genename_colname)
    outlier_genes = extract_gene_names_from_textfile(outlier_fullpath, 
                                                     genename_colname)
    
    # Get influence values between aberrant genes and outlier genes.
    get_influence(influence_fullpath, aberrant_genes, outlier_genes, output_fullpath)
    