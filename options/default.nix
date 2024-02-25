{ lib, ...}: {
  options = with lib; {
    user = mkOption {
      type = types.str;
      description = "The identifier for the user of the system.";
      example = "johndoe";
    };

    name = mkOption {
      type = types.str;
      description = "The name for the user of the system.";
      example = "John Doe";
    };

    git.author = mkOption {
      type = types.str;
      description = "The full name of the commit author.";
      example = "John Doe";
    };

    git.email = mkOption {
      type = types.str;
      description = "The email address of the commit author.";
      example = "john@doe.com";
    };

    dirs.home = mkOption {
      type = types.str;
      description = "The home directory of the user.";
      example = "/home/johndoe";
    };

    dirs.development = mkOption {
      type = types.str;
      description = "The directory that will be used for development work.";
      example = "$HOME/development";
    };

    wsl.enable = mkEnableOption (mdDoc "WSL");
  };
}
