# My adaptation of neovim configurations from https://github.com/jdhao/nvim-config.git
This is my linux kernel development setup (and other c/c++/go/python/lua based projects). This setup depends heavily
on clang-tools/llvm, plus neovim and a load of plugins. I switched to this from clion when it failed to
index the linux kernel without requiring 4GB of memory (and crashing even after that!)
# Requirements
- llvm, and all its llvm-<bin> stuff properly mapped (lots of update alternatives on ubuntu)
- neovim >= 0.7.0
- fd-find and ripgrep
- install pyright language server (look it up)
- install gopls:
  + cd to temp directory (or any directory outside of a module or a gopath)
  + `$ mkdir $HOME/.local/go && export GOPATH=$HOME/.local/go`
  + `$ go install golang.org/x/tools/gopls@latest`
  + add `$GOPATH` export to your zshrc/bashrc
- install lua-language-server following [sumneko](https://github.com/sumneko/lua-language-server/wiki/)
# Setup issues
- You will find that a lot of neovim's required directories do not exist, create them, one error at a time
- I disabled treesitter because it messes up my lua editing .. I no longer care.

# setup steps:
- nvim\_config/ becomes ~/.config/ in your home directory
- Install the requirements above
- Resolve all the issues that come up when you `$ vim ~/.config/nvim/init.vim` (just an example of
  openning a file in neovim)
- Run `PackerSync` and resolve any issues for failed packages, and document them here!
- Run `:UpdateRemotePlugins` for wilder issues that you don't understand.
