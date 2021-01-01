#!/bin/bash

set -eo pipefail

ERRMSG=""

exitfnc() {
    if [[ "$1" == "-q" || "$2" == "-q" ]]
    then
        exit 0
    else
        echo $ERRMSG >&2
        exit 1
    fi
}

if [[ -z "$1" || `id -u` > 0 ]]
then
    ERRMSG="Please run as root.
            Usage: $0 '<username> [-q]'"
    exitfnc "$1" "$2"
fi

USER="$1"
HOME=`grep -- "$USER" /etc/passwd | cut -f6 -d:`

if ! id "$1" &>/dev/null
then
    ERRMSG="User '$1' doesn\'t exist"
    exitfnc "$1" "$2"
fi

if [[ -z "$HOME" ]]
then
    ERRMSG="User '$USER' doesn\'t have a home"
    exitfnc "$1" "$2"
fi

if [[ -e "$HOME"/.local/bin/swap ]]
then
    ERRMSG="It looks like the script already ran for the user $USER,\
    because the file $HOME/.local/bin/swap exists.
    Execute with -q to exit gracefully."
    exitfnc "$1" "$2"
fi

echo Installing packages...
apt-get install -qq git screen tmux neovim zsh &>/dev/null

ln -f .gitconfig  $HOME/.gitconfig
ln -f .screenrc   $HOME/.screenrc 
ln -f .tmux.conf  $HOME/.tmux.conf

# vim setup

if [[ ! -d "$HOME/.config/nvim/colors" ]]
then
    mkdir -p $HOME/.config/nvim/colors
fi

ln -f init.vim   $HOME/.config/nvim/init.vim
ln -f myown.vim  $HOME/.config/nvim/colors/myown.vim

curl -sfLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

nvim +PlugInstall +qall &>/dev/null

# zsh setup

ln -f .zshrc      $HOME/.zshrc    

if [[ ! -d "$HOME/.zsh/" ]]
then 
    mkdir $HOME/.zsh
fi

ln -f zshsyntax.conf         $HOME/.zsh/zshsyntax.conf
ln -f zshalias.conf          $HOME/.zsh/zshalias.conf
ln -f watson.zsh-completion  $HOME/.zsh/watson.zsh-completion

git clone https://github.com/zsh-users/zsh-completions.git $HOME/.zsh/zsh-completions &> /dev/null

echo Changing default shell to zsh...
if [[ ! "grep $USER /etc/passwd | cut -d: -f7" == "/bin/zsh" ]]
then
    chsh -s /bin/zsh $USER
fi


echo Linking swap script

if [[ -e $HOME/.local/bin/swap ]]
then
    echo Error: $HOME/.local/bin/swap already exists
    exit 1
fi

if [[ ! -e $HOME/.local/bin ]] 
then
    mkdir -p $HOME/.local/bin
fi

ln ./swap $HOME/.local/bin/swap

# THIS HAS TO BE THE LAST COMMAND
chown -R $USER:$USER $HOME

echo Setup finished successfully!
