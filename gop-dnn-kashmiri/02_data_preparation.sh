# # The MIT License (MIT)

# # Permission is hereby granted, free of charge, to any person obtaining a copy
# # of this software and associated documentation files (the "Software"), to deal
# # in the Software without restriction, provided that the following conditions are met:
# # The above copyright notice and this permission notice shall be included in all
# # copies or substantial portions of the Software.
# #**The software is provided for research purposes only and may not be used for commercial purposes.**
# # THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# # IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# # FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  #AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# # LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# # OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# #!/bin/sh -e

# . ./path.sh

# ln -fs $KALDI_ROOT/egs/wsj/s5/steps .
# ln -fs $KALDI_ROOT/egs/wsj/s5/utils .
# ln -fs $KALDI_ROOT/src .

# head=$1
# normtype=$2
# data=exp_epadb
# expdir=$data/test_${normtype}_$head


# # This script takes epadb waveforms and transcriptions and creates a temporal directory with .wav and .lab files to extract features.
# # In the end you should expect to have wav.scp, utt2spk, spk2utt and text files in data/test folder.

# echo "Creating temporary folders for kashmiri_english files"
# mkdir -p $data
# for d in $EPADB_ROOT/*/; do
#     echo $d

#     mkdir -p $data/corpus/$(basename $d) $data/labels/$(basename $d)
#     ln -sf $d/waveforms/*.wav          $data/corpus/$(basename $d)/
#     ln -sf $d/transcriptions/*.lab     $data/corpus/$(basename $d)/
#     ln -sf $d/annotations_1/*.TextGrid $data/corpus/$(basename $d)/
#     ln -sf $d/labels/*.csv $data/labels/$(basename $d)/
#     # rm $data/labels/$(basename $d)/*.TextGrid

# done

# echo 'done'

# # Files needed by Kaldi scripts

# echo "Preparing data dirs"

# mkdir -p $expdir
# rm -rf $expdir/{wav.scp,spk2utt,utt2spk,text}
# for d in $data/corpus/*; do

#     for f in $d/*.wav; do
#         filename=$(basename $f .wav)
#         filepath=$(dirname $f)
#         spkname=$(basename $filepath)
#         # echo "$filename $f"       >> $expdir/wav.scp # Prepare wav.scp
#         # echo "$spkname $filename" >> $expdir/spk2utt # Prepare spk2utt
#         # echo "$filename $spkname" >> $expdir/utt2spk # Prepare utt2spk
#         echo "${spkname}_${filename} $f" >> $expdir/wav.scp
#         echo "${spkname}_${filename} $spkname" >> $expdir/utt2spk
#         # echo "$spkname ${spkname}_${filename}" >> $expdir/spk2utt

#         (
#             # printf "$filename "
#             # cat $data/corpus/$spkname/${filename%.*}.lab | tr [a-z] [A-Z]
#             printf "${spkname}_${filename} "
#             cat $data/corpus/$spkname/${filename%.*}.lab | tr [a-z] [A-Z]

#             printf "\n"
#         ) >> $expdir/text # Prepare transcriptions
#     done
# done
# utils/fix_data_dir.sh $expdir

# # Extract the MFCC features for all the wavs

# echo "Extracting features"

# steps/make_mfcc.sh --nj 2 --mfcc-config conf/mfcc_hires.conf --cmd "run.pl" $expdir
# steps/compute_cmvn_stats.sh $expdir
# utils/fix_data_dir.sh $expdir

# # Extract ivectors

# echo "Extracting ivectors"

# steps/online/nnet2/extract_ivectors_online.sh --cmd "run.pl" --nj 1  \
#     $expdir 0013_librispeech_v1/exp/nnet3_cleaned/extractor \
#     $expdir/ivectors

# echo "Finished data preparation and feature extraction!"



#!/bin/sh -e

# =========================================================
# Kaldi Data Preparation + MFCC + iVector Extraction
# =========================================================

. ./path.sh

ln -fs $KALDI_ROOT/egs/wsj/s5/steps .
ln -fs $KALDI_ROOT/egs/wsj/s5/utils .
ln -fs $KALDI_ROOT/src .

