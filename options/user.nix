{ lib, ... }: {
  options = with lib; {
    user.identifier = mkOption {
      type = types.str;
      description = "The identifier for the user of the system.";
      example = "johndoe";
    };

    user.name = mkOption {
      type = types.str;
      description = "The name for the user of the system.";
      example = "John Doe";
    };
  };
}
