{ config, lib, pkgs, schematics, ...}: with lib; let
  toil = "toil";
  wsl = config.wsl.enable;
in schematics.forUser toil {
  inherit config;
  withOverrides = {
    home-manager.users.${toil} = {
      presets.user.development.enable = true;

      home.packages = with pkgs; [
        act
      ];

      programs = {
        awscli.enable = true;
        awscli.settings = {
          "profile devops" = {
            sso_session = "devops";
            sso_account_id = "478262784215";
            sso_role_name = "AWSAdministratorAccess";
            region = "eu-central-1";
            output = "json";
          };
          "profile production" = {
            sso_session = "production";
            sso_account_id = "915473064509";
            sso_role_name = "AWSAdministratorAccess";
            region = "eu-west-1";
            output = "json";
          };
          "profile sandbox" = {
            sso_session = "sandbox";
            sso_account_id = "932407112174";
            sso_role_name = "AWSAdministratorAccess";
            region = "eu-central-1";
            output = "json";
          };

          "sso-session devops" = {
            sso_start_url = "https://studyportals-aws.awsapps.com/start#";
            sso_region = "eu-west-1";
            sso_registration_scopes = "sso:account:access";
          };
          "sso-session production" = {
            sso_start_url = "https://studyportals-aws.awsapps.com/start#";
            sso_region = "eu-west-1";
            sso_registration_scopes = "sso:account:access";
          };
          "sso-session sandbox" = {
            sso_start_url = "https://studyportals-aws.awsapps.com/start#";
            sso_region = "eu-west-1";
            sso_registration_scopes = "sso:account:access";
          };
        };

        git.userEmail = "prestonvantonder@studyportals.com";
        git.extraConfig.gpg.ssh.program = mkIf wsl "/mnt/c/Users/PrestonvanTonder/AppData/Local/1Password/app/8/op-ssh-sign.exe";
        git.extraConfig.user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICTceNH3o6069sOeRT/HmdBctb31UMdJXd1lgSYRytPy";
      };

      xdg.configFile = {
        "Yubico/u2f_keys".source = ./Yubico/u2f_keys;
      };
    };
  };
}
