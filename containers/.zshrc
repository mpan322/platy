# If you come from bash you might have to change your $PATH.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git)

if [[ ! -d ~/.config/nvim/ ]]; then
  git clone -b main git@github.com:mpan322/NvChad.git ~/.config/nvim/
fi

source $ZSH/oh-my-zsh.sh
