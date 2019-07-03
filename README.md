# dotfiles

dotfiles

## requirements

### local (OSX)

- iTerm2
- zsh (brew)
    - zsh-completions (brew)
- vim (brew)

### remote (Unix)

- tmux2u
- bash (default)
- vim (default)

## install

```bash
# clone
$ git clone https://github.com/junion-org/dotfiles.git
$ git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# symlnk what you need
$ ln -s dotfiles/.vimrc
$ ln -s dotfiles/.zshrc
$ ln -s dotfiles/.tmux.conf
$ ln -s dotfiles/.Xresources

# Run a command below in Vim
$ vim
:PluginInstall
```

## resources

- iTerm2
    - .Xresources, hybrid.itermcolors: https://github.com/w0ng/vim-hybrid
