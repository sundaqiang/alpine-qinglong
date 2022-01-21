#!/bin/ash
# https://github.com/sundaqiang/alpine-qinglong

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

#设置环境变量
export LANG=UTF-8
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export SHELL=/bin/bash
export PS1="\u@\h:\w \$ "

#修改npm和pip镜像源
pip config set global.index-url http://mirrors.aliyun.com/pypi/simple/ \
&& pip config set install.trusted-host mirrors.aliyun.com \
&& npm config set registry http://registry.npm.taobao.org/

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
echo '#!/bin/bash' > /start.sh \
&& echo '# https://github.com/sundaqiang/alpine-qinglong' >> /start.sh \
&& echo '' >> /start.sh \
&& echo 'export LANG=UTF-8' >> /start.sh \
&& echo 'export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin' >> /start.sh \
&& echo 'export SHELL=/bin/bash' >> /start.sh \
&& echo 'export PS1="\u@\h:\w \$ "' >> /start.sh \
&& echo 'cd /ql' >> /start.sh \
&& echo 'rm -rf /var/cache/apk/*' >> /start.sh \
&& echo 'rm -rf /root/.npm' >> /start.sh \
&& echo 'rm -rf /root/.cache' >> /start.sh \
&& echo 'rm -rf /usr/x86_64-alpine-linux-musl' >> /start.sh \
&& echo 'nohup ./docker/docker-entrypoint.sh &' >> /start.sh
chmod +x /start.sh

#启动qinglong
./docker/docker-entrypoint.sh