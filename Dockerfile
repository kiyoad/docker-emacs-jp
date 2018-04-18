FROM ubuntu:xenial

RUN DEBIAN_FRONTEND=noninteractive \
  export emacs=25.3 && \
  echo "deb http://ftp.riken.jp/Linux/ubuntu/ xenial main multiverse" >> /etc/apt/sources.list && \
  echo "deb-src http://ftp.riken.jp/Linux/ubuntu/ xenial main multiverse" >> /etc/apt/sources.list && \
  apt-get update && apt-get upgrade -y && \
  apt-get install --no-install-recommends -qy gcc make xz-utils wget bsdmainutils ssh ca-certificates && \
  apt-get install --no-install-recommends -qy libtinfo-dev libx11-dev libxaw7-dev libgif-dev libjpeg-turbo8-dev libpng12-dev libtiff5-dev libxml2-dev librsvg2-dev libxft-dev libxpm-dev libgpm-dev libsm-dev libice-dev libxrandr-dev libxinerama-dev libgnutls-dev libmagickwand-dev xaw3dg-dev libdbus-1-dev libgconf2-dev libotf-dev libm17n-dev libncurses5-dev && \
  apt-get install --no-install-recommends -qy aspell aspell-en wamerican && \
  apt-get install --no-install-recommends -qy cmigemo exuberant-ctags silversearcher-ag && \
  apt-get install --no-install-recommends -qy fonts-takao fonts-takao-gothic fonts-takao-mincho fonts-takao-pgothic && \
  apt-get install --no-install-recommends -qy sdic sdic-edict sdic-gene95 && \
  wget -q -O - http://ftpmirror.gnu.org/emacs/emacs-${emacs}.tar.xz | tar xJf - && \
  mv emacs-${emacs} .build_emacs && \
  (cd .build_emacs && ./configure && make install) && \
  rm -rf .build_emacs && \
  rm -rf /var/lib/apt/lists/*

RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update && apt-get upgrade -y && \
  apt-get install --no-install-recommends -qy tidy xmlstarlet libxml2-utils && \
  rm -rf /var/lib/apt/lists/*

RUN \
  wget -q -O - https://storage.googleapis.com/shellcheck/shellcheck-latest.linux.x86_64.tar.xz | tar xJf - && \
  cp shellcheck-latest/shellcheck /usr/local/bin/shellcheck && \
  chown root:root /usr/local/bin/shellcheck && \
  chmod a+x /usr/local/bin/shellcheck && \
  rm -rf shellcheck-latest

RUN \
  export hadolint=1.6.2 && \
  wget -q -O /usr/local/bin/hadolint https://github.com/hadolint/hadolint/releases/download/v${hadolint}/hadolint-Linux-x86_64 && \
  chmod a+x /usr/local/bin/hadolint

RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update && apt-get upgrade -y && \
  apt-get install --no-install-recommends -qy python3-pip python3-setuptools && \
  rm -rf /var/lib/apt/lists/* && \
  pip3 install wheel && \
  pip3 install virtualenv flake8 pygments diff-highlight pylint proselint

RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update && apt-get upgrade -y && \
  apt-get install --no-install-recommends -qy ruby2.3-dev && \
  rm -rf /var/lib/apt/lists/* && \
  gem install -N mdl rubocop reek ruby-lint sqlint scss_lint

RUN \
  export node=8.11.1 && \
  wget -q -O - https://nodejs.org/dist/v${node}/node-v${node}-linux-x64.tar.xz | tar -C /usr/local -xJf - && \
  chown -R root:root /usr/local/node-v${node}-linux-x64 && \
  export PATH=/usr/local/node-v${node}-linux-x64/bin:${PATH} && \
  npm install -g --production handlebars && \
  npm install -g --production eslint && \
  npm install -g --production jshint && \
  npm install -g --production standard && \
  npm install -g --production markdownlint && \
  npm install -g --production markdownlint-cli && \
  npm install -g --production csslint && \
  npm install -g --production stylelint && \
  npm install -g --production jsonlint && \
  npm install -g --production less && \
  npm install -g --production sass-lint && \
  npm install -g --production js-yaml && \
  npm install -g --production textlint && \
  npm install -g --production textlint-rule-prh && \
  npm install -g --production textlint-rule-spellcheck-tech-word && \
  npm install -g --production textlint-rule-preset-ja-technical-writing && \
  npm install -g --production textlint-filter-rule-comments && \
  (cd /usr/local/node-v${node}-linux-x64 && find bin -xtype f -exec ln -s /usr/local/node-v${node}-linux-x64/{} /usr/local/{} \;)

RUN \
  export global=6.6.2 && \
  wget -q -O - http://ftpmirror.gnu.org/global/global-${global}.tar.gz | tar zxf - && \
  mv global-${global} .build_global && \
  (cd .build_global && PYTHON=/usr/bin/python3 ./configure --with-exuberant-ctags=/usr/bin/ctags-exuberant && make install) && \
  cp /usr/local/share/gtags/gtags.conf /etc/gtags.conf && \
  rm -rf .build_global

RUN DEBIAN_FRONTEND=noninteractive \
  export git=2.17.0 && \
  apt-get update && apt-get upgrade -y && \
  apt-get install --no-install-recommends -qy gettext && \
  apt-get install --no-install-recommends -qy libssl-dev libcurl4-openssl-dev libexpat1-dev && \
  wget -q -O - https://www.kernel.org/pub/software/scm/git/git-${git}.tar.xz | tar xJf - && \
  mv git-${git} .build_git && \
  (cd .build_git && make prefix=/usr/local NO_TCLTK=NoThanks install && cd contrib/completion && cp git-completion.bash git-prompt.sh /opt) && \
  rm -rf .build_git && \
  rm -rf /var/lib/apt/lists/*

ENV GOPATH /opt/go
RUN \
  export golang=1.10.1 && \
  wget -q -O - https://storage.googleapis.com/golang/go${golang}.linux-amd64.tar.gz | tar -C /usr/local -zxf  - && \
  mkdir /opt/go && \
  export PATH=$PATH:/usr/local/go/bin && \
  go get -u github.com/rogpeppe/godef && \
  go get -u github.com/nsf/gocode && \
  go get -u github.com/dougm/goflymake && \
  go get -u github.com/jstemmer/gotags && \
  go get -u github.com/alecthomas/gometalinter && \
  /opt/go/bin/gometalinter --install && \
  (cd /usr/local/go && find bin -type f -exec ln -s /usr/local/go/{} /usr/local/{} \;) && \
  (cd /opt/go && find bin -type f -exec ln -s /opt/go/{} /usr/local/{} \;)

# https://ipafont.ipa.go.jp/old/ipafont/download.html
COPY ipagp.ttf /opt/ipagp.ttf
RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update && apt-get upgrade -y && \
  apt-get install --no-install-recommends -qy pandoc ruby openjdk-8-jre graphviz && \
  rm -rf /var/lib/apt/lists/* && \
  gem install -N asciidoctor && \
  gem install -N --pre asciidoctor-pdf && \
  gem install -N coderay && \
  gem install -N asciidoctor-pdf-cjk && \
  gem install -N asciidoctor-diagram && \
  export asciidoctor_pdf_data_path=$(find /var/lib/gems -maxdepth 3 -name "asciidoctor-pdf-[0-9]*" | grep -F "gems/asciidoctor-pdf")/data && \
  sed -i.bak -e "/^  catalog:/a\    IPA PGothic:\n      normal: ipagp.ttf\n      bold: ipagp.ttf\n      italic: ipagp.ttf\n      bold_italic: ipagp.ttf" \
  -e "s/    - M+ 1p Fallback/    - IPA PGothic/1" ${asciidoctor_pdf_data_path}/themes/default-theme.yml && \
  cp /opt/ipagp.ttf ${asciidoctor_pdf_data_path}/fonts/ipagp.ttf

COPY my-adoc.sh my-adoc-pdf.sh /usr/local/bin/

ARG INSTALL_USER=developer
ARG UID=1000

RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update && apt-get upgrade -y && \
  apt-get install --no-install-recommends -qy language-pack-ja tzdata sudo && \
  rm -rf /var/lib/apt/lists/* && \
  echo "lang en_US" > /etc/aspell.conf && \
  update-locale LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja" && \
  cp -p /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
  echo "Asia/Tokyo" > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata && \
  adduser --disabled-password --gecos "Developer" --uid ${UID} ${INSTALL_USER} && \
  chown -R ${INSTALL_USER}:${INSTALL_USER} /home/${INSTALL_USER} && \
  echo "${INSTALL_USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${INSTALL_USER} && \
  chmod 0440 /etc/sudoers.d/${INSTALL_USER}

ENV LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja" SHELL=/bin/bash TERM=xterm-256color

USER ${INSTALL_USER}
WORKDIR /home/${INSTALL_USER}
ENTRYPOINT [ "/usr/local/bin/emacs" ]
