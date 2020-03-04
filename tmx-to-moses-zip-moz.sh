#!/bin/sh

TMX=`ls corpus/moz/*.tmx | head -n1`
TMPDIR=corpus/moz/moses-tmp.$$
mkdir -p $TMPDIR
PREFIX=$TMPDIR/moz.en-th.
clojure tmx_to_moses.clj -p $PREFIX $TMX
OUTPUTDIR=corpus/moz/latest/moses
mkdir -p $OUTPUTDIR
zip $OUTPUTDIR/en-th.txt.zip ${PREFIX}en ${PREFIX}th
