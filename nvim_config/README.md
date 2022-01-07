# My adaptation of neovim configurations from https://github.com/jdhao/nvim-config.git
This is my linux kernel development setup (and other c/c++ based projects). This setup depends heavily
on clang-tools/llvm, plus neovim and a load of plugins. I switched to this from clion when it failed to
index the linux kernel without requiring 4GB of memory (and crashing even after that!)
# Requirements
- llvm, and all its llvm-<bin> stuff properly mapped (lots of update alternatives on ubuntu)
- neovim >= 0.6.1
- fd-find and ripgrep
- TODO: follow setup failures and add what you find.
# Setup issues
- You will find that a lot of neovim's required directories do not exist, create them, one error at a time

# setup steps:
- nvim\_config/ becomes ~/.config/ in your home directory
- Install the requirements above
- Resolve all the issues that come up when you `$ vim ~/.config/nvim/init.vim` (just an example of
  openning a file in neovim)
- Run `PackerSync` and resolve any issues for failed packages, and document them here!

