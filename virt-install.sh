#!/bin/ash
# https://github.com/sundaqiang/alpine-qinglong

#开启ssh、替换为bash
sed -i "s/#PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config \
&& sed -i 's/root:x:0:0:root:\/root:\/bin\/ash/root:x:0:0:root:\/root:\/bin\/bash/g' /etc/passwd \
&& service sshd restart

#修改默认源
sed -i '2,$d' /etc/apk/repositories \
&& echo http://mirrors.aliyun.com/alpine/v3.15/main/ >> /etc/apk/repositories \
&& echo http://mirrors.aliyun.com/alpine/v3.15/community/ >> /etc/apk/repositories

#安装系统依赖
apk update -f \
&& apk upgrade \
&& apk --no-cache add -f bash \
						 coreutils \
						 moreutils \
						 git \
						 curl \
						 wget \
						 tzdata \
						 perl \
						 openssl \
						 nginx \
						 nodejs \
						 npm \
						 python3 \
						 jq \
						 openssh \
						 py3-pip \
						 python2 \
						 g++ \
						 make
rm -rf /var/cache/apk/*

#修改npm和pip镜像源
pip config set global.index-url http://mirrors.aliyun.com/pypi/simple/ \
&& pip config set install.trusted-host mirrors.aliyun.com \
&& npm config set registry https://registry.npmmirror.com

#其他设置
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
&& echo "Asia/Shanghai" > /etc/timezone \
&& touch ~/.bashrc

#安装qinglong
QL_MAINTAINER="whyour"
QL_URL=https://github.com/${QL_MAINTAINER}/qinglong.git
QL_BRANCH=master
QL_DIR=/ql
rm -rf ${QL_DIR}
git clone -b ${QL_BRANCH} ${QL_URL} ${QL_DIR} \
&& git config --global user.email "qinglong@@users.noreply.github.com" \
&& git config --global user.name "qinglong" \
&& cd ${QL_DIR} \
&& cp -f .env.example .env \
&& chmod 777 ${QL_DIR}/shell/*.sh \
&& chmod 777 ${QL_DIR}/docker/*.sh \
&& npm install -g pnpm \
&& pnpm install -g pm2 \
&& pnpm install -g ts-node typescript tslib \
&& rm -rf /root/.npm \
&& pnpm install --prod \
&& rm -rf /root/.pnpm-store \
&& git clone -b ${QL_BRANCH} https://github.com/${QL_MAINTAINER}/qinglong-static.git /static \
&& cp -rf /static/* ${QL_DIR} \
&& rm -rf /static

#配置启动项
echo 'cd /ql' > /etc/local.d/QL.start \
&& echo 'rm -rf /var/cache/apk/*' >> /etc/local.d/QL.start \
&& echo 'rm -rf /root/.npm' >> /etc/local.d/QL.start \
&& echo 'rm -rf /root/.pnpm-store' >> /etc/local.d/QL.start \
&& echo 'rm -rf /root/.cache' >> /etc/local.d/QL.start \
&& echo 'rm -rf /usr/x86_64-alpine-linux-musl' >> /etc/local.d/QL.start \
&& echo './docker/docker-entrypoint.sh &' >> /etc/local.d/QL.start
chmod +x /etc/local.d/QL.start
rc-update add local

#启动qinglong
./docker/docker-entrypoint.sh
