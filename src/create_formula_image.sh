#!/bin/bash
set -euxo pipefail

cd "$1"
FORMULA="$2" envsubst < template.tex > target.tex
pdflatex -halt-on-error target.tex
pdfcrop target.pdf target-crop.pdf
convert -density 1000 target-crop.pdf result.png
