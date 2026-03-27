### bashrc file

# Interactive shell only
case $- in
  *i*) ;;
  *) return ;;
esac

# History
HISTCONTROL=ignoredups:erasedups
HISTSIZE=5000
HISTFILESIZE=10000
HISTIGNORE='ls:l:ll:la:pwd:exit:clear:history'
shopt -s histappend
shopt -s checkwinsize

# better globbing
shopt -s globstar
shopt -s autocd 2>/dev/null || true

# Locale fallback
export LANG="${LANG:-cs_CZ.UTF-8}"
export LC_ALL="${LC_ALL:-cs_CZ.UTF-8}"

# Editor / pager
export EDITOR=vim
export VISUAL=vim
export PAGER=less
export LESS='-R -i -M'

# dircolors + color aliases
if command -v dircolors >/dev/null 2>&1; then
  eval "$(dircolors -b)"
fi

alias ls='ls --color=auto -F'
alias l='ls --color=auto -CF'
alias ll='ls --color=auto -alF'
alias la='ls --color=auto -A'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Useful project-specific aliases 
alias croot='cd /embedded-sql'
alias cbuild='cd /embedded-sql/build'
alias cexamples='cd /embedded-sql/examples'
alias mk='make'
alias play='/embedded-sql/embedded-sql-playbook.sh'
alias rb='/embedded-sql/embedded-sql-run.sh'
alias rebuild='make clean && make'
alias cfg='make print-config'

# bash-completion
if [ -r /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
fi

# Auto-load /embedded-sql/env.sh
if [ -f /embedded-sql/env.sh ]; then
  # env.sh může číst credentials ze souborů/secrets
  # shellcheck source=/dev/null
  . /embedded-sql/env.sh >/dev/null 2>&1 || true
fi

# Default work directory
if [ -d /embedded-sql ]; then
  cd /embedded-sql || true
fi

# Git branch in prompt
__embedded_sql_git_branch() {
  command -v git >/dev/null 2>&1 || return 0
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return 0
  local b
  b="$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)" || return 0
  [ -n "$b" ] && printf ' (%s)' "$b"
}

# Colors in prompt
#PS1='\[\e[1;32m\]\u@\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\[\e[0;33m\]$(__embedded_sql_git_branch)\[\e[0m\]\$ '
PS1='\[Docker container \e[1;32m\]embedded-sql\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ '

# Intro message
echo "Embedded SQL container ready."
echo "PWD: $(pwd)"
echo "Oracle env: ORA_DB=${ORA_DB:-<unset>} ORA_USER=${ORA_USER:-<unset>} ORA_PASS=${ORA_PASS:+<set>}"
