# ~/.bashrc: executed by bash(1) for non-login shells.
case $- in
    *i*) ;;
      *) return;;
esac

# History settings
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000

# Adjust window size after each command
shopt -s checkwinsize

# lesspipe for non-text input files
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Enable color prompt
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# Uncomment to force color prompt
# force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        color_prompt=yes
    else
        color_prompt=
    fi
fi

# Git branch prompt
parse_git_branch() {
  git rev-parse --is-inside-work-tree &>/dev/null || return
  local branch
  branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
  [ -n "$branch" ] || return

  if git diff --quiet --ignore-submodules HEAD 2>/dev/null; then
    echo -e "\033[0;32m($branch)\033[0m"
  else
    echo -e "\033[0;31m($branch)\033[0m"
  fi
}

# Set prompt (PS1) with git branch
if [ "$color_prompt" = yes ]; then
    PS1='\[\033[01;96m\]\u@\h\[\033[00m\]:\[\033[38;5;221m\]\w\[\033[00m\]$(parse_git_branch)\$ '
else
    PS1='\u@\h:\w$(parse_git_branch)\$ '
fi
unset color_prompt force_color_prompt

# Set window title
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;\u@\h: \w\a\]$PS1"
    ;;
esac

# Color support
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Alert alias
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Load custom aliases
[ -f ~/.bash_aliases ] && . ~/.bash_aliases

# Bash completion
if ! shopt -oq posix; then
  [ -f /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion
  [ -f /etc/bash_completion ] && . /etc/bash_completion
fi

export PATH=$PATH:$HOME/go/bin
