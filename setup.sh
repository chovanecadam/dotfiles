#!/bin/bash

if [[ -z $1 || `id -u` > 0 ]]
then
    echo "Please run as root."
    echo "Usage: $0 <username>"
    exit 1
fi

USER=$1
HOME=`grep $USER /etc/passwd | cut -f6 -d:`

if ! id "$1" &>/dev/null
then
    echo User $USER doesn\'t exist
    exit 1
fi

set -eo pipefail

echo Installing packages...
apt-get install -qq git screen tmux neovim zsh &>/dev/null

ln -f .gitconfig  $HOME/.gitconfig
ln -f .screenrc   $HOME/.screenrc 
ln -f .tmux.conf  $HOME/.tmux.conf

chown -R $USER:$USER $HOME/.gitconfig $HOME/.screenrc $HOME/.tmux.conf

# vim setup

if [[ ! -d "$HOME/.config/nvim/colors" ]]
then
    mkdir -p $HOME/.config/nvim/colors
fi

ln -f init.vim   $HOME/.config/nvim/init.vim
ln -f myown.vim  $HOME/.config/nvim/colors/myown.vim

curl -sfLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

chown -R $USER:$USER $HOME/.gitconfig $HOME/.screenrc $HOME/.tmux.conf  $HOME/.local/ $HOME/.config

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

chown -R $USER:$USER $HOME/.zshrc $HOME/.zsh

echo Changing default shell to zsh...
if [[ ! "grep $USER /etc/passwd | cut -d: -f7" == "/bin/zsh" ]]
then
    chsh -s /bin/zsh $USER
fi
