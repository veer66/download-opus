#!/bin/sh
docker run --rm -it -v $(pwd):/work -w /work ruby ruby download-opus.rb
