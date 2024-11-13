# docker build -t proof-test .

latex -halt-on-error -interaction=nonstopmode -output-directory out examples/bussproofs.tex
pdflatex -halt-on-error -interaction=nonstopmode -output-directory out examples/bussproofs.tex
dvipng -D 600 -o out/bussproofs.png out/bussproofs.dvi
dvisvgm --font-format=woff --bbox=preview -o out/bussproofs.svg out/bussproofs.dvi

latex -halt-on-error -interaction=nonstopmode -output-directory out examples/ebproof.tex
pdflatex -halt-on-error -interaction=nonstopmode -output-directory out examples/ebproof.tex
dvipng -D 600 -o out/ebproof.png out/ebproof.dvi
dvisvgm --font-format=woff --bbox=preview -o out/ebproof.svg out/ebproof.dvi

latex -halt-on-error -interaction=nonstopmode -output-directory out examples/forest.tex
pdflatex -halt-on-error -interaction=nonstopmode -output-directory out examples/forest.tex
dvipng -D 600 -o out/forest.png out/forest.dvi
dvisvgm --font-format=woff --bbox=preview -o out/forest.svg out/forest.dvi
