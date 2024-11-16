# docker build -t proof-test .

rm out/*

for texfile in examples/*.tex; do
    name=$(basename "$texfile" .tex)
    latex -halt-on-error -interaction=nonstopmode -output-directory out "$texfile"
    dvisvgm --bbox=preview --bitmap-format=none --font-format=woff2 --optimize --relative -o "out/${name}.svg" "out/${name}.dvi"
    pdflatex -halt-on-error -interaction=nonstopmode -output-directory out "$texfile"
    gs -dBATCH -dNOPAUSE -r600 -sDEVICE=pngmono -o "out/${name}.png" "out/${name}.pdf"
    gs -dBATCH -dCompatibilityLevel=1.5 -dNOPAUSE -sDEVICE=pdfwrite -o "out/${name}_comp.pdf" "out/${name}.pdf"
    mv "out/${name}_comp.pdf" "out/${name}.pdf" 
done

rm out/*.aux out/*.dvi out/*.log
