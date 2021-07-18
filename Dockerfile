FROM python:3.7-stretch

MAINTAINER Dustin Fischer <duasfi@gmail.com>

# Install latest python packaging tools
RUN pip install --no-cache-dir --upgrade pip

ARG uid=1000
ARG gid=$uid
ENV USER=app UID=$uid GID=$gid

# Setup app user, home dir
RUN groupadd --gid "${GID}" "${USER}" && \
    useradd --home-dir /app --create-home --shell /bin/bash --uid ${UID} --gid ${GID} app


# copy code and set ownership
COPY --chown=app:app . /app/code

WORKDIR /app/code
# Pip install server libs
RUN pip install --no-cache-dir gunicorn~=20.0.4
RUN pip install -r requirements.txt
ENTRYPOINT ["gunicorn", "-b", ":8080", "main:APP"]
