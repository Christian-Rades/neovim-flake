{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim;
in {
  config = {
    vim.nnoremap = {
      "<leader>pv" = "<cmd> Ex<CR>";
    };
  };
}
