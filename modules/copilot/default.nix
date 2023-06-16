{
  pkgs,
    lib,
    config,
    ...
}:
with lib;
with builtins; let
cfg = config.vim.gh-copilot;
in {
  options.vim = {
    gh-copilot = {
      enable = mkEnableOption "gh-copilot";
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = [
      "gh-copilot"
    ];

    vim.luaConfigRC.gh-copilot = nvim.dag.entryAnywhere ''
      require('copilot').setup({
          panel = {
          enabled = true,
          auto_refresh = false,
          keymap = {
          jump_prev = "<C-k>",
          jump_next = "<C-j>",
          accept = "<CR>",
          refresh = "gr",
          open = "<M-CR>"
          },
          layout = {
          position = "bottom", -- | top | left | right
          ratio = 0.4
          },
          },
          suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = false,
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
          },
          filetypes = {
            yaml = false,
            markdown = false,
            help = false,
            gitcommit = false,
            gitrebase = false,
            hgcommit = false,
            svn = false,
            cvs = false,
            ["."] = false,
          },
          copilot_node_command = '${pkgs.nodejs-18_x}/bin/node', -- Node.js version must be > 16.x
            server_opts_overrides = {},
      })
    vim.keymap.set('i', '<Tab>', function()
        if require("copilot.suggestion").is_visible() then
        require("copilot.suggestion").accept()
        else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
        end
        end, { desc = "Super Tab" })
    '';
  };
}
