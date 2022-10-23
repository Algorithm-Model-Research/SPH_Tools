ARG SECURITY_HACK_ARCHITECTURE_VERSION=latest

FROM kalilinux/kali-rolling

ENV DEBIAN_FRONTEND noninteractive
ENV PYTHON_VERSION="3"

ARG SECURITY_HACK_ARCHITECTURE_VERSION_GIT_BRANCH=master
ARG SECURITY_HACK_ARCHITECTURE_VERSION_GIT_COMMIT=HEAD

LABEL maintainer=ronaldsonbellande@gmail.com
LABEL SECURITY_HACK_architecture_github_branchtag=${SECURITY_HACK_ARCHITECTURE_VERSION_GIT_COMMIT}
LABEL SECURITY_HACK_architecture_github_commit=${SECURITY_HACK_ARCHITECTURE_VERSION_GIT_COMMIT}

# Ubuntu setup
RUN apt-get update -y
RUN apt-get upgrade -y

# RUN workspace and sourcing
WORKDIR ./
COPY requirements.txt .
COPY system_requirements.txt .
COPY repository_requirements.txt .

# Install dependencies for system
RUN apt-get update && apt-get install -y --no-install-recommends <system_requirements.txt \
  && apt-get upgrade -y \
  && apt-get clean

# Install python 3.8 and make primary 
RUN apt-get update && apt-get install -y \
  python3 python3-dev python3-pip python3-venv \
  && update-alternatives --install /usr/bin/python python /usr/bin/python3 1

# Pip install update 
RUN pip3 install --upgrade pip

# Install python libraries
RUN pip --no-cache-dir install -r requirements.txt

CMD ["/bin/bash"]
