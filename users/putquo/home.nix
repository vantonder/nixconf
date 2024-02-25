{ pkgs, lib, ... }: 
let
  context = import ./context.nix;
in {
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

    # gaming
    discord
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
      extraConfig = { XDG_DEV_DIR = "$HOME/${context.dirs.development}"; };
    };
  };

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      config = {
        whitelist.prefix = with context.dirs; [ "${home}/${development}" ];
      };
    };

    firefox = {
      enable = true;
      profiles.default = {
        id = 0;
        name = "default";
        isDefault = true;
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          onepassword-password-manager
          ublock-origin
        ];
      };
    };

    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting
        fish_vi_key_bindings
      '';
      shellAliases = {
        g = "git";
        ".." = "cd ../..";
      };
      shellAbbrs = {
        # Git
        # add
        ga = "git add";
        gaa = "git add --all";
        # branch
        gb = "git branch";
        gba = "git branch --all";
        gbd = "git branch --delete";
        gbD = "git branch --delete --force";
        gbm = "git branch --move";
        # checkout
        gco = "git checkout";
        gcb = "git checkout -b";
        # commit
        gc = "git commit";
        "gc!" = "git commit --amend";
        gcm = "git commit -m";
        "gcn!" = "git commit --amend --no-edit";
        # fetch
        gf = "git fetch";
        # pull
        gpl = "git pull";
        gpr = "git pull --rebase";
        # push
        gp = "git push";
        gpf = "git push --force-with-lease --force-if-includes";
        # rebase
        grb = "git rebase";
        grba = "git rebase --abort";
        grbc = "git rebase --continue";
        grbs = "git rebase --skip";
        # restore
        grs = "git restore";
        grst = "git restore --staged";
        # status
        gst = "git status";
      };
    };

    git = {
      enable = true;
      userName = context.git.author;
      userEmail = context.git.email;
      extraConfig = {
        commit.gpgsign = true;
        gpg.format = "ssh";
        gpg."ssh".program = "${pkgs._1password-gui}/bin/op-ssh-sign";
        user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK4z+GCnpEmPq2uRl1Ol8a83Xjmeiqk1q8XV3cZh7pWZ";
      };
    };

    ssh = {
      enable = true;
      extraConfig = ''
        Host *
          IdentityAgent ~/.1password/agent.sock 
      '';
    };

    starship = {
      enable = true;
      enableNushellIntegration = false;
      enableIonIntegration = false;
      enableZshIntegration = false;
      settings = {
        username = {
          disabled = false;
          show_always = true;
          style_user = "white bold";
        };
      };
    };

    vim = {
      enable = true;
      defaultEditor = true;
    };

    wezterm.enable = true;

    zoxide = {
      enable = true;
      options = [ "--cmd" "cd" ];
      enableZshIntegration = false;
      enableNushellIntegration = false;
    };
  };

  xdg.configFile = {
    "wezterm/wezterm.lua" = lib.mkForce {
      source = ./wezterm/wezterm.lua;
    };
    "wezterm/themes" = {
      source = ./wezterm/themes;
      recursive = true;
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
}
