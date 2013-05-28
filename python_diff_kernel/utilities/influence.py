'''
Created on 2013-05-24

@author: jyeung
'''


import csv


class diffusion_influence(object):
    '''
    Represents a diffusion influence matrix file.
    '''
    def __init__(self, full_path):
        '''
        Initialize as a full path
        '''
        self.path = full_path
        self.rowsread = 0
    
    def openfile(self):
        self.csvfile = open(self.path, 'rb')
        self.reader = csv.reader(self.csvfile, delimiter='\t')
        return self.reader
    
    def readnextline(self):
        self.rowsread += 1
        return self.reader.next()
    
    def closefile(self):
        '''
        Should only be initiated after the file has opened (readnextline)
        has been called. Closes the file to tie up loose ends.
        '''
        self.csvfile.close()
        
        
        