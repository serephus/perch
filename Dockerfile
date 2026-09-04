FROM docker.io/alpine:3.22

LABEL \
  "name"="Perch" \
  "repository"="https://github.com/serephus/perch" \
  "maintainer"="serephus <i@sereph.us>"

RUN apk add --no-cache \
			bash \
			git \
			openssh-client && \
		echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config

ADD entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
