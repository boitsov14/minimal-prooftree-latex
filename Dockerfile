# docker build -t minimal-prooftree-latex .

FROM alpine:latest AS installer
RUN apk --no-cache add perl tar wget
WORKDIR /install-tl-unx
RUN wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
RUN tar xvzf ./install-tl-unx.tar.gz --strip-components=1
COPY texlive.profile .
RUN ./install-tl --profile=texlive.profile
RUN ln -sf /usr/local/texlive/*/bin/* /usr/local/bin/texlive
ENV PATH=/usr/local/bin/texlive:$PATH
RUN tlmgr install bussproofs cbfonts-fd dvisvgm ebproof forest greek-fontenc lplfitch preview standalone varwidth

FROM scratch
COPY --from=installer /usr/local/texlive /usr/local/texlive

# FROM alpine:latest
# RUN apk --no-cache add ghostscript
# COPY --from=installer /usr/local/texlive /usr/local/texlive
# RUN ln -sf /usr/local/texlive/*/bin/* /usr/local/bin/texlive
# ENV PATH=/usr/local/bin/texlive:$PATH
# WORKDIR /app
# CMD [ "sleep", "infinity" ]
