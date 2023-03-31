# syntax=docker/dockerfile:1
FROM stashapp/stash:v0.20.1 as stash

FROM python:3.11
COPY --from=stash /usr/bin/stash /usr/bin/stash

# RUN printf "\ndeb https://deb.debian.org/debian bullseye contrib non-free\ndeb https://deb.debian.org/debian bookworm main\n" >> "/etc/apt/sources.list.d/debian-extended.list"
RUN printf "deb https://deb.debian.org/debian bookworm main\n" >> "/etc/apt/sources.list.d/debian-extended.list"
RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  apt update && apt-get -t testing --no-install-recommends install -y ffmpeg libvips-tools

ENV STASH_CONFIG_FILE=/config/config.yml
ENV STASH_GENERATED=/generated/
ENV STASH_METADATA=/metadata/
ENV STASH_CACHE=/cache/

RUN python -m venv /venv
ENV PATH=/venv/bin:$PATH
RUN --mount=type=cache,target=/root/.cache/pip \
  pip install --upgrade pip && \
  pip install bs4 cloudscraper lxml pystashlib orjson

CMD ["stash"]
