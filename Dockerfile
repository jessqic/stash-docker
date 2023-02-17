FROM stashapp/stash:v0.19.0 as stash

FROM python:3.11
COPY --from=stash /usr/bin/stash /usr/bin/stash

RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get install -y ffmpeg libvips-tools
