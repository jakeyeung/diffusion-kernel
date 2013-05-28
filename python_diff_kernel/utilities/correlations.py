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
        
        self.nacount = 0
        self.nagenes = []
    
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
            if vector1[0] == vector2[0]:
                row_name = vector1[0]
                try:
                    vector1 = [float(i) for i in vector1[1:len(vector1)]]
                    vector2 = [float(i) for i in vector2[1:len(vector2)]]
                except ValueError:    # if there are NAs, make them zero.
                    print('Rowname: %s strange, skipping for spearman calculation.' %row_name)
                    return None
                    '''
                    vector1 = [0] * (len(vector1) - 1)
                    vector2 = [0] * (len(vector2) - 1)
                    self.nacount += 1
                    self.nagenes.append(row_name)
                    self.spearman_dic[]
                    '''
                spearman_cor, spearman_pval = stats.spearmanr(vector1, vector2)
                self.spearman_dic[row_name].append((spearman_cor, spearman_pval))
            else:
                print('Row name of two vectors not equal, %s and %s' %(vector1[0], vector2[0]))
                sys.exit('Exiting...')
        else:
            print('Rownames must be either True or False.')
            sys.exit('Exiting...')
        
    def add_pearson_cor(self, vector1, vector2, rownames=False):
        '''
        Given two vectors, calculate pearson correlation,
        add pearson correlation and p-value into the list
        of self.pearson
        '''
        if rownames == False:
            pearson_cor, pearson_pval = stats.pearsonr(vector1, vector2)
            self.pearson_dic.append((pearson_cor, pearson_pval))
        elif rownames == True:
            if vector1[0] == vector2[0]:
                row_name = vector1[0]
                try:
                    vector1 = [float(i) for i in vector1[1:len(vector1)]]
                    vector2 = [float(i) for i in vector2[1:len(vector2)]]
                except ValueError:
                    print('Rowname: %s strange. Skipping for pearson calculation.' %row_name)
                    return None
                    '''
                    vector1 = [0] * (len(vector1) - 1)
                    vector2 = [0] * (len(vector2) - 1)
                    self.nacount += 1
                    self.nagenes.append(row_name)
                    row_name = 'NAgene'
                    '''
                pearson_cor, pearson_pval = stats.pearsonr(vector1, vector2)
                self.pearson_dic[row_name].append((pearson_cor, pearson_pval))
            else:
                print('Row name of two vectors not equal, %s and %s' %(vector1[0], vector2[0]))
                sys.exit('Exiting...')
        else:
            print('Rownames must be either True or False.')
            sys.exit('Exiting...')