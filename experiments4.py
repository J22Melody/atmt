import os
import numpy as np

gammas = [0, 1, 2, 5, 10, 20, 50]

for gamma in gammas:
    os.system('python3.7 translate_beam.py --gamma {} --output ./experiments4/model_translations_gamma_{}.txt'.format(gamma, gamma))
    os.system('bash ./postprocess_asg4.sh ./experiments4/model_translations_gamma_{}.txt ./experiments4/model_translations_gamma_{}.out en'.format(gamma, gamma))
