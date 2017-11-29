#!/bin/bash
# adapted from http://jpgtoheif.com
TEMP_FILE=bitstream.265
TEMP_THUMB=bitstream.thumb.265
TEMP_CFG=heic.json
IN_FILE=${1:-input.tif}
IN_NAME=$(basename ${IN_FILE%.*})
QUALITY=${2:-24} # originally 12 was the default
OUT_FILE=${3:-$IN_NAME-$QUALITY.heic}

echo -e "\n"
echo -e "📥 \$1 IN_FILE:  ${IN_FILE}"
echo -e "🌈 \$2 QUALITY:  ${QUALITY}"
echo -e "📤 \$3 OUT_FILE: ${OUT_FILE}"
echo -e "\n"

[ -e ${TEMP_FILE} ] && rm ${TEMP_FILE}
[ -e ${TEMP_THUMB} ] && rm ${TEMP_THUMB}
[ -e ${TEMP_CFG} ] && rm ${TEMP_CFG}

# generate config file
perl -pe "s|output.heic|${OUT_FILE}|g" config.json > $TEMP_CFG

./ffmpeg -i ${IN_FILE} -crf ${QUALITY} -preset slower -pix_fmt yuv420p -f hevc $TEMP_FILE
./ffmpeg -i ${IN_FILE} -vf scale=320:240 -crf 28 -preset slower -pix_fmt yuv420p -f hevc $TEMP_THUMB
./writerapp $TEMP_CFG

rm ${TEMP_FILE}
rm ${TEMP_THUMB}