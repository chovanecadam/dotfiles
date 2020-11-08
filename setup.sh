#!/bin/bash

apt-get install -qq git screen tmux neovim zsh &>/dev/null

ln -f .gitconfig  ~/.gitconfig
ln -f .screenrc   ~/.screenrc 
ln -f .tmux.conf  ~/.tmux.conf

# vim setup

if [[ ! -d "${HOME}/.config/nvim/colors" ]]
then
    mkdir -p ~/.config/nvim/colors
fi

ln -f init.vim   ~/.config/nvim/init.vim
ln -f myown.vim  ~/.config/nvim/colors/myown.vim

curl -sfLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

nvim +PlugInstall +qall &>/dev/null

# zsh setup

ln -f .zshrc      ~/.zshrc    

if [[ ! -d "${HOME}/.zsh/" ]]
then 
    mkdir ~/.zsh
fi

ln -f zshsyntax.conf         ~/.zsh/zshsyntax.conf
ln -f zshalias.conf          ~/.zsh/zshalias.conf
ln -f watson.zsh-completion  ~/.zsh/watson.zsh-completion

if [[ ! "grep $LOGNAME /etc/passwd | cut -d: -f7" == "/bin/zsh" ]]
then
    chsh -s /bin/zsh
fi
