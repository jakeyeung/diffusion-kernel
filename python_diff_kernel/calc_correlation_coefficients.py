'''
Created on 2013-05-23

@author: jyeung
'''


from utilities import set_directories

# Set directories
'''
_cur_dir = os.path.dirname(os.path.realpath(__file__))
_upthree_dir = os.path.dirname(os.path.dirname(os.path.dirname(_cur_dir)))
_input_dir = os.path.join(_upthree_dir, 'inputs')
_output_dir = os.path.join(_upthree_dir, 'outputs')
_plot_dir = os.path.join(_output_dir, 'plots')
'''


if __name__ == '__main__':
    directories = set_directories.paths('curdir')
    print directories.curdir