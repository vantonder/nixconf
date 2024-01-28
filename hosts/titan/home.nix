{ config, pkgs, ... }: {
  home-manager.users.${config.user.name} = {
    home.username = config.user.name;
    home.homeDirectory = "/home/${config.user.name}";

    # packages that should be installed to the user profile.
    home.packages = with pkgs; [
      # archives
      p7zip
      unzip
      xz
      zip

      # misc
      cowsay
      file
      gawk
      gnupg
      gnused
      gnutar
      tree
      which
      zstd

      # monitoring
      btop  # replacement of htop/nmon
      iftop # network monitoring
      iotop # io monitoring

      # networking tools
      dnsutils  # `dig` + `nslookup`

      # productivity
      glow # markdown previewer in terminal
      hugo # static site generator

      # system call monitoring
      lsof # list open files
      ltrace # library call monitoring
      strace # system call monitoring

      # system tools
      lm_sensors # for `sensors` command
      pciutils # lspci
      sysstat
      usbutils # lsusb

      # utils
      eza # A modern replacement for ‘ls’
      fzf # A command-line fuzzy finder
      jq # A lightweight and flexible command-line JSON processor
      ripgrep # recursively searches directories for a regex pattern
      yq-go # yaml processer https://github.com/mikefarah/yq
    ];

    xdg = {
      userDirs = {
        enable = true;
        createDirectories = true;
        desktop = "$HOME/desktop";
        documents = "$HOME/documents";
        download = "$HOME/downloads";
        music = "$HOME/media/music";
        pictures = "$HOME/media/images";
        publicShare = "$HOME/other/public";
        videos = "$HOME/media/videos";
        templates = "$HOME/other/templates";
        extraConfig = { XDG_DEV_DIR = "$HOME/development"; };
      };
    };

    # This value determines the home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update home Manager without changing this value. See
    # the home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "23.11";

    # Let home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
