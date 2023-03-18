#!/bin/sh

docker run -it --rm \
	-v "$(pwd):/home/dclark/git/dotfiles.git" \
	--mount type=bind,src=/run/host-services/ssh-auth.sock,target=/run/host-services/ssh-auth.sock \
	-e SSH_AUTH_SOCK="/run/host-services/ssh-auth.sock" \
	-e LANG -e LC_CTYPE -e TERM -e COLORTERM -e TERM_PROGRAM -e TERM_PROGRAM_VERSION \
	dotfiles bash -c 'mkdir projects && cd projects && git clone ~/git/dotfiles.git dotfiles && dotfiles/install.sh; zsh'
