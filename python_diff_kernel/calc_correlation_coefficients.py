'''
Created on 2013-05-23

@author: jyeung
'''


import os
import sys
from utilities import set_directories, influence
# from scipy import stats


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
    
    while True:
        try:
            print ('Influence 1 row: %s, length: %s' %(influence1.readnextline()[0:5], len(influence1.readnextline())))
            print ('Influence 2 row: %s, length: %s' %(influence2.readnextline()[0:5], len(influence2.readnextline())))
            raw_input('Paused. Enter to continue...')
        except StopIteration:
            print('No more rows to iterate, breaking...')
            break
            
    influence1.closefile()
    