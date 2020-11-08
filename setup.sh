# hardlinking dotfiles

ln -f ~/.gitconfig     ~/dotfiles/.gitconfig
ln -f ~/.zshrc         ~/dotfiles/.zshrc
ln -f ~/.screenrc      ~/dotfiles/.screenrc
ln -f ~/.tmux.conf     ~/dotfiles/.tmux.conf

if [[ ! -d "~/.config/nvim/colors" ]]
then
    mkdir -p ~/.config/nvim/colors
fi

ln -f ~/.config/nvim/init.vim   ~/dotfiles/init.vim
ln -f ~/.config/nvim/colors/myown.vim     ~/dotfiles/myown.vim

# zsh setup

if [[ ! "dpkg -s zsh | head -n 2 | grep installed" ]]
then
    sudo apt install zsh
fi

if [[ ! -d "~/.zsh/" ]]
then 
    mkdir ~/.zsh
fi

ln -f ~/zsh/zshsyntax.conf          ~/dotfiles/zshsyntax.conf
ln -f ~/zsh/zshalias.conf           ~/dotfiles/zshalias.conf
ln -f ~/zsh/watson.zsh-completion   ~/dotfiles/watson.zsh-completion

if [[ ! "getent passwd $LOGNAME | cut -d: -f7" == "/bin/zsh" ]]
then
    chsh -s /bin/zsh
fi
