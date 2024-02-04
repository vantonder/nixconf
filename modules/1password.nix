{ config, pkgs, ... }:
let
  # Create an autostart item so that the 1Password SSH agent is run on startup
  # This avoids having to manually start 1Password for SSH operations
  withAutostart = pkgs._1password-gui.overrideAttrs (prev: {
    postInstall = (prev.postInstall or "") + ''
      mkdir -p $out/etc/xdg/autostart
      cp $out/share/applications/${prev.pname}.desktop $out/etc/xdg/autostart/${prev.pname}.desktop
      substituteInPlace $out/etc/xdg/autostart/${prev.pname}.desktop \
        --replace 'Exec=${prev.pname} %U' 'Exec=${prev.pname} --silent %U'
    '';
  });
in
{
  # Use the autostart derivation above as the package
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ config.user.identifier ];
    package = withAutostart;
  };

  home-manager.users.${config.user.identifier} = {
    # Configure Git to use the 1Password SSH agent for signing
    programs.git = {
      extraConfig = {
        commit.gpgsign = true;
        gpg.format = "ssh";
        gpg."ssh".program = "${withAutostart}/bin/op-ssh-sign";
        user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK4z+GCnpEmPq2uRl1Ol8a83Xjmeiqk1q8XV3cZh7pWZ";
      };
    };

    # Configuration to instruct SSH to use the 1Password SSH agent for handling all SSH key operations
    programs.ssh = {
      enable = true;
      extraConfig = ''
        Host *
          IdentityAgent ~/.1password/agent.sock
      '';
    };
  };
}
