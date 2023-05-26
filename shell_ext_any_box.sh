# Designed to be used on both dev and production servers
# Read and understand all of this that you use!
#
# As the license says:
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# ###############################################################################
# # Prompt
# ###############################################################################

if [ -n $IN_NIX_SHELL ]; then
  parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ [\1]/'
  }

  # if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  #   host="\[\e[01;35m\]\u@\h\[\e[0m\]"
  # else
  #   host="\[\e[01;30m\]\h\[\e[0m\]"
  # fi

  # if [ -n "$IN_NIX_SHELL" ]; then
  #   subshell="==NIX"
  # else
  #   subshell=""
  # fi

  export PS1="\[\e[1;36m\]NIX \[\e[0m\]\w\[\e[01;32m\]\$(parse_git_branch)\[\e[0m\] $ \[\e[0m\]"
fi

###############################################################################
# Basics
###############################################################################

alias ll='ls -lFh'
alias lla='ls -lFah'
alias llt='ls -lhFart'

alias a=alias

alias br='bin/run'

# eg "ga rake" to see all rake-related aliases
function ga {
  alias | grep "$1" | grep -v grep
}

alias pg='ping www.google.com'

# eg "psg mysql" to see all mysql processes
function psg {
  ps wwwaux | egrep "($1|%CPU)" | grep -v grep
}

# eg "port 3000" to see what is running there
function port {
  lsof -i -n -P | grep TCP | grep "$1"
}

# Display folder and it's content as a tree
function tree {
  find ${1:-.} -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'
}

if [ $OSTYPE = 'linux-gnu' ]; then
  export EDITOR=$(which nano)
fi

# GIT
alias g=git
alias wip='git commit -m WIP'
export GIT_DUET_CO_AUTHORED_BY=1

# rsync
alias rsink='rsync --archive --verbose --progress --human-readable'
#alias rsink='rsync --archive --compress --verbose --progress --human-readable'
alias rsinkd='rsink --delete'

alias hk=heroku

alias ebp='$EDITOR ~/.zshrc'
alias ezsh='$EDITOR ~/.zshrc'
alias ebpe='$EDITOR ~/.dev_env'
alias ezshe='$EDITOR ~/.dev_env'
alias szsh='. ~/.zshrc'
alias sbp='. ~/.zshrc'

# ###############################################################################
# # Prompt
# ###############################################################################

# if [ $OSTYPE = 'linux-gnu' ]; then
#   export GIT_DUET_CO_AUTHORED_BY=1
#   parse_git_branch() {
#     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ [\1]/'
#   }

#   if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
#     host="\[\e[01;35m\]\u@\h\[\e[0m\]"
#   else
#     host="\[\e[01;30m\]\h\[\e[0m\]"
#   fi

#   if [ -n "$IN_NIX_SHELL" ]; then
#     subshell="==NIX"
#   else
#     subshell=""
#   fi

#   export PS1="${host} \w\[\e[01;32m\]\$(parse_git_branch)\[\e[0m\]\n\[\e[1;36m\]${subshell}==> $ \[\e[0m\]"
# fi

# Codespaces zsh prompt theme, modified:
__zsh_prompt() {
  local prompt_username
  if [ ! -z "${GITHUB_USER}" ]; then
    prompt_username="@${GITHUB_USER}"
  else
    prompt_username="%n"
  fi
  PROMPT="%{$fg[green]%}${prompt_username} %(?:%{$reset_color%}➜ :%{$fg_bold[red]%}➜ )"                   # User/exit code arrow
  PROMPT+='%{$fg_bold[blue]%}%(5~|%-1~/…/%3~|%4~)%{$reset_color%} '                                       # cwd
  PROMPT+='$([ "$(git config --get codespaces-theme.hide-status 2>/dev/null)" != 1 ] && git_prompt_info)' # Git status
  PROMPT+=$'\n'
  PROMPT+='%{$fg[white]%}$ %{$reset_color%}'
  unset -f __zsh_prompt
}
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[cyan]%}(%{$fg_bold[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg_bold[yellow]%}✗%{$fg_bold[cyan]%})"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[cyan]%})"
__zsh_prompt

###############################################################################
# Yarn
###############################################################################

alias yup='yarn upgrade --force --latest'

alias y='yarn'
alias yt='yarn test'
alias yr='yarn run'

function yi {
  yarn add $*
}
function ya {
  yarn add $*
}
function yad {
  yarn add $* --dev
}

###############################################################################
# NPM
###############################################################################

alias nbump='npm version patch'
alias npub='npm version patch && git push --tags origin HEAD && npm publish'
alias nup='ncu --upgrade && npm update && npm prune' # if this fails:  `npm upgrade -g npm-check-updates`
alias n='npm'
alias nt='npm test'
alias nr='npm run'
alias ne='npm exec'
alias links='ll node_modules | grep \\-\>'

function ni {
  npm install $1 && npm prune
}
function nis {
  npm install --save $1 && npm prune
}
function nid {
  npm install --save-dev $1 && npm prune
}

function nv {
  npm show $1 versions
}

###############################################################################
# Ruby
###############################################################################

# Bundler

alias be='bundle exec'
alias bi='bundle install'
alias biq='bi --quiet'
alias biw='bi --without=development:test'
alias bid='biw --deployment'
alias bis='gemrat --no-version' # implements missing `bundle install --save` -- requires you first `gem install gemrat`

# # Foreman

# alias frun='be foreman run'
# alias fcon='be foreman run irb'
# alias fser='biq && be rerun foreman start'

# Rails

alias sp='bin/rspec --color'
alias sn='sp --format documentation'
alias sf='sp --require fuubar --format Fuubar'

alias r='bin/rails'
alias rs='biq && be foreman run "rails server"'

alias rdr='br db:rebuild'
alias rdm='be rake db:migrate'
alias rtp='br db:test:prepare'
alias rds='br db:seed'

alias work='br jobs:work'

alias ss='spring stop'
