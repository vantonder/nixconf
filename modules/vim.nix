{ config, pkgs, ... }: 
let
  id = config.user.identifier;
in {
  environment.variables.EDITOR = "vim";
  environment.systemPackages = with pkgs; [
    ((vim_configurable.override {}).customize {
      name = "vim";
      vimrcConfig.customRC = ''
        " The ArchLinux global vimrc - setting only a few sane defaults
        "
        " Location:        https://raw.githubusercontent.com/archlinux/svntogit-packages/68f6d131750aa778807119e03eed70286a17b1cb/trunk/archlinux.vim
        " Maintainer:      Thomas Dziedzic [gostrc@gmail.com]
        "
        " NEVER EDIT THIS FILE, IT'S OVERWRITTEN UPON UPGRADES, GLOBAL CONFIGURATION
        " SHALL BE DONE IN /etc/vimrc, USER SPECIFIC CONFIGURATION IN ~/.vimrc

        " Normally we use vim-extensions. If you want true vi-compatibility
        " remove change the following statements
        set nocompatible                " Use Vim defaults instead of 100% vi compatibility
        set backspace=indent,eol,start  " more powerful backspacing

        " Now we set some defaults for the editor
        syntax on
        set autoindent expandtab tabstop=2 shiftwidth=2
        set history=50                  " keep 50 lines of command line history
        set ruler                       " show the cursor position all the time

        " Suffixes that get lower priority when doing tab completion for filenames.
        " These are files we are not likely to want to edit or read.
        set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,.png,.jpg

        if has('gui_running')
          " Make shift-insert work like in Xterm
          map <S-Insert> <MiddleMouse>
          map! <S-Insert> <MiddleMouse>
        endif
      '';
    })
  ];
  home-manager.users.${id}.programs.vim = {
    enable = true;
    defaultEditor = true;
  };  
}
