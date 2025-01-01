local vim = vim
----------------------------------------------------------------------------------------
-- General settings
----------------------------------------------------------------------------------------
vim.o.ignorecase = true                                      -- If true, ignore case in search pattern
vim.o.relativenumber = true                                  -- If true, show relative line numbers
vim.o.number = true                                          -- If true, show absolute line numbers
vim.o.shiftwidth = 2                                         -- Number of spaces to use for each step of (auto)indent
vim.o.smarttab = true                                        -- If true, insert indents automatically
vim.o.expandtab = true                                       -- If true, convert tabs to spaces
vim.o.hlsearch = true                                        -- If true, highlight search results
vim.g.mapleader = "\\"                                       -- Set leader key
vim.o.termguicolors = true                                   -- If true, use 24-bit RGB colors in the terminal
vim.keymap.set("n", "<ESC>", ":noh<ESC>", { silent = true }) -- Clear search highlights after pressing enter
vim.keymap.set({ "n", "v" }, "<c-u>", "<c-u>zz")             -- Center after scrolling up
vim.keymap.set({ "n", "v" }, "<c-d>", "<c-d>zz")             -- Center after scrolling down
vim.keymap.set({ "n", "v" }, "n", "nzz")                     -- Center after jumping to next match
vim.keymap.set({ "n", "v" }, "N", "Nzz")                     -- Center after jumping to previous match
vim.keymap.set("n", "<leader>nd", function() vim.diagnostic.goto_next({ float = false }) end)
vim.keymap.set("n", "<leader>pd", function() vim.diagnostic.goto_prev({ float = false }) end)
vim.diagnostic.config({
  virtual_text = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "",
    }
  }
})
----------------------------------------------------------------------------------------
-- Bootstrap lazy
----------------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.notify("Lazy not found, cloning...", "info", { title = "Lazy" })
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)
----------------------------------------------------------------------------------------
-- Setup lazy and plugins
----------------------------------------------------------------------------------------
require("lazy").setup({
  {
    "rebelot/kanagawa.nvim",
    config = function()
      vim.cmd("colorscheme kanagawa-wave")
    end,
  },
  { "nvim-tree/nvim-web-devicons" },
  {
    "junegunn/fzf",
    config = function()
      vim.keymap.set("n", "<C-f>", ":FZF<CR>", { noremap = true })
    end,
  },
  { "jinh0/eyeliner.nvim" },
  {
    "goolord/alpha-nvim",
    config = function()
      require("alpha").setup(require("alpha.themes.startify").config)
    end,
  },
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    config = function()
      vim.keymap.set("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>")
      vim.keymap.set("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>")
      vim.keymap.set("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>")
      vim.keymap.set("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>")
    end,
  },
  {
    "RyanMillerC/better-vim-tmux-resizer",
  },
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'palenight',
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'diagnostics' },
          lualine_c = { { 'branch', icon = '' }, 'diff' },
          lualine_x = { 'os.date("%H:%M | %a, %d-%m-%y")' },
          lualine_y = {
            {
              'filename',
              path = 1,
            }
          },
          lualine_z = {
            'location'
          },
        }
      }
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup({
        sort = {
          sorter = "case_sensitive",
        },
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = false,
          git_ignored = false,
        },
      })
      vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>")
    end,
  },
  {
    "folke/trouble.nvim",
    opts = {},
    cmd = "Trouble",
    keys = {
      {
        "<leader>td",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "(Trouble) Diagnostics for current buffer",
      },
      {
        "<leader>qf",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "(Trouble) Quickfix list",
      }
    }
  },
  {
    'lervag/vimtex',
    lazy = false,
    init = function()
      vim.g.vimtex_view_method = 'zathura'
      vim.g.vimtex_latexmk_automatic = 1
      vim.g.vimtex_quickfix_enabled = 0
      vim.g.vimtex_syntax_enabled = 0
      vim.g.vimtex_root_markers = { '.latexmkrc', '.git' }
      vim.keymap.set("n", "<leader>ls", ':VimtexView<CR>')
      vim.keymap.set("n", "<leader>lc", ':VimtexCompile<CR>')
      vim.keymap.set("n", "<leader>lo", ':VimtexCompileOutput<CR>')
    end
  },
  -- LSP
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v4.x",
    dependencies = {
      -- LSP Support
      { "neovim/nvim-lspconfig" },
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },

      -- Copilot
      {
        "github/copilot.vim",
        config = function()
          vim.g.copilot_no_tab_map = true
          vim.keymap.set("i", "<C-l>", 'copilot#Accept("<CR>")', { silent = true, expr = true, replace_keycodes = false })
          local status = 'enable'
          function ToggleCopilot()
            status = status == 'enable' and 'disable' or 'enable'
            vim.cmd('Copilot ' .. status)
            vim.notify('Copilot ' .. status .. 'd', 'info', { title = 'Copilot' })
          end

          vim.keymap.set("n", "<leader>tc", ':lua ToggleCopilot()<CR>', { noremap = true, silent = true })
        end,
      },

      -- Snippets
      { "L3MON4D3/LuaSnip" },

      -- Auto-completion
      { "hrsh7th/nvim-cmp" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "saadparwaiz1/cmp_luasnip" },
      { "hrsh7th/cmp-nvim-lua" },
    },
    config = function()
      local lsp_zero = require('lsp-zero')

      local lsp_attach = function(_, bufnr)
        lsp_zero.default_keymaps({ buffer = bufnr, perserve_mappings = false })
      end

      lsp_zero.extend_lspconfig({
        lsp_attach = lsp_attach,
        set_lsp_keymaps = true,
      })

      require('mason').setup({})
      require('mason-lspconfig').setup({
        ensure_installed = { 'clangd', 'hls', 'lua_ls', 'cmake', 'rust_analyzer', 'texlab', 'ltex' },
        handlers = {
          function(server_name)
            require('lspconfig')[server_name].setup({})
          end,
        }
      })

      local cmp = require('cmp')

      cmp.setup({
        sources = {
          { name = 'nvim_lsp' },
        },
        snippet = {
          expand = function(args)
            -- You need Neovim v0.10 to use vim.snippet
            vim.snippet.expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<C-j>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ['<C-u>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        }),
      })

      -- Format on save
      vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function()
          vim.lsp.buf.format({ async = false })
          vim.diagnostic.enable(vim.diagnostic.is_enabled())
        end,
      })
    end,
  },
})
