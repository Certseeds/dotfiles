readonly __TEXLIVE_VERSION
export MANPATH="${MANPATH}":/usr/local/texlive/"${__TEXLIVE_VERSION}"/texmf-dist/doc/man
export INFOPATH="${INFOPATH}":/usr/local/texlive/"${__TEXLIVE_VERSION}"/texmf-dist/doc/info
export PATH="${PATH}":/usr/local/texlive/"${__TEXLIVE_VERSION}"/bin/x86_64-linux
unset __TEXLIVE_VERSION