{ lib, ... }: {
  options = {
    git = lib.mkOption {
      type = lib.types.attrs;
      description = "Information relating to Git";
      example = ''
        git = {
          name = "John Doe";             # The name of the commit author
          email = "johndoe@example.com"; # The email of the commit author
        };
      '';
    };
  };
}
