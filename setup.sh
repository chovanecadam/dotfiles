# hardlinking dotfiles

ln -f .gitconfig  ~/.gitconfig
ln -f .zshrc      ~/.zshrc    
ln -f .screenrc   ~/.screenrc 
ln -f .tmux.conf  ~/.tmux.conf

if [[ ! -d "~/.config/nvim/colors" ]]
then
    mkdir -p ~/.config/nvim/colors
fi

ln -f init.vim   ~/.config/nvim/init.vim
ln -f myown.vim  ~/.config/nvim/colors/myown.vim

# zsh setup

if [[ ! "dpkg -s zsh | head -n 2 | grep installed" ]]
then
    sudo apt install zsh
fi

if [[ ! -d "~/.zsh/" ]]
then 
    mkdir ~/.zsh
fi

ln -f zshsyntax.conf         ~/zsh/zshsyntax.conf
ln -f zshalias.conf          ~/zsh/zshalias.conf
ln -f watson.zsh-completion  ~/zsh/watson.zsh-completion

if [[ ! "getent passwd $LOGNAME | cut -d: -f7" == "/bin/zsh" ]]
then
    chsh -s /bin/zsh
fi
