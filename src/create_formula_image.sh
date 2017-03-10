#!/bin/bash
set -euxo pipefail

cd "$1"
FORMULA="$2" envsubst < template.tex > target.tex
pdflatex -halt-on-error target.tex
pdfcrop target.pdf target-crop.pdf
convert -density 1000 -background white -alpha remove target-crop.pdf result.png
file result.png | grep "PNG image data"
