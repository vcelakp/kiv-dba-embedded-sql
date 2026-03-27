FROM debian:13-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      bash \
      bash-completion \
      ca-certificates \
      file \
      gcc \
      g++ \
      libc6-dev \
      libaio1t64 \
      locales \
      make \
      procps \
      mc \
      libcom-err2 \
      unzip \
      nano \
      vim \
      less \
 && ln -s /lib/x86_64-linux-gnu/libaio.so.1t64 /lib/x86_64-linux-gnu/libaio.so.1 \
 && ldconfig \
 && sed -i 's/^# cs_CZ.UTF-8 UTF-8/cs_CZ.UTF-8 UTF-8/' /etc/locale.gen \
 && locale-gen \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/oracle

# First, you have to download Oracle packages for linux and x64 architecture in ZIP format.
#   instantclient-basic-linux.x64-*.zip
#   instantclient-sdk-linux.x64-*.zip
#   instantclient-precomp-linux.x64-*.zip
COPY instantclient-basic-linux.x64-*.zip /tmp/
COPY instantclient-sdk-linux.x64-*.zip /tmp/
COPY instantclient-precomp-linux.x64-*.zip /tmp/

RUN unzip /tmp/instantclient-basic-linux.x64-*.zip -d /opt/oracle \
 && unzip /tmp/instantclient-sdk-linux.x64-*.zip -d /opt/oracle \
 && unzip /tmp/instantclient-precomp-linux.x64-*.zip -d /opt/oracle \
 && ic_dir="$(find /opt/oracle -mindepth 1 -maxdepth 1 -type d -name 'instantclient_*' | sort | tail -n 1)" \
 && test -n "$ic_dir" \
 && ln -s "$ic_dir" /opt/oracle/instantclient \
 && if [ "$ic_dir" != "/opt/oracle/instantclient_21_12" ]; then ln -s "$ic_dir" /opt/oracle/instantclient_21_12; fi \
 && rm -f /tmp/instantclient-*.zip

ENV ORACLE_HOME=/opt/oracle/instantclient_21_12
ENV PATH=${ORACLE_HOME}:${ORACLE_HOME}/sdk:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV LD_LIBRARY_PATH=${ORACLE_HOME}
ENV LANG=cs_CZ.UTF-8
ENV LC_ALL=cs_CZ.UTF-8
ENV NLS_LANG=CZECH_CZECH\ REPUBLIC.AL32UTF8

COPY proc-vim-syntax/ /usr/share/vim/vimfiles/
COPY bashrc /etc/bash.bashrc

WORKDIR /embedded-sql
RUN mkdir -p /embedded-sql/examples
COPY ./examples /embedded-sql/examples/
COPY ./Makefile /embedded-sql/
COPY ./embedded-sql-*.sh ./env.sh ./docker-entrypoint.sh /embedded-sql/

CMD ["/bin/bash"]
