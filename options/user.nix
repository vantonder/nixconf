{ lib, ... }: {
  options = {
    user = lib.mkOption {
      type = lib.types.attrs;
      description = "Information regarding the primary user of the system";
      example = ''
        user = {
          name = "johndoe";         # The username of the user
          description = "John Doe"; # The display name of the user
        };
      '';
    };
  };
}
