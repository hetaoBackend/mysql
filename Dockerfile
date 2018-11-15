# https://hub.docker.com/r/library/mysql/
FROM mysql:5.7.23
LABEL maintainer="taoshibo@shannonai.com"

# Never prompts the user for choices on installation/configuration of packages
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

# Change Timezone
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Use aliyun source
RUN sed -i 's/http:\/\/deb\.debian\.org\/debian/http:\/\/mirrors\.aliyun\.com\/debian/g' /etc/apt/sources.list
RUN sed -i 's/http:\/\/security\.debian\.org\/debian-security/http:\/\/mirrors\.aliyun\.com\/debian-security/g' /etc/apt/sources.list

RUN set -ex \
    && apt-get update -yqq \
    && apt-get install -yqq --no-install-recommends \
        apt-utils \
        bash \
        netcat \
        locales \
        ca-certificates \
        iputils-ping \
        net-tools \
        netcat \
    && sed -i 's/^# en_US.UTF-8 UTF-8$/en_US.UTF-8 UTF-8/g' /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
    && apt-get autoremove -yqq --purge \
    && apt-get clean \
    && rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base

# Define en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LC_MESSAGES en_US.UTF-8

# Create user work
ARG USER=work
ARG USER_HOME=/home/${USER}
RUN useradd -ms /bin/bash -d ${USER_HOME} ${USER} \
    && usermod -u 3000 ${USER} \
    && groupmod -g 3000 ${USER} \
    && echo "!includedir /home/work/conf/" >> /etc/mysql/my.cnf

COPY bashrc /etc/bash.bashrc
COPY bashrc /home/work/.bashrc
RUN chown -R work:work /home/work

USER ${USER}
WORKDIR /home/${USER}
