FROM docker:19-dind-rootless

RUN mkdir -p /usr/local/bin/
COPY crun-0.12.2.1-static-x86_64 /usr/local/bin/crun
