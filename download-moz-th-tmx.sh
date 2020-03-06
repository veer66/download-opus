#!/bin/sh

GECKO_URL='https://transvision.mozfr.org/downloads/?locale=th&tmx_format=normal&gecko_strings=gecko_strings'
MOZORG_URL='https://transvision.mozfr.org/downloads/?locale=th&tmx_format=normal&mozilla_org=mozilla_org'

./download-moz-th-tmx-each.sh $GECKO_URL gecko
./download-moz-th-tmx-each.sh $MOZORG_URL mozorg
