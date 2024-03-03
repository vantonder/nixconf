{ config, lib, pkgs, wsl, ... }: {
  options = with lib; {
    presets.user.development.enable = mkEnableOption (mdDoc "user development preset");
  };

  config = lib.mkIf config.presets.user.development.enable {
    programs = {
      bat.enable = true;
      bat.extraPackages = with pkgs.bat-extras; [
        batdiff
        batman
      ];

      direnv.enable = true;
      direnv.nix-direnv.enable = true;

      fish.shellAliases = {
        g = "git";
        ".." = "cd ../..";
      };
      fish.shellAbbrs = {
        # Git
        # add
        ga = "git add";
        gaa = "git add --all";
        # branch
        gb = "git branch";
        gba = "git branch --all";
        gbd = "git branch --delete";
        gbds = "delete_squashed_branches";
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

      git.enable = true;
      git.extraConfig = {
        commit.gpgsign = true;
        core.sshCommand = lib.mkIf wsl "ssh.exe";
        gpg.format = "ssh";
        gpg.ssh.program = lib.mkIf (!wsl) "${pkgs._1password-gui}/bin/op-ssh-sign";
        init.defaultBranch = "main";
        pull.rebase = true;
      };
      git.userName = "Preston van Tonder"; 
      
      ssh.enable = true;
      ssh.extraConfig = "IdentityAgent ~/.1password/agent.sock";

      starship.enable = true;
      starship.settings = {
        username = {
          disabled = false;
          show_always = true;
          style_user = "white bold";
        };
      };

      wezterm.enable = lib.mkIf (!wsl) true;

      zoxide.enable = true;
      zoxide.options = [ "--cmd" "cd" ];
    }; 
  };
}
