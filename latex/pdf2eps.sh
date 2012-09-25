#!/bin/sh

echo "This script assumes that the pdf file is created by exporting from e.g. Open Office"
echo "This means that the fonts are actually embedded (check with pdffonts)."

if [ $# -ne 1 ]
then
  echo "Type the file name to be copied (without extension)"
  read FILENAME
else
  FILENAME=${1%.pdf}
fi


pdftops -eps $FILENAME.pdf - | ps2eps > $FILENAME.eps

cat $FILENAME.eps | grep "%%BoundingBox" > $FILENAME.bb.eps

SHIFTX=`cat $FILENAME.bb.eps | sed 's/\([^ ]*\) \([^ ]*\).*/\2/'`
SHIFTY=`cat $FILENAME.bb.eps | sed 's/\([^ ]*\) \([^ ]*\) \([^ ]*\).*/\3/'`
echo "Shifts bounding border with $SHIFTX and $SHIFTY for proper embedding by the latex tool"
echo "Use ps2eps instead, if you want only to show it directly in an image viewer."

ps2eps --translate=-$SHIFTX,-$SHIFTY $FILENAME.eps 

rm $FILENAME.bb.eps
rm $FILENAME.eps
mv $FILENAME.eps.eps $FILENAME.eps

echo "Show output file:"
ls -latr | grep $FILENAME.eps

