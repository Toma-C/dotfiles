-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
--

-- ctrl s save
lvim.keys.normal_mode["<C-s>"] = ":w<CR>"

lvim.keys.normal_mode["j"] = "gj"
lvim.keys.normal_mode["k"] = "gk"

lvim.keys.normal_mode["<C-j>"] = ":m .+1<CR>"
lvim.keys.normal_mode["<C-k>"] = ":m .-2<CR>"

lvim.keys.normal_mode["<A-h>"] = "<C-w>h"
lvim.keys.normal_mode["<A-j>"] = "<C-w>j"
lvim.keys.normal_mode["<A-k>"] = "<C-w>k"
lvim.keys.normal_mode["<A-l>"] = "<C-w>l"

--splits
lvim.keys.normal_mode["|"] = ":vsplit<CR>"
lvim.keys.normal_mode["-"] = ":split<CR>"

--noh
lvim.keys.normal_mode["<CR>"] = ":noh<CR>"

--tabs
lvim.keys.normal_mode["<A-t>"] = ":tabnew<CR>"
lvim.keys.normal_mode["<A-tab>"] = ":tabNext<CR>"
lvim.keys.normal_mode["<C-tab>"] = ":bn<CR>"

--lvim.keys.term_mode["<Esc>"] = [[<C-\>]]

lvim.colorscheme = "silentium"
lvim.plugins = {
  {"silentium-theme/silentium.nvim",
  config = function()
      require("silentium").setup({
        accent = "#E4950E",
      })
    end,
  },
}
lvim.autocommands = {
  {
    {"ColorScheme"},
    {
      pattern = "*",
      callback = function()
        vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#E4950E", bg = "NONE", bold = true })
      end,
    },
  },
}

lvim.builtin.which_key.mappings["t"] = {
  name = "+Terminal",
  f = { "<cmd>ToggleTerm<cr>", "Floating terminal" },
  v = { "<cmd>2ToggleTerm size=30 direction=vertical<cr>", "Split vertical" },
  h = { "<cmd>2ToggleTerm size=30 direction=horizontal<cr>", "Split horizontal" },
}

-- Enable line wrapping
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
--autopwd
vim.opt.autochdir = true


