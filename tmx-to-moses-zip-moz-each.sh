#!/bin/sh

if [ $# -ne 1 ]; then
    echo "Usage $0: <CORPUS NAME>"
    exit 1
fi

set -x

SRC=en
TGT=th
LANGPAIR=$SRC-$TGT
CORPUS_NAME=$1
TMX=`ls corpus/$CORPUS_NAME/latest/*.tmx | head -n1`
TMPDIR=corpus/$CORPUS_NAME/moses-tmp.$$
mkdir -p $TMPDIR
PREFIX=$TMPDIR/$CORPUS_NAME.$LANGPAIR.
clojure tmx_to_moses.clj -p $PREFIX $TMX
OUTPUTDIR=$(pwd)/corpus/$CORPUS_NAME/latest/moses
mkdir -p $OUTPUTDIR
CURR_DIR=$(pwd)
cd $TMPDIR
ls -al
zip $OUTPUTDIR/$LANGPAIR.txt.zip $CORPUS_NAME.$LANGPAIR.$SRC $CORPUS_NAME.$LANGPAIR.$TGT
cd $CURR_DIR
rm -rf $TMPDIR
