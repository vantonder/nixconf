{ inputs, system }: self: super: {
  wezterm = inputs.wezterm.packages.${system}.default;
}
