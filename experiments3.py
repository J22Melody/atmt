import os
import matplotlib.pyplot as plt

beam_sizes = list(range(1, 11)) + [15, 20, 30, 50]

for beam_size in beam_sizes:
    os.system('python3.7 translate_beam.py --beam-size {} --alpha 0.9 --output ./experiments3/model_translations_beam_size_{}.txt'.format(beam_size, beam_size))
    os.system('bash ./postprocess_asg4.sh ./experiments3/model_translations_beam_size_{}.txt ./experiments3/model_translations_beam_size_{}.out en'.format(beam_size, beam_size))
    os.system('cat ./experiments3/model_translations_beam_size_{}.out | sacrebleu data_asg4/raw_data/test.en > ./experiments3/bleu_beam_size_{}'.format(beam_size, beam_size))

bleu_scores = []
for beam_size in beam_sizes:
    f = open('./experiments3/bleu_beam_size_{}'.format(beam_size), 'r')
    bleu_scores.append(float(f.read().split()[2]))
print(beam_sizes)
print(bleu_scores)
plt.plot(beam_sizes, bleu_scores, linestyle='-', marker='o')
plt.show()