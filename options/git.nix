{ lib, ... }: {
  options = with lib; {
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
  };
}
