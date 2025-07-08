#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ll='ls -alFh --color=auto --group-directories-first' 
alias e='nvim'
alias vim='nvim'
alias p='sudo pacman'
PS1='[\u@\h \W]\$ '
