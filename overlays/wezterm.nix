{ inputs, system }: final: prev: {
  wezterm = inputs.wezterm.packages.${system}.default;
}
