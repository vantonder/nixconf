{ config, lib, pkgs, wsl, ... }: {
  options = with lib; {
    presets.user.base.enable = mkEnableOption (mdDoc "base user preset");
  };

  config = lib.mkIf config.presets.user.base.enable {
    home.packages = with pkgs; [
      fzf
      jq
      ripgrep
      tree
      which
      zip
    ];

    programs = {
      firefox.enable = lib.mkIf wsl true;
      fish = {
        enable = true;
        interactiveShellInit = ''
          set fish_greeting
          fish_vi_key_bindings
        '';
      };
      home-manager.enable = true;
    };

    xdg.userDirs = {
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
    };
  };
}
