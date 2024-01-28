{ config, pkgs, ... }: {
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ config.user.name ];
  };

  home-manager.users.${config.user.name} = {
    programs.git = {
      extraConfig = {
        commit.gpgsign = true;
        gpg.format = "ssh";
        gpg."ssh".program = "${pkgs._1password-gui}/bin/op-ssh-sign";
        user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK4z+GCnpEmPq2uRl1Ol8a83Xjmeiqk1q8XV3cZh7pWZ";
      };
    };

    programs.ssh = {
      enable = true;
      extraConfig = ''
        Host *
          IdentityAgent ~/.1password/agent.sock
      '';
    };
  };
}
