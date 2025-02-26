# Path to your oh-my-zsh installation.
export ZSH=$HOME/.config/zsh/oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="steeef"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git asdf)

# User configuration

export PATH="/usr/local/bin:/usr/local/share/dotnet:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH=$HOME/.istioctl/bin:$PATH
export PATH=$HOME/go/bin:$PATH
# export MANPATH="/usr/local/man:$MANPATH"

# Some programs don't default to ~/.config so...
export XDG_CONFIG_HOME="$HOME/.config"

# Custom completions
fpath=($XDG_CONFIG_HOME/zsh/func/ $fpath)

# Load homebrew (if present)
[ -f /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

###
### Personal customization
###

export EDITOR='nvim'

export PATH=":$HOME/.rbenv/bin:$HOME/bin:$PATH"

alias g=git
alias b='bundle exec'
alias e=$EDITOR

# to "fix" git-diff output
export LESS="-F -X -R"

alias pretty-json='python -m json.tool'

#function pi_find_podfile_dir {
#	p="$(pwd)"
#	while [ "$p" != "/" ]; do
#		results="$(find "$p" -t f -maxdepth 1 -mindepth 1 "Podfile")"
#		if [ -z "$results" ]; then
#			echo "$(pwd)/$results"
#			break
#		fi
#	done
#}

function pi {
	last_fetch_date="$(cat ~/.last_pod_fetch_date 2>/dev/null)"
	current_date="$(date +%Y-%m-%d)"
	if [ "$current_date" != "$last_fetch_date" ]; then 
		echo -n "$current_date" > ~/.last_pod_fetch_date
		bundle exec pod install
	else
		COCOAPODS_DISABLE_STATS=1 bundle exec pod install --no-repo-update
	fi
}

alias kill_xcode="ps aux | grep -i xcode | awk '{ print \$2 }' | xargs -n 1 -- kill -9"
alias decimate_xcode="ps aux | grep -i xcode | awk '{ print \$2 }' | xargs -n 1 -- kill -9; rm -rf ~/Library/Developer/Xcode/DerivedData/"

function open_xcode {
	open "/Applications/Old Xcodes/Xcode-$1.app"
}

function burn_it_down {
	if [ -z "$1" ]; then
		echo "Please pass something to grep for (in ps aux)";
	else
		ps aux | grep -i "$1" | awk '{ print $2 }' | xargs -n 1 -- kill -9
	fi
}

# Hub
#eval "$(hub alias -s)"


# rbenv
#eval "$(rbenv init -)"

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh
command -v fzf >/dev/null && source <(fzf --zsh)

function finv () {
	pushd $HOME/Projects/ansible-playbooks
    test -n "$ANSIBLE_VROOT" || source ./ansible/bin/activate
	./scripts/filter-inventory $*
	popd
	deactivate
}

function fix_git_prompt () {
	echo -en "Delete these files:\n\n"
	git ls-files --other --exclude-standard
}


# For homebrew go
#export GOROOT=/usr/local/opt/go/libexec
#export GOPATH=$HOME/go

# For 1.9.2 manual install
#export GOROOT=/usr/local/go1.9.2
#export GOPATH=$HOME/go1.9.2

#export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
#alias gb=$GOPATH/bin/gb
#

# Go from official download
export PATH="/usr/local/go/bin:$PATH"


export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/.nimble/bin:$PATH

# dotnet
export DOTNET_ROOT="$HOME/.dotnet"
export PATH="$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools"

# iex history
export ERL_AFLAGS="-kernel shell_history enabled"
export ERL_LIBS="$HOME/.config/iex"

export GPG_TTY=$(tty)


alias dc=docker-compose
alias dc-run='dc run --rm '
alias docker-kill-all-running='docker kill $(docker ps -q)'
alias docker-delete-all-containers='docker rm $(docker ps -a -q)'
alias docker-delete-all-images='docker rmi $(docker images -q)'

# Kubertnetes prompt
if [ -f "/usr/local/opt/kube-ps1/share/kube-ps1.sh" ] || [ -f "/opt/homebrew/share/kube-ps1.sh" ]; then
	[ -f "/usr/local/opt/kube-ps1/share/kube-ps1.sh" ] && source "/usr/local/opt/kube-ps1/share/kube-ps1.sh"
	[ -f "/opt/homebrew/share/kube-ps1.sh" ] && source "/opt/homebrew/share/kube-ps1.sh"

	function k_set_prod_background() {
		if [[ "$KUBE_PS1_CONTEXT" == *prod* ]]; then
			echo -e "\033]1337;SetColors=bg=500\a"
		else
			echo -e "\033]1337;SetColors=bg=000\a"
		fi
	}
	export PROMPT="${PROMPT:0:113}"' $(kube_ps1)$(k_set_prod_background)'"${PROMPT:113}"
fi

alias k=kubectl
alias kctx=kubectx
alias kns=kubens

function ks () {
	pod="$(kubectl get pods "$@" | awk '$3 ~ /Running/ { print $0 }' | fzf | awk '{ print $1 }')"
	[[ ! -z "$pod" ]] && kubectl exec "$@" -ti "$pod" -- bash
}

function klogs () {
	pod="$(kubectl get pods "$@" | awk '$3 ~ /Running/ { print $0 }' | fzf | awk '{ print $1 }')"
	[[ ! -z "$pod" ]] && kubectl logs "$@" -f "$pod"
}

function kiex () {
	pod="$(kubectl get pods "$@" | awk '$3 ~ /Running/ { print $0 }' | fzf | awk '{ print $1 }')"
	if [[ ! -z "$pod" ]]; then
		executable=$(kubectl exec "$@" "$pod" -ti -- bash -c "ls bin/ | cat" | tr -d '\r' | grep -vE '\.bat$')
		if [[ ! -z "$executable" ]]; then
			kubectl exec "$@" -ti "$pod" -- "bin/$executable" remote
		else
			echo >&2 "Elixir release executable not found in bin/, exiting"; return 1;
		fi
	else
		return 1;
	fi
}

function keach () {
	if [[ "$#" -lt 2 ]]; then
		echo "Expected kubecontext pattern & command" 1>&2; return 1;
	fi

	if [[ "$(kubectx | grep -E "$1" | grep -c prod)" -gt 0 ]]; then
		echo "WARNING, PATTERN MATCHED FOLLOWING CLUSTERS:" 1>&2
		kubectx | grep -E "$1" | grep prod 1>&2;
		echo "TO CONTINUE, TYPE 'production':" 1>&2
		read -r response

		[[ "$response" != "production" ]] && return 1;
	fi

	pattern="$1"
	shift

	for context in $(kubectx | grep -E "$pattern"); do
		echo "# kubectl --context $context" "${@}" 1>&2
		kubectl --context "$context" "${@}"
	done
}

# let vim see Ctrl-Q
stty -ixon

# patch GOPATH, perhaps I shouldn't have installed it via asdf..
#export GOPATH="$HOME/go:$(go env GOPATH)"

alias guu='git status --porcelain | grep "^UU " | sed "s/...//"'
alias ec='e $(guu)'
alias em='e $(git status --porcelain | grep "^ M " | sed 's/...//')'

alias vless='nvim -u /usr/local/Cellar/neovim/0.3.4/share/nvim/runtime/macros/less.vim'

# casing different between linux / mac, do mac second because case insensitive file system
[ -d "$HOME"/projects ] && export PROJECTS_DIR="$HOME"/projects
[ -d "$HOME"/Projects ] && export PROJECTS_DIR="$HOME"/Projects

p() { cd "$PROJECTS_DIR/$1"; }
_p() {
  pushd "$PROJECTS_DIR" >/dev/null;
  if [[ "$2" == "--" ]]; then
    COMPREPLY=(*);
  else
    COMPREPLY=("$2"*);
  fi
  popd >/dev/null;
}
complete -F _p p

alias fv='vim -O $(fzf -m --preview "bat --style=numbers,changes --color always {}")'

# glcoud
if [ -f  "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc" ]; then
	source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
	source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
fi

# terraform
alias tf=terraform

# https://www.pgrs.net/2022/06/02/simple-command-line-function-to-decode-jwts/
jwt-decode() {
  jq -R 'split(".") |.[0:2] | map(gsub("-"; "+") | gsub("_"; "/") | gsub("%3D"; "=") | @base64d) | map(fromjson)' <<< $1
}

# pantsbuild
alias pa=pants
alias pc='pants --changed-since=origin/main --changed-dependents=transitive'

iterm2_print_user_vars() {
  #iterm2_set_user_var githubHttp $(git remote get-url origin | sed 's/git@/https:\/\//; s/github.com:/github.com\//')
}
#export ITERM2_SQUELCH_MARK=1
source ~/.iterm2_shell_integration.zsh

#export PROMPT="${PROMPT:0:1}%{$(iterm2_prompt_mark)%}${PROMPT:1}"
#

# OCaml / opam
[[ ! -r ~/.opam/opam-init/init.zsh ]] || source ~/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

# Load machine-specific config (if present)
[ -f ~/.local.zsh ] && source ~/.local.zsh

# Print tip of the day
[ -f ~/bin/tip-of-the-day ] && ~/bin/tip-of-the-day
