# docker build -t proof-test .
# docker run --entrypoint=sh -ti ebproof-test
# exit
# docker cp container_name:app/proof1.png .

# ref: https://tex.stackexchange.com/questions/268997

# latex -halt-on-error -interaction=nonstopmode -output-directory out ebproof.tex
# pdflatex -output-directory out ebproof.tex
# dvipng -D 600 -o out/ebproof.png out/ebproof.dvi
# dvisvgm --no-fonts --bbox=preview -o out/ebproof.svg out/ebproof.dvi

# latex -halt-on-error -interaction=nonstopmode -output-directory out forest.tex
# dvisvgm --no-fonts --bbox=preview -o out/forest.svg out/forest.dvi

FROM alpine:latest AS installer
RUN apk add --no-cache perl tar wget
WORKDIR /install-tl-unx
RUN wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
RUN tar xvzf ./install-tl-unx.tar.gz --strip-components=1
COPY texlive.profile .
RUN ./install-tl --profile=texlive.profile
RUN ln -sf /usr/local/texlive/*/bin/* /usr/local/bin/texlive
ENV PATH=/usr/local/bin/texlive:$PATH
RUN tlmgr install \
  amsfonts \
  bussproofs \
  cbfonts-fd \
  dvipng \
  dvips \
  dvisvgm \
  ebproof \
  forest \
  greek-fontenc \
  latex-bin \
  lplfitch \
  preview \
  standalone \
  tools \
  varwidth \
  xkeyval

FROM scratch
COPY --from=installer /usr/local/texlive /usr/local/texlive

# FROM alpine:latest
# RUN apk add --no-cache imagemagick ghostscript
# COPY --from=installer /usr/local/texlive /usr/local/texlive
# RUN ln -sf /usr/local/texlive/*/bin/* /usr/local/bin/texlive
# ENV PATH=/usr/local/bin/texlive:$PATH
# CMD [ "sleep", "infinity" ]
