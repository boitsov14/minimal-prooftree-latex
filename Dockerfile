# docker build -t ebproof-test .
# docker run --entrypoint=sh -ti ebproof-test
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
  dvipng \
  dvisvgm \
  ebproof \
  latex-bin \
  preview \
  standalone \
  varwidth \
  xkeyval

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
COPY --from=installer /usr/local/texlive/*/bin/x86_64-linuxmusl/dvisvgm                 /usr/local/texlive/bin/x86_64-linuxmusl/dvisvgm
COPY --from=installer /usr/local/texlive/*/bin/x86_64-linuxmusl/latex                   /usr/local/texlive/bin/x86_64-linuxmusl/latex
COPY --from=installer /usr/local/texlive/*/bin/x86_64-linuxmusl/pdflatex                /usr/local/texlive/bin/x86_64-linuxmusl/pdflatex

COPY --from=installer /lib/ld-musl-x86_64.so.1 /lib/ld-musl-x86_64.so.1

COPY --from=installer /usr/bin/pdftocairo /usr/bin/pdftocairo

COPY --from=installer /lib/ld-musl-x86_64.so.1 /lib/ld-musl-x86_64.so.1
COPY --from=installer /usr/lib/libcairo.so.2 /usr/lib/libcairo.so.2
COPY --from=installer /usr/lib/libfreetype.so.6 /usr/lib/libfreetype.so.6
COPY --from=installer /usr/lib/libpoppler.so.132 /usr/lib/libpoppler.so.132
COPY --from=installer /usr/lib/liblcms2.so.2 /usr/lib/liblcms2.so.2
COPY --from=installer /usr/lib/libstdc++.so.6 /usr/lib/libstdc++.so.6
COPY --from=installer /lib/ld-musl-x86_64.so.1 /lib/ld-musl-x86_64.so.1
COPY --from=installer /lib/libz.so.1 /lib/libz.so.1
COPY --from=installer /usr/lib/libpng16.so.16 /usr/lib/libpng16.so.16
COPY --from=installer /usr/lib/libfontconfig.so.1 /usr/lib/libfontconfig.so.1
COPY --from=installer /usr/lib/libX11.so.6 /usr/lib/libX11.so.6
COPY --from=installer /usr/lib/libXext.so.6 /usr/lib/libXext.so.6
COPY --from=installer /usr/lib/libXrender.so.1 /usr/lib/libXrender.so.1
COPY --from=installer /usr/lib/libxcb.so.1 /usr/lib/libxcb.so.1
COPY --from=installer /usr/lib/libxcb-render.so.0 /usr/lib/libxcb-render.so.0
COPY --from=installer /usr/lib/libxcb-shm.so.0 /usr/lib/libxcb-shm.so.0
COPY --from=installer /usr/lib/libpixman-1.so.0 /usr/lib/libpixman-1.so.0
COPY --from=installer /usr/lib/libbz2.so.1 /usr/lib/libbz2.so.1
COPY --from=installer /usr/lib/libbrotlidec.so.1 /usr/lib/libbrotlidec.so.1
COPY --from=installer /usr/lib/libjpeg.so.8 /usr/lib/libjpeg.so.8
COPY --from=installer /usr/lib/libopenjp2.so.7 /usr/lib/libopenjp2.so.7
COPY --from=installer /usr/lib/libtiff.so.6 /usr/lib/libtiff.so.6
COPY --from=installer /usr/lib/libsmime3.so /usr/lib/libsmime3.so
COPY --from=installer /usr/lib/libnss3.so /usr/lib/libnss3.so
COPY --from=installer /usr/lib/libplc4.so /usr/lib/libplc4.so
COPY --from=installer /usr/lib/libnspr4.so /usr/lib/libnspr4.so
COPY --from=installer /usr/lib/libgcc_s.so.1 /usr/lib/libgcc_s.so.1
COPY --from=installer /usr/lib/libexpat.so.1 /usr/lib/libexpat.so.1
COPY --from=installer /usr/lib/libXau.so.6 /usr/lib/libXau.so.6
COPY --from=installer /usr/lib/libXdmcp.so.6 /usr/lib/libXdmcp.so.6
COPY --from=installer /usr/lib/libbrotlicommon.so.1 /usr/lib/libbrotlicommon.so.1
COPY --from=installer /usr/lib/libzstd.so.1 /usr/lib/libzstd.so.1
COPY --from=installer /usr/lib/libwebp.so.7 /usr/lib/libwebp.so.7
COPY --from=installer /usr/lib/libnssutil3.so /usr/lib/libnssutil3.so
COPY --from=installer /usr/lib/libplds4.so /usr/lib/libplds4.so
COPY --from=installer /usr/lib/libbsd.so.0 /usr/lib/libbsd.so.0
COPY --from=installer /usr/lib/libsharpyuv.so.0 /usr/lib/libsharpyuv.so.0
COPY --from=installer /usr/lib/libmd.so.0 /usr/lib/libmd.so.0

# FROM scratch
FROM gcr.io/distroless/static-debian12:debug-nonroot
# FROM alpine:latest
# FROM debian:12-slim
COPY --from=installer2 /usr /usr
COPY --from=installer2 /lib /lib
ENV PATH=/usr/local/texlive/bin/x86_64-linuxmusl:$PATH
WORKDIR /app
COPY proof.tex .

# CMD [ "sleep", "infinity" ]
