'''
Created on 2013-06-08

@author: jyeung
Interaction network is too large for diffusion network (inverse of matrix), we will try
to filter genes to only ones that are outliers or differentially spliced. 
'''


import sys
import os
import csv
from utilities import set_directories, read_write_data

# Set constants
input_folder = 'input'
output_folder = 'output'
mydirs = set_directories.paths(input_folder, output_folder)

# Gene name column name
genename_colname = 'Name'

def extract_gene_names_from_textfile(file_fullpath, genename_colname):
    '''
    Reads a file and tries to find the gene name and returns a list of all 
    the gene names in that file. File name requires a header with 
    column name that specifies which column the gene name is located. 
    Inputs:
        file_fullpath: a textfile containing a list of genes in one column.
        genename_colname: column name containing column of genes.
    Outputs:
        gene_list: list of genes in textfile. 
    '''
    gene_list = []
    with open(file_fullpath, 'rb') as gene_file:
        gene_reader = csv.reader(gene_file, delimiter='\t')
        headers = gene_reader.next()
        for row in gene_reader:
            gene_list.append(row[headers.index(genename_colname)])
        print('%s genes found in %s' %(len(gene_list), file_fullpath))
    return gene_list

def exclude_genes_in_network(genes_to_keep, network_fullpath, 
                             output_fullpath, header=True):
    '''
    Filter genes in interaction network to only those in a specified gene list.
    This filtered network will be written to file. 
    Inputs:
        genes_to_keep: the output of extract_gene_names_from_textfile() which 
            is a list of gene names.
        output_fullpath: write the filtered network in a new textfile. 
        network_fullpath: textfile of interaction network containing two columns. 
            Each row of two genes represents an interaction event.
            File can contain header (True) or not. Default is true.
        header: is there a header in the network_fullpath? Default True. 
            If True, will also write header in output network.
    Outputs:
        Text file written to output_fullpath of a filtered network that includes
        only genes that we want to keep. 
    '''
    network = read_write_data.read_write(network_fullpath, 
                                         output_fullpath, 
                                         header=header)
    with network:
        # Write column names if header is true
        if header == True:
            network.writenext(network.inputcolnames)
        elif header == False:
            pass
        else:
            sys.argv('Header must be either True or False, %s given' %header)
        while True:
            try:
                readrow = network.readnext()
            except StopIteration:
                print('%s rows read, %s written, breaking loop...' \
                      %(network.readrowcount, network.writerowcount))
                break
            # If both genes in first and second column are in genes to keep,
            # then write row to file. 
            if readrow[0] in genes_to_keep and readrow[1] in genes_to_keep:
                network.writenext(readrow)
    return None

if __name__ == '__main__':
    if len(sys.argv) < 3:
        print('3 files: outliers, differentially spliced genes, and interaction network '\
              'must be specified in command line. \nPaths relative to input folder.')
        sys.exit()
        
    dsg_partialpath = sys.argv[1]
    outlier_partialpath = sys.argv[2]
    network_partialpath = sys.argv[3]
    filtered_network_output_partialpath = sys.argv[4]
    
    outlier_fullpath = os.path.join(mydirs.inputdir, outlier_partialpath)
    dsg_fullpath = os.path.join(mydirs.inputdir, dsg_partialpath)
    network_fullpath = os.path.join(mydirs.inputdir, network_partialpath)
    filtered_network_output_fullpath = os.path.join(mydirs.inputdir, 
                                                       filtered_network_output_partialpath)
    
    # Get list of outlier and dsg genes to be checked against network. 
    full_gene_list = extract_gene_names_from_textfile(dsg_fullpath, 
                                                      genename_colname) +\
                      extract_gene_names_from_textfile(outlier_fullpath, 
                                                       genename_colname)
    # Filter network to only include genes in full_gene_list
    exclude_genes_in_network(full_gene_list, network_fullpath, 
                             filtered_network_output_fullpath, 
                             header=True)