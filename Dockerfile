FROM docker:19

ENV DOCKER_COMPOSE_VERSION 1.8.0
ENV COMPOSE_API_VERSION=1.18

# https://github.com/docker/docker/blob/master/project/PACKAGERS.md#runtime-dependencies
COPY dockerd-entrypoint.sh /usr/local/bin/

RUN apk add --no-cache \
		btrfs-progs \
		e2fsprogs \
		e2fsprogs-extra \
		iptables \
		xfsprogs \
		xz \
		py-pip \
		openssh \
		nano \
		git
		
# build docker-compose
RUN pip install --upgrade pip \
	&& pip install -U docker-compose==${DOCKER_COMPOSE_VERSION} \
	&& rm -rf /root/.cache

# disable password auth - a no-go in any case
# sed => remove lock status of root account
RUN echo "PermitRootLogin prohibit-password" >> /etc/ssh/sshd_config && \
  echo "PasswordAuthentication no" >> /etc/ssh/sshd_config && \
  echo "ClientAliveInterval 120" >> /etc/ssh/sshd_config && \  
  echo "ClientAliveCountMax 720" >> /etc/ssh/sshd_config && \
  sed -i -e "s/^root:[^:]\+:/root:$pass:/" /etc/shadow

RUN mkdir -p /root/.ssh/
COPY ash-profile /etc/profile

EXPOSE 22

CMD [ "dockerd-entrypoint.sh" ]
