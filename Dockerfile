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
