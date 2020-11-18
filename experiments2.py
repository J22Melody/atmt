import os
import numpy as np
import matplotlib.pyplot as plt

alphas = np.arange(0, 1.05, 0.05)

for alpha in alphas:
    os.system('python3.7 translate_beam.py --beam-size 3 --alpha {} --output ./experiments2/model_translations_alpha_{}.txt'.format(alpha, alpha))
    os.system('bash ./postprocess_asg4.sh ./experiments2/model_translations_alpha_{}.txt ./experiments2/model_translations_alpha_{}.out en'.format(alpha, alpha))
    os.system('cat ./experiments2/model_translations_alpha_{}.out | sacrebleu data_asg4/raw_data/test.en > ./experiments2/bleu_alpha_{}'.format(alpha, alpha))

bleu_scores = []
for alpha in alphas:
    f = open('./experiments2/bleu_alpha_{}'.format(alpha), 'r')
    bleu_scores.append(float(f.read().split()[2]))
print(alphas)
print(bleu_scores)
plt.plot(alphas, bleu_scores, linestyle='-', marker='o')
plt.show()