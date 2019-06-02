if [ -f $(brew --prefix)/etc/bash_completion ]; then
. $(brew --prefix)/etc/bash_completion
fi

export EDITOR=vim


# vim3 is my own compiled vim with support for python 3.
# it is symlinked from /usr/bin/vim3 to /usr/local/bin/vim

# increase heap memory for maven everywhere

export MAVEN_OPTS="-Xmx2048m -XX:MaxPermSize=128m"

##
# Your previous /Users/korena/.bash_profile file was backed up as /Users/korena/.bash_profile.macports-saved_2017-01-12_at_22:36:55
##

# Homebrew installed sqlite is the one used first:
# For compilers to find this software you may need to set:
#    LDFLAGS:  -L/usr/local/opt/sqlite/lib
#    CPPFLAGS: -I/usr/local/opt/sqlite/include

# last chance for pyenv
eval "$(pyenv init -)"
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi


# For homebrew's openssl libraries to be found by compilers and configuration tools:
# first, make this the default (found first in path)
export PATH="/usr/local/opt/openssl/bin:$PATH"

# for cmake to find openssl:
export OPENSSL_ROOT_DIR="/usr/local/opt/openssl"

# Apache Portable Runtime (APR)
export PATH="/usr/local/opt/apr/bin:$PATH"

# add flags for compilers
export LDFLAGS="-L/usr/local/opt/openssl/lib $LDFLAGS"
export CPPFLAGS="-I/usr/local/opt/openssl/include $CPPFLAGS"
export PKG_CONFIG_PATH="/usr/local/opt/openssl/lib/pkgconfig "

# for psql cli 
export PATH="/Library/PostgreSQL/9.6/bin:$PATH"

export PATH="/usr/local/opt/sqlite/bin:$PATH"

# MacPorts Installer addition on 2017-01-12_at_22:36:55: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:/usr/local/mysql/bin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

# adding custom scripts to deal with gpg verification of binaries, utils and stuff ..
export PATH="$PATH:/Users/korena/Scripts/gpg:/Users/korena/Scripts/aws:/Users/korena/Scripts/network"


export DYLD_LIBRARY_PATH=/usr/local/mysql/lib:$DYLD_LIBRARY_PATH

# Java home setting
export JAVA_HOME=`/System/Library/Frameworks/JavaVM.framework/Versions/Current/commands/java_home`

# my own compiled gcc 8.3 to work around apple not caring about breaking shit, now, gcc command invokes my own gcc.
#export PATH="/opt/local/gcc-8.3/bin:$PATH"
#export DYLD_LIBRARY_PATH="/opt/local/gcc-8.3/lib:$DYLD_LIBRARY_PATH"

# arm none eabi compiler
#export PATH="/Users/korena/Tools/gcc-arm-none-eabi-7-2018-q2-update/bin:$PATH"
export PATH="/Users/korena/Tools/gcc-arm-none-eabi-8-2018-q4-major/bin:$PATH"

# openocd
export PATH="/Applications/GNU ARM Eclipse/OpenOCD/0.10.0-201704182147-dev/bin/:$PATH"

# sane colors:
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

# git branch ps1
function parse_git_branch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

WHITE="\[\033[0;37m\]"
PINKY="\[\033[0;35m\]"
LIGHT_BLUE="\[\033[0;36m\]"
BLUE="\[\033[0;34m\]"
GREEN="\[\033[0;32m\]"
RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
NO_COLOR="\[\033[0m\]"

PS1="$GREEN\u@$LIGHT_BLUE\h$NO_COLOR:$WHITE\W$YELLOW\$(parse_git_branch)$NO_COLOR\$ "

export PATH="/usr/local/sbin:$PATH"


# nvm from homebrew
export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"

# dumb design, jenv is not to be used, it doesn't set java_home correctly, useless.
# jenv from homebrew (used to switch between jvm versions)
# if which jenv > /dev/null; then eval "$(jenv init -)"; fi
# export PATH="$HOME/.jenv/shims:$PATH"

# scitools
export PATH="/Users/korena/Library/scitools/bin/macosx/:$PATH"
export DYLD_LIBRARY_PATH=/Users/korena/Library/scitools/bin/macosx:$DYLD_LIBRARY_PATH


# virtualenvwrapper.sh

#source "/usr/local/bin/virtualenvwrapper.sh"

alias git-show-urls='/Users/korena/Scripts/forgetful/git-show-urls.sh'

# links cmd browser alias
alias cmd-browser='links'

# show/hide hidden files in Finder
alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'
source /usr/local/etc/bash_completion.d/pass

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"


# Java home setup, forget stupid jenv

alias j6='export JAVA_HOME=$(/usr/libexec/java_home -v 1.6*)'
alias j7='export JAVA_HOME=$(/usr/libexec/java_home -v 1.7*)'
alias j8='export JAVA_HOME=$(/usr/libexec/java_home -v 1.8*)'


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/korena/.sdkman"
[[ -s "/Users/korena/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/korena/.sdkman/bin/sdkman-init.sh"
eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl5)"
