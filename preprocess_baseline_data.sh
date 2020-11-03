cat baseline/raw_data/train.de | perl moses_scripts/normalize-punctuation.perl -l de | perl moses_scripts/tokenizer.perl -l de -a -q > baseline/preprocessed_data/train.de.p

cat baseline/raw_data/train.en | perl moses_scripts/normalize-punctuation.perl -l en | perl moses_scripts/tokenizer.perl -l en -a -q > baseline/preprocessed_data/train.en.p

perl moses_scripts/train-truecaser.perl --model baseline/preprocessed_data/tm.de --corpus baseline/preprocessed_data/train.de.p

perl moses_scripts/train-truecaser.perl --model baseline/preprocessed_data/tm.en --corpus baseline/preprocessed_data/train.en.p

cat baseline/preprocessed_data/train.de.p | perl moses_scripts/truecase.perl --model baseline/preprocessed_data/tm.de > baseline/preprocessed_data/train.de 

cat baseline/preprocessed_data/train.en.p | perl moses_scripts/truecase.perl --model baseline/preprocessed_data/tm.en > baseline/preprocessed_data/train.en

cat baseline/raw_data/valid.de | perl moses_scripts/normalize-punctuation.perl -l de | perl moses_scripts/tokenizer.perl -l de -a -q | perl moses_scripts/truecase.perl --model baseline/preprocessed_data/tm.de > baseline/preprocessed_data/valid.de

cat baseline/raw_data/valid.en | perl moses_scripts/normalize-punctuation.perl -l en | perl moses_scripts/tokenizer.perl -l en -a -q | perl moses_scripts/truecase.perl --model baseline/preprocessed_data/tm.en > baseline/preprocessed_data/valid.en

cat baseline/raw_data/test.de | perl moses_scripts/normalize-punctuation.perl -l de | perl moses_scripts/tokenizer.perl -l de -a -q | perl moses_scripts/truecase.perl --model baseline/preprocessed_data/tm.de > baseline/preprocessed_data/test.de

cat baseline/raw_data/test.en | perl moses_scripts/normalize-punctuation.perl -l en | perl moses_scripts/tokenizer.perl -l en -a -q | perl moses_scripts/truecase.perl --model baseline/preprocessed_data/tm.en > baseline/preprocessed_data/test.en

cat baseline/raw_data/tiny_train.de | perl moses_scripts/normalize-punctuation.perl -l de | perl moses_scripts/tokenizer.perl -l de -a -q | perl moses_scripts/truecase.perl --model baseline/preprocessed_data/tm.de > baseline/preprocessed_data/tiny_train.de

cat baseline/raw_data/tiny_train.en | perl moses_scripts/normalize-punctuation.perl -l en | perl moses_scripts/tokenizer.perl -l en -a -q | perl moses_scripts/truecase.perl --model baseline/preprocessed_data/tm.en > baseline/preprocessed_data/tiny_train.en


rm baseline/preprocessed_data/train.de.p
rm baseline/preprocessed_data/train.en.p

subword-nmt learn-joint-bpe-and-vocab --input ./baseline/preprocessed_data/train.en ./baseline/preprocessed_data/train.de -s 5000 -o ./baseline/preprocessed_data/bpe_code --write-vocabulary baseline/prepared_data/dict.en baseline/prepared_data/dict.de

# subword-nmt apply-bpe -c ./baseline/preprocessed_data/bpe_code --vocabulary baseline/prepared_data/dict.en --vocabulary-threshold 0 < ./baseline/preprocessed_data/train.en  > ./baseline/preprocessed_data/train_bpe.en
# subword-nmt apply-bpe -c ./baseline/preprocessed_data/bpe_code --vocabulary baseline/prepared_data/dict.en --vocabulary-threshold 0 < ./baseline/preprocessed_data/tiny_train.en  > ./baseline/preprocessed_data/tiny_train_bpe.en
subword-nmt apply-bpe -c ./baseline/preprocessed_data/bpe_code --vocabulary baseline/prepared_data/dict.en --vocabulary-threshold 0 < ./baseline/preprocessed_data/valid.en  > ./baseline/preprocessed_data/valid_bpe.en
subword-nmt apply-bpe -c ./baseline/preprocessed_data/bpe_code --vocabulary baseline/prepared_data/dict.en --vocabulary-threshold 0 < ./baseline/preprocessed_data/test.en  > ./baseline/preprocessed_data/test_bpe.en

# subword-nmt apply-bpe -c ./baseline/preprocessed_data/bpe_code --vocabulary baseline/prepared_data/dict.de --vocabulary-threshold 0 < ./baseline/preprocessed_data/train.de  > ./baseline/preprocessed_data/train_bpe.de
# subword-nmt apply-bpe -c ./baseline/preprocessed_data/bpe_code --vocabulary baseline/prepared_data/dict.de --vocabulary-threshold 0 < ./baseline/preprocessed_data/tiny_train.de  > ./baseline/preprocessed_data/tiny_train_bpe.de
subword-nmt apply-bpe -c ./baseline/preprocessed_data/bpe_code --vocabulary baseline/prepared_data/dict.de --vocabulary-threshold 0 < ./baseline/preprocessed_data/valid.de  > ./baseline/preprocessed_data/valid_bpe.de
subword-nmt apply-bpe -c ./baseline/preprocessed_data/bpe_code --vocabulary baseline/prepared_data/dict.de --vocabulary-threshold 0 < ./baseline/preprocessed_data/test.de  > ./baseline/preprocessed_data/test_bpe.de

# python3.7 preprocess.py --target-lang en --source-lang de --vocab-src baseline/prepared_data/dict.de --vocab-trg baseline/prepared_data/dict.en --dest-dir baseline/prepared_data/ --train-prefix baseline/preprocessed_data/train_bpe --valid-prefix baseline/preprocessed_data/valid_bpe --test-prefix baseline/preprocessed_data/test_bpe --tiny-train-prefix baseline/preprocessed_data/tiny_train_bpe --threshold-src 1 --threshold-tgt 1 --num-words-src 4000 --num-words-tgt 4000