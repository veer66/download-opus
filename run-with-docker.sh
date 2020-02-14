#!/bin/sh

docker run \
       --rm \
       -it \
       -u $(ls -n README.md | awk '{ print $3; }') \
       -v $(pwd):/work \
       -w /work \
       ruby \
       ruby download-opus.rb
