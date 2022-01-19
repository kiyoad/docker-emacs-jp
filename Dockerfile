FROM ubuntu:focal

RUN \
apt-get update && \
yes | unminimize && \
DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -q -y language-pack-ja tzdata sudo man-db manpages manpages-dev && \
rm -rf /var/lib/apt/lists/* /tmp/* && \
update-locale LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja" && \
cp -p /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
echo "Asia/Tokyo" > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata

ENV LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN \
  : version && emacs=27.2 && \
  export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && \
  apt-get install --no-install-recommends -q -y gcc make xz-utils wget bsdmainutils ssh ca-certificates fonts-ricty-diminished && \
  apt-get install --no-install-recommends -q -y libtinfo-dev libx11-dev libxaw7-dev libgif-dev libjpeg-turbo8-dev libpng-dev libtiff5-dev libxml2-dev libxft-dev libxpm-dev libgpm-dev libsm-dev libice-dev libxrandr-dev libxinerama-dev xaw3dg-dev libdbus-1-dev libgconf2-dev libotf-dev libm17n-dev libncurses5-dev libacl1-dev libselinux1-dev libsystemd-dev libgnutls28-dev liblcms2-dev librsvg2-dev && \
  apt-get install --no-install-recommends -q -y aspell aspell-en wamerican && \
  apt-get install --no-install-recommends -q -y cmigemo exuberant-ctags silversearcher-ag && \
  apt-get install --no-install-recommends -q -y sdic sdic-edict sdic-gene95 && \
  wget -q -O - http://ftpmirror.gnu.org/emacs/emacs-${emacs}.tar.xz | tar xJf - && \
  mv emacs-${emacs} .build_emacs && \
  (cd .build_emacs && ./configure --with-x-toolkit=lucid && make install) && \
  rm -rf .build_emacs && \
  rm -rf /var/lib/apt/lists/* /tmp/*

RUN \
  export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && \
  apt-get install -q -y git && \
  rm -rf /var/lib/apt/lists/* /tmp/* && \
  wget -q -O /opt/git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash && \
  wget -q -O /opt/git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

RUN \
  export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && \
  apt-get install -q -y cmake g++ clang-tools-8 libclang-8-dev zlib1g-dev libncurses-dev && \
  git clone --depth=1 --recursive https://github.com/MaskRay/ccls && \
  (cd ccls && cmake -H. -BRelease -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=/usr/lib/llvm-8 -DLLVM_INCLUDE_DIR=/usr/lib/llvm-8/include && cmake --build Release --target install) && \
  rm -rf ccls && \
  rm -rf /var/lib/apt/lists/* /tmp/*

RUN \
  export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && \
  apt-get install --no-install-recommends -q -y tidy xmlstarlet libxml2-utils && \
  rm -rf /var/lib/apt/lists/* /tmp/*

RUN \
  wget -q -O - https://storage.googleapis.com/shellcheck/shellcheck-latest.linux.x86_64.tar.xz | tar xJf - && \
  cp shellcheck-latest/shellcheck /usr/local/bin/shellcheck && \
  chown root:root /usr/local/bin/shellcheck && \
  chmod a+x /usr/local/bin/shellcheck && \
  rm -rf shellcheck-latest

RUN \
  : version && hadolint=2.8.0 && \
  wget -q -O /usr/local/bin/hadolint https://github.com/hadolint/hadolint/releases/download/v${hadolint}/hadolint-Linux-x86_64 && \
  chmod a+x /usr/local/bin/hadolint

RUN \
  export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && \
  apt-get install --no-install-recommends -q -y python3-pip python3-setuptools && \
  rm -rf /var/lib/apt/lists/* /tmp/* && \
  pip3 install wheel && \
  pip3 install Pygments flake8 diff-highlight pylint mypy proselint 'python-language-server[all]' && \
  rm -rf /root/.cache

RUN \
  export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && \
  apt-get install --no-install-recommends -q -y ruby-dev && \
  rm -rf /var/lib/apt/lists/* /tmp/* && \
  gem install -N mdl rubocop reek ruby-lint sqlint scss_lint solargraph && \
  rm -rf /root/.gem

RUN \
  : version && node=16.13.2 && \
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
  npm install -g --production postcss-syntax@^0.10.0 postcss stylelint && \
  npm install -g --production jsonlint && \
  npm install -g --production less && \
  npm install -g --production sass-lint && \
  npm install -g --production js-yaml && \
  npm install -g --production textlint && \
  npm install -g --production textlint-rule-prh && \
  npm install -g --production textlint-rule-spellcheck-tech-word && \
  npm install -g --production textlint-rule-preset-ja-technical-writing && \
  npm install -g --production textlint-filter-rule-comments && \
  npm install -g --production vscode-css-languageserver-bin && \
  npm install -g --production vscode-html-languageserver-bin && \
  npm install -g --production typescript-language-server && \
  npm install -g --production typescript && \
  npm install -g --production intelephense && \
  npm install --unsafe-perm -g --production bash-language-server && \
  npm install -g --production dockerfile-language-server-nodejs && \
  npm install -g --production vscode-json-languageserver && \
  npm install -g --production yaml-language-server && \
  (cd /usr/local/node-v${node}-linux-x64 && find bin -xtype f -exec ln -s /usr/local/node-v${node}-linux-x64/{} /usr/local/{} \;) && \
  rm -rf /root/.npm /root/.config

RUN \
  : version && global=6.6.8 && \
  wget -q -O - http://ftpmirror.gnu.org/global/global-${global}.tar.gz | tar zxf - && \
  mv global-${global} .build_global && \
  (cd .build_global && PYTHON=/usr/bin/python3 ./configure --with-exuberant-ctags=/usr/bin/ctags-exuberant && make install) && \
  cp /usr/local/share/gtags/gtags.conf /etc/gtags.conf && \
  rm -rf .build_global

RUN \
  : version && golang=1.17.6 && \
  wget -q -O - https://storage.googleapis.com/golang/go${golang}.linux-amd64.tar.gz | tar -C /usr/local -zxf  - && \
  mkdir /opt/go && \
  export GOPATH=/opt/go && \
  export PATH=$PATH:/usr/local/go/bin && \
  GO111MODULE=on go install golang.org/x/tools/gopls@latest && \
  (cd /usr/local/go && find bin -type f -exec ln -s /usr/local/go/{} /usr/local/{} \;) && \
  (cd /opt/go && find bin -type f -exec ln -s /opt/go/{} /usr/local/{} \;) && \
  rm -rf /root/.cache

COPY bootstrap.sh /usr/local/sbin/
ENTRYPOINT [ "/usr/local/sbin/bootstrap.sh" ]
