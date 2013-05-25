'''
Created on 2013-05-23

@author: jyeung
'''


import os


class paths(object):
    '''
    Path directories.
    '''


    def __init__(self, inputdir, outputdir):
        '''
        Constructor
        '''
        self.curdir = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
        self.projdir = os.path.dirname(os.path.dirname(os.path.dirname(self.curdir)))
        self.inputdir = os.path.join(self.projdir, inputdir)
        self.outputdir = os.path.join(self.projdir, outputdir)
        
        
        