export LC_ALL=C

head=$1
normtype=$2

data=exp_epadb
expdir=$data/test_${normtype}_$head

# =========================================================
# Create temporary folders and symbolic links
# =========================================================

echo "Creating temporary folders for Kashmiri-English files"

mkdir -p $data

for d in $EPADB_ROOT/*/; do

    echo "$d"

    rawspk=$(basename "$d")

    mkdir -p $data/corpus/$rawspk
    mkdir -p $data/labels/$rawspk

    ln -sf $d/waveforms/*.wav          $data/corpus/$rawspk/
    ln -sf $d/transcriptions/*.lab     $data/corpus/$rawspk/
    ln -sf $d/annotations_1/*.TextGrid $data/corpus/$rawspk/
    ln -sf $d/labels/*.csv             $data/labels/$rawspk/

done

echo "Done creating links"

# =========================================================
# Prepare Kaldi Data Directory
# =========================================================

echo "Preparing Kaldi data directory"

mkdir -p $expdir

rm -f $expdir/wav.scp
rm -f $expdir/text
rm -f $expdir/utt2spk
rm -f $expdir/spk2utt

for d in $data/corpus/*; do

    rawspk=$(basename "$d")

    # -----------------------------------
    # Convert:
    # spkr1  -> spkr01
    # spkr2  -> spkr02
    # spkr10 -> spkr10
    # -----------------------------------

    num=$(echo "$rawspk" | grep -o '[0-9]\+')

    spkname=$(printf "spkr%02d" "$num")

    for f in $d/*.wav; do

        [ -e "$f" ] || continue

        filename=$(basename "$f" .wav)

        uttid="${spkname}_${filename}"

        # -----------------------------------
        # wav.scp
        # -----------------------------------

        echo "$uttid $f" >> $expdir/wav.scp

        # -----------------------------------
        # utt2spk
        # -----------------------------------

        echo "$uttid $spkname" >> $expdir/utt2spk

        # -----------------------------------
        # text
        # -----------------------------------

        (
            printf "%s " "$uttid"

            cat $data/corpus/$rawspk/${filename}.lab | tr '[a-z]' '[A-Z]'

            printf "\n"

        ) >> $expdir/text

    done
done

# =========================================================
# Sort all files properly
# =========================================================

sort -k1,1 -u $expdir/wav.scp -o $expdir/wav.scp
sort -k1,1 -u $expdir/text -o $expdir/text

# VERY IMPORTANT:
# Sort utt2spk first by speaker-id then utterance-id

sort -k2,2 -k1,1 -u \
    $expdir/utt2spk \
    -o $expdir/utt2spk

# =========================================================
# Generate spk2utt
# =========================================================

utils/utt2spk_to_spk2utt.pl \
    $expdir/utt2spk > $expdir/spk2utt

# =========================================================
# Fix + Validate
# =========================================================

echo "Fixing data directory"

utils/fix_data_dir.sh $expdir

echo "Validating data directory"

utils/validate_data_dir.sh --no-feats $expdir

# =========================================================
# Extract MFCC Features
# =========================================================

echo "Extracting MFCC features"

steps/make_mfcc.sh \
    --nj 2 \
    --mfcc-config conf/mfcc_hires.conf \
    --cmd "run.pl" \
    $expdir \
    $expdir/log \
    $expdir/mfcc

# =========================================================
# Compute CMVN Statistics
# =========================================================

echo "Computing CMVN statistics"

steps/compute_cmvn_stats.sh \
    $expdir \
    $expdir/log \
    $expdir/mfcc

utils/fix_data_dir.sh $expdir

# =========================================================
# Extract iVectors
# =========================================================

echo "Extracting iVectors"

steps/online/nnet2/extract_ivectors_online.sh \
    --cmd "run.pl" \
    --nj 1 \
    $expdir \
    0013_librispeech_v1/exp/nnet3_cleaned/extractor \
    $expdir/ivectors

echo "Finished data preparation and feature extraction!"