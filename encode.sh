#!/bin/bash
# adapted from http://jpgtoheif.com
TEMP_FILE=bitstream.265
TEMP_THUMB=bitstream.thumb.265
TEMP_CFG=heic.json
TEMP_EXIF=bitstream.exif
IN_FILE=${1:-input.tif}
IN_PATH=$(dirname ${IN_FILE})
IN_NAME=$(basename ${IN_FILE%.*})
QUALITY=${2:-24} # originally 12 was the default
OUT_FILE=${3:-$IN_PATH/$IN_NAME-$QUALITY.heic}
# OUT_FILE_2=${3:-$IN_PATH/$IN_NAME-$QUALITY-2.heic}

echoparams() {
	echo -e "\n"
	echo -e "📥 \$1 IN_FILE:  ${IN_FILE}"
	echo -e "🌈 \$2 QUALITY:  ${QUALITY}"
	echo -e "📤 \$3 OUT_FILE: ${OUT_FILE}"
	echo -e "\n"	
}

generateconfig() {
	# generate config file needed by writerapp
	perl -pe "s|output.heic|${OUT_FILE}|g" config.json > $TEMP_CFG
}

generatethumblessconfig() {
	# generate config file needed by writerapp
	perl -pe "s|output.heic|${OUT_FILE}|g" config-thumbless.json > $TEMP_CFG
}


cleanup() {
	[ -e ${TEMP_FILE} ] && rm ${TEMP_FILE}
	[ -e ${TEMP_THUMB} ] && rm ${TEMP_THUMB}
	[ -e ${TEMP_CFG} ] && rm ${TEMP_CFG}
	[ -e ${TEMP_EXIF} ] && rm ${TEMP_EXIF}
}

cleanup
echoparams
#generateconfig
generatethumblessconfig

./exiftool -o $TEMP_EXIF ${IN_FILE}
./ffmpeg -i ${IN_FILE} -crf ${QUALITY} -preset slower -pix_fmt yuv420p -f hevc $TEMP_FILE
# ./ffmpeg -i ${IN_FILE} -vf scale=320:240 -crf 28 -preset slower -pix_fmt yuv420p -f hevc $TEMP_THUMB
./writerapp $TEMP_CFG

# no idea how to append exif to heic
# cp $OUT_FILE $OUT_FILE_2
# ./mp4box -add-item $TEMP_EXIF:id=3 $OUT_FILE_2

cleanup
#open $OUT_FILE