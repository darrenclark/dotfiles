FROM ubuntu:latest

RUN apt-get update && apt-get install -y git zsh neovim sudo language-pack-en

RUN mkdir -p /usr/local/opt/kube-ps1 && \
	git clone https://github.com/jonmosco/kube-ps1 /usr/local/opt/kube-ps1/share

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN useradd -rm -d /home/dclark -s /bin/zsh -g root -G sudo -u 1000 dclark
USER dclark
WORKDIR /home/dclark

RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.7.6

COPY ./.zshenv /home/dclark/.zshenv

CMD /bin/zsh
