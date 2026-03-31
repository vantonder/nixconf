{ ... }@_haumeaArgs: {
  notDetected = { modulesPath, ... }@_nixosModuleArgs: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];
  };
}
