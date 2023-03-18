FROM ubuntu:latest

RUN apt-get update && apt-get install sudo zsh git -y

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN useradd -rm -d /home/dclark -s /bin/zsh -g root -G sudo -u 1000 dclark
USER dclark
WORKDIR /home/dclark

CMD /bin/bash
