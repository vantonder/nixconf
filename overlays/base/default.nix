with builtins;
map (file: import (./. + "/${file}"))
  (filter (file: file != "default.nix" && match ".*\\.nix" file != null)
    (attrNames (readDir ./.)))
