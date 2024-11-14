# docker build -t proof-test .

latex -halt-on-error -interaction=nonstopmode -output-directory out examples/bussproofs.tex
pdflatex -halt-on-error -interaction=nonstopmode -output-directory out examples/bussproofs.tex
gs -sDEVICE=pngmono -r600 -o out/bussproofs.png out/bussproofs.pdf
dvisvgm --font-format=woff2 --bbox=preview --optimize -o out/bussproofs.svg out/bussproofs.dvi

latex -halt-on-error -interaction=nonstopmode -output-directory out examples/ebproof.tex
pdflatex -halt-on-error -interaction=nonstopmode -output-directory out examples/ebproof.tex
gs -sDEVICE=pngmono -r600 -o out/ebproof.png out/ebproof.pdf
dvisvgm --font-format=woff2 --bbox=preview --optimize -o out/ebproof.svg out/ebproof.dvi

latex -halt-on-error -interaction=nonstopmode -output-directory out examples/forest.tex
pdflatex -halt-on-error -interaction=nonstopmode -output-directory out examples/forest.tex
gs -sDEVICE=pngmono -r600 -o out/forest.png out/forest.pdf
dvisvgm --font-format=woff2 --bbox=preview --optimize -o out/forest.svg out/forest.dvi
