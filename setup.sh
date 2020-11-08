# git, tmux and screen

apt list -qq git    | grep installed &>/dev/null || sudo apt install --yes git    &>/dev/null
apt list -qq tmux   | grep installed &>/dev/null || sudo apt install --yes tmux   &>/dev/null
apt list -qq screen | grep installed &>/dev/null || sudo apt install --yes screen &>/dev/null

ln -f .gitconfig  ~/.gitconfig
ln -f .screenrc   ~/.screenrc 
ln -f .tmux.conf  ~/.tmux.conf

# vim setup

apt list -qq neovim | grep installed &>/dev/null || sudo apt install --yes neovim &>/dev/null

if [[ ! -d "${HOME}/.config/nvim/colors" ]]
then
    mkdir -p ~/.config/nvim/colors
fi

ln -f init.vim   ~/.config/nvim/init.vim
ln -f myown.vim  ~/.config/nvim/colors/myown.vim

# zsh setup

apt list -qq zsh | grep installed &>/dev/null || sudo apt install --yes zsh &>/dev/null

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
