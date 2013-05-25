'''
Created on 2013-05-24

@author: jyeung
'''


import sys
from scipy import stats


class correlations(object):
    '''
    For each gene, provide a correlation (spearman and pearson) as a 
    dictionary...
    '''


    def __init__(self, header_names):
        '''
        Constructor
        '''
        self.spearman_dic = {}
        for header in header_names:
            self.spearman_dic[header] = []
        
        self.pearson_dic = {}
        for header in header_names:
            self.pearson_dic[header] = []
            
        self.headers = header_names
    
    def add_spearman_cor(self, vector1, vector2, rownames=False):
        '''
        Given two vectors, calculate spearman correlation,
        add spearman correlation and p-value into the list
        of self.spearman.
        
        Asks if rownames exist, if True means first value in vector1
        and vector2 is a rowname, so we must start from second value. 
        
        If False, then just take vector as is.
        '''
        if rownames == False:
            spearman_cor, spearman_pval = stats.spearmanr(vector1, vector2)
            self.spearman_dic.append((spearman_cor, spearman_pval))
        elif rownames == True:
            vector1 = vector1[1:len(vector1)]
            vector2 = vector2[1:len(vector2)]
            spearman_cor, spearman_pval = stats.spearmanr(vector1, vector2)
            self.spearman_dic.append((spearman_cor, spearman_pval))
        else:
            print('Rownames must be either True or False.')
            sys.exit('Exiting...')
        
    def add_pearson_cor(self, vector1, vector2, rownames=False):
        '''
        Given two vectors, calculate pearson correlation,
        add pearson correlation and p-value into the list
        of self.pearson
        '''
        pearson_cor, pearson_pval = stats.pearsonr(vector1, vector2)
        self.pearson_dic.append((pearson_cor, pearson_pval))