#!/bin/sh

SRC=en
TGT=th
DATA=data
CORPUS=corpus
HELDOUTSIZE=2000
RAWDIR=$DATA/raw/$SRC-$TGT
DEVSET=mozorg
TESTSET=mozorg

mkdir -p $RAWDIR

for i in $CORPUS/*/latest/moses/*.txt.zip; do
    echo $i
    unzip -u $i -d $RAWDIR
    rm -f $RAWDIR/*.xml
    rm -f $RAWDIR/*.ids
    rm -f $RAWDIR/README
    rm -f $RAWDIR/LICENSE
done


