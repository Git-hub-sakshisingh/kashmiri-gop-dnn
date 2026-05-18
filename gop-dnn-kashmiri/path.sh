export KALDI_ROOT=/home/sakshi/kaldi-trunk
export EPADB_ROOT=/home/sakshi/kashmiri_analysis/Kashmiri_English/train
export MODEL_ROOT=/home/sakshi/kashmiri_analysis/gop-dnn-kashmiri/0013_librispeech_v1


[ -f $KALDI_ROOT/tools/env.sh ] && . $KALDI_ROOT/tools/env.sh

export PATH=$KALDI_ROOT/egs/wsj/s5/utils:$KALDI_ROOT/egs/wsj/s5/steps:$KALDI_ROOT/egs/gop/s5/local:$KALDI_ROOT/tools/openfst/bin:$PATH

[ ! -f $KALDI_ROOT/tools/config/common_path.sh ] && echo >&2 "The standard file $KALDI_ROOT/tools/config/common_path.sh is not present -> Exit!" && exit 1

. $KALDI_ROOT/tools/config/common_path.sh

export LC_ALL=C
