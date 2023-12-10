# docker build -t ebproof-test .
# docker run --entrypoint=sh -ti ebproof-test
# exit
# docker cp container_name:app/proof1.png .

FROM alpine:latest AS installer
RUN apk add --no-cache perl poppler-utils tar wget
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
  dvipng \
  ebproof \
  latex-bin \
  preview \
  standalone \
  varwidth \
  xkeyval
RUN mkdir -p /bundle/usr/lib /bundle/lib
RUN ldd /usr/bin/pdftocairo | grep "=>" | awk '{print $3}' | xargs -I '{}' cp -L '{}' /bundle'{}'

FROM scratch AS installer2
COPY --from=installer /usr/local/texlive/*/texmf-var/web2c/pdftex/latex.fmt             /usr/local/texlive/texmf-var/web2c/pdftex/latex.fmt
COPY --from=installer /usr/local/texlive/*/texmf-var/web2c/pdftex/pdflatex.fmt          /usr/local/texlive/texmf-var/web2c/pdftex/pdflatex.fmt
COPY --from=installer /usr/local/texlive/*/texmf-var/ls-R                               /usr/local/texlive/texmf-var/ls-R
COPY --from=installer /usr/local/texlive/*/texmf-var/fonts/map/dvips/updmap/psfonts.map /usr/local/texlive/texmf-var/fonts/map/dvips/updmap/psfonts.map
COPY --from=installer /usr/local/texlive/*/texmf-var/fonts/map/pdftex/updmap/pdftex.map /usr/local/texlive/texmf-var/fonts/map/pdftex/updmap/pdftex.map
COPY --from=installer /usr/local/texlive/*/texmf-dist/fonts/tfm/public/cm               /usr/local/texlive/texmf-dist/fonts/tfm/public/cm
COPY --from=installer /usr/local/texlive/*/texmf-dist/fonts/type1/public/amsfonts/cm    /usr/local/texlive/texmf-dist/fonts/type1/public/amsfonts/cm
COPY --from=installer /usr/local/texlive/*/texmf-dist/ls-R                              /usr/local/texlive/texmf-dist/ls-R
COPY --from=installer /usr/local/texlive/*/texmf-dist/tex/generic/xkeyval               /usr/local/texlive/texmf-dist/tex/generic/xkeyval
COPY --from=installer /usr/local/texlive/*/texmf-dist/tex/latex                         /usr/local/texlive/texmf-dist/tex/latex
COPY --from=installer /usr/local/texlive/*/texmf-dist/web2c/texmf.cnf                   /usr/local/texlive/texmf-dist/web2c/texmf.cnf
COPY --from=installer /usr/local/texlive/*/bin/x86_64-linuxmusl/dvipng                  /usr/local/texlive/bin/x86_64-linuxmusl/dvipng
COPY --from=installer /usr/local/texlive/*/bin/x86_64-linuxmusl/latex                   /usr/local/texlive/bin/x86_64-linuxmusl/latex
COPY --from=installer /usr/local/texlive/*/bin/x86_64-linuxmusl/pdflatex                /usr/local/texlive/bin/x86_64-linuxmusl/pdflatex

COPY --from=installer /lib/ld-musl-x86_64.so.1 /lib/ld-musl-x86_64.so.1

COPY --from=installer /usr/bin/pdftocairo /usr/bin/pdftocairo
COPY --from=installer /bundle/ /.

FROM scratch
# FROM gcr.io/distroless/static-debian12:debug-nonroot
# FROM alpine:latest
# FROM debian:12-slim
COPY --from=installer2 /usr /usr
COPY --from=installer2 /lib /lib
ENV PATH=/usr/local/texlive/bin/x86_64-linuxmusl:$PATH
WORKDIR /app
COPY proof.tex .
