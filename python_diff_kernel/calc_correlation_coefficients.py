'''
Created on 2013-05-23

@author: jyeung
'''


import os
import sys
from utilities import set_directories, influence, correlations


# Set directories
path = set_directories.paths('input', 'output')

# Set constants
hprdfolder = 'hprd'
textoutputfolder = 'text_outputs'
# influence_filename1 = 'hprd_full_table3.txt'
# influence_filename2 = 'HPRD_InfluenceGraph_HotNet.txt'


if __name__ == '__main__':
    if len(sys.argv) < 3:
        print('Two influence matrices must be provided in command line.')
        sys.exit()
    
    # Define filenames
    influence_filename1 = sys.argv[1]
    influence_filename2 = sys.argv[2]
    
    # Define full path names
    influence_fpath1 = os.path.join(path.outputdir, hprdfolder, textoutputfolder, influence_filename1)
    influence_fpath2 = os.path.join(path.outputdir, hprdfolder, textoutputfolder, influence_filename2)
    
    # Create two classes
    influence1 = influence.diffusion_influence(influence_fpath1)
    influence2 = influence.diffusion_influence(influence_fpath2)
    
    # Open the two files, create .reader instances
    influence1.openfile()
    influence2.openfile()
    
    # Define headers
    headers1 = influence1.readnextline()
    headers2 = influence2.readnextline()
    
    # Initialize dictionary
    influence_correlations = correlations.correlations(headers1)
    print influence_correlations.headers
    
    # Do pearson and spearman correlation
    while True:
        try:
            row1 = influence1.readnextline()
            row2 = influence2.readnextline()
            influence_correlations.add_spearman_cor(row1, row2, rownames=True)
            influence_correlations.add_pearson_cor(row1, row2, rownames=True)
            raw_input('Paused. Enter to continue...')
        except StopIteration:
            print('No more rows to iterate, breaking...')
            break
            
    influence1.closefile()
    influence2.closefile()
    