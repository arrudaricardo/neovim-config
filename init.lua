vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[ Setting options ]]
--
vim.opt.termguicolors = true -- True color support

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, for help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true
-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'
-- Don't show the mode, since it's already in status line
vim.opt.showmode = false
-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = 'unnamedplus'
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.breakindent = true -- Enable break indent
-- vim.opt.colorcolumn = '100'
vim.opt.wrap = false
vim.opt.undofile = true -- Save undo history
vim.opt.ignorecase = true -- Case-insensitive searching UNLESS \C or capital in search
vim.opt.smartcase = true -- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'
-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true
-- Sets how neovim will display certain whitespace in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'
-- Show which line your cursor is on
vim.opt.cursorline = true
-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10
-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true

-- [[ Basic Keymaps ]]

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true, desc = 'Next search result' })
vim.keymap.set('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
vim.keymap.set('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
vim.keymap.set('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true, desc = 'Prev search result' })
vim.keymap.set('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result' })
vim.keymap.set('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result' })

-- save file
vim.keymap.set({ 'i', 'x', 'n', 's' }, '<D-s>', '<cmd>w<cr><esc>', { desc = 'Save file' })

-- better indenting
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

--  Use CTRL+<hjkl> to switch between windows
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Format ]]
vim.keymap.set('n', '<space>lf', '<cmd>lua vim.lsp.buf.format{async = true}<CR>', { desc = 'Format' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- TODO: DO I NEED THIS since gbprod/yanky.nvim ?
-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
-- vim.api.nvim_create_autocmd('TextYankPost', {
--   desc = 'Highlight when yanking (copying) text',
--   group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
--   callback = function()
--     vim.highlight.on_yank()
--   end,
-- })

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- LSP Configuration
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })

vim.diagnostic.config {
  float = {
    border = 'rounded',
  },
  virtual_text = false,
}

--
require('lazy').setup {
  -- TODO: DO I NEED THIS?
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {
      modes = {
        search = {
          enabled = false,
        },
      },
    },
  -- stylua: ignore
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
  },

  -- better diagnostics list and others
  {
    'folke/trouble.nvim',
    cmd = { 'TroubleToggle', 'Trouble' },
    opts = { use_diagnostic_signs = true },
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
      { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics (Trouble)' },
      { '<leader>cs', '<cmd>Trouble symbols toggle focus=false<cr>', desc = 'Symbols (Trouble)' },
      {
        '<leader>cS',
        '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
        desc = 'LSP references/definitions/... (Trouble)',
      },
      { '<leader>xL', '<cmd>Trouble loclist toggle<cr>', desc = 'Location List (Trouble)' },
      { '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix List (Trouble)' },
      {
        '[q',
        function()
          if require('trouble').is_open() then
            require('trouble').prev { skip_groups = true, jump = true }
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = 'Previous Trouble/Quickfix Item',
      },
    },
  },

  -- Adds git related signs to the gutter, as well as utilities for managing changes
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
     -- stylua: ignore start
    keys = {
      { '<leader>hs', mode = { 'n' }, function() require('gitsigns').stage_hunk() end, desc = 'Stage Hunk' },
      { '<leader>hs', mode = { 'v' }, function() require('gitsigns').stage_hunk{vim.fn.line('.'), vim.fn.line('v')} end, desc = 'Stage Hunk' },
      { '<leader>hr', mode = { 'n' }, function() require('gitsigns').reset_hunk() end, desc = 'Reset Hunk' },
      { '<leader>hr', mode = { 'v' }, function() require('gitsigns').reset_hunk{vim.fn.line('.'), vim.fn.line('v')} end, desc = 'Reset Hunk' },
      { '<leader>hn', mode = { 'n' }, function() require('gitsigns').next_hunk() end, desc = 'Next Hunk' },
      { '<leader>hp', mode = { 'n' }, function() require('gitsigns').prev_hink() end, desc = 'Prev  Hunk' },
      { '<leader>hv', mode = { 'n' }, function() require('gitsigns').preview_hunk() end, desc = 'Preview Hunk' },
      { '<leader>hS', mode = { 'n' }, function() require('gitsigns').stage_buffer() end, desc = 'Stage Buffer' },
      { '<leader>hu', mode = { 'n' }, function() require('gitsigns').undo_stage_hunk() end, desc = 'Undo Stage Hunk' },
      { '<leader>hR', mode = { 'n' }, function() require('gitsigns').reset_buffer() end, desc = 'Reset Buffer' },
      { '<leader>hp', mode = { 'n' }, function() require('gitsigns').preview_hunk() end, desc = 'Preview Hunk' },
      { '<leader>hb', mode = { 'n' }, function() require('gitsigns').blame_line{full=true} end, desc = 'Blame Line (Full)' },
      { '<leader>tb', mode = { 'n' }, function() require('gitsigns').toggle_current_line_blame() end, desc = 'Toggle Current Line Blame' },
      { '<leader>hd', mode = { 'n' }, function() require('gitsigns').diffthis() end, desc = 'Diff This' },
      { '<leader>hD', mode = { 'n' }, function() require('gitsigns').diffthis('~') end, desc = 'Diff Against Previous Version' },
      { '<leader>td', mode = { 'n' }, function() require('gitsigns').toggle_deleted() end, desc = 'Toggle Deleted' },
    }
    -- stylua: ignore end
,
  },

  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    config = function()
      require('which-key').setup {
        -- Insert any setup configurations here if relevant
        plugins = {
          marks = true, -- shows a list of your marks on ' and `
          registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
          spelling = { -- enabling this will show WhichKey when pressing z= to select spelling suggestions
            enabled = true,
            suggestions = 20, -- how many suggestions should be shown in the list?
          },
          -- ... other configurations as needed
        },
        layout = {
          spacing = 6, -- spacing between columns
          align = 'center', -- align columns left, center or right
        },
      }

      require('which-key').register {
        ['<leader>l'] = { name = 'LSP', _ = 'which_key_ignore' },
        ['<leader>d'] = { name = 'Debug', _ = 'which_key_ignore' },
        ['<leader>f'] = { name = 'Find', _ = 'which_key_ignore' },
        ['<leader>o'] = { name = 'Overseer', _ = 'which_key_ignore' },
        ['<leader>b'] = { name = 'Buffer', _ = 'which_key_ignore' },
        ['<leader>g'] = { name = 'Git', _ = 'which_key_ignore' },
      }
    end,
  },
  {
    'ibhagwan/fzf-lua',
    -- optional for icon support
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    enabled = false,
    config = function()
      -- calling `setup` is optional for customization
      require('fzf-lua').setup {}
    end,

     -- stylua: ignore start
    keys = {
      -- Search
      { '<leader>ff', mode = { 'n', 'x', 'o' }, function() require('fzf-lua').git_files {} end, desc = 'Fzf Git Files' },
      { '<D-\\>', mode = { 'n', 'x', 'o' }, function() require('fzf-lua').git_files {} end, desc = 'Fzf Git Files' },
      { '<leader>ft', mode = { 'n' }, function() require('fzf-lua').live_grep {} end, desc = 'Fzf Live Grep' },
      { '<leader>fr', mode = { 'n' }, function() require('fzf-lua').resume {} end, desc = 'Fzf Resume' },
      { '<leader>fw', mode = { 'n' }, function() require('fzf-lua').grep_cword {} end, desc = 'Fzf under cursor word' },
      { '<leader>fw', mode = { 'v' }, function() require('fzf-lua').grep_visual {} end, desc = 'Fzf grep selected' },
      { '<leader>fW', mode = { 'n' }, function() require('fzf-lua').grep_cWORD {} end, desc = 'Fzf under cursor WORD' },
      { '<C-/>', mode = { 'n' }, function() require('fzf-lua').buffers {} end, desc = 'Fzf buffers' },

      -- LSP 
      -- { 'gd', mode = { 'n' }, function() require('fzf-lua').lsp_definitions {} end, desc = 'Goto Definition' },
      -- { 'gr', mode = { 'n' }, function() require('fzf-lua').lsp_references {} end, desc = 'Goto References' },
      { 'gI', mode = { 'n' }, function() require('fzf-lua').lsp_implementations {} {} end, desc = 'Goto Type definition' },
      { 'gt', mode = { 'n' }, function() require('fzf-lua').lsp_typedefs {} end, desc = 'Goto Type definition' },


  --     vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = 'Lists Diagnostics for all open buffers or a specific buffer. Use option bufnr=0 for current buffer.' })
  --     vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = 'Lists the results incl. multi-selections of the previous picker' })
    },
    -- stylua: ignore end
  },

  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      { 'nvim-tree/nvim-web-devicons' },
      {
        'nvim-telescope/telescope-live-grep-args.nvim',
        version = '^1.0.0',
      },
    },
    config = function()
      require('telescope').setup {
        defaults = {
          wrap_results = true,
          sorting_strategy = 'ascending',
          path_display = { 'truncate' },
        },
        pickers = {
          oldfiles = {
            initial_mode = 'normal',
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable telescope extensions, if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
    end,

    -- stylua: ignore start
    keys = {
      { "gd", mode = { "n" }, function() require('telescope.builtin').lsp_definitions() end, desc = "Goto Definition" },
      { "gr", mode = { "n" }, function() require('telescope.builtin').lsp_references() end, desc = "Goto References" },
      { "gt", mode = { "n" }, function() require('telescope.builtin').lsp_type_definitions() end, desc = "Goto Type definition" },

      { "<leader>sh", mode = { "n" }, function() require('telescope.builtin').help_tags() end, desc = 'Find Help' },
      { "<leader>fb", mode = { "n" }, function() require('telescope.builtin').current_buffer_fuzzy_find() end, desc = 'Current Buffer Fuzzy Find' },
      { "<leader>fc", mode = { "n" }, function() require('telescope.builtin').colorscheme() end, desc = 'Find Colorscheme' },
      { "<leader>fq", mode = { "n" }, function() require('telescope.builtin').quickfix() end, desc = 'Find quickfix' },
      { "<leader>fk", mode = { "n" }, function() require('telescope.builtin').keymaps() end, desc = 'Find Keymaps' },
      { "<leader>ff", mode = { "n" }, function() require('telescope.builtin').find_files() end, desc = 'Lists files in your current working directory, respects .gitignore' },
      { "<D-p>", mode = { "n" }, function() require('telescope.builtin').find_files() end, desc = 'Lists files in your current working directory, respects .gitignore' },
      { "<leader>fs", mode = { "n" }, function() require('telescope.builtin').builtin() end, desc = 'Find builtin ' },
      { "<leader>fg", mode = { "n" }, function() require('telescope.builtin').git_files() end, desc = 'Fuzzy search through the output of git ls-files command, respects .gitignore' },
      { "<leader>fw", mode = { "n" }, function() require('telescope.builtin').grep_string() end, desc = 'Searches for the string under your cursor or selection in your current working directory' },
      { "<leader>fg", mode = { "n" }, function() require('telescope.builtin').git_status() end, desc = 'Searches GIT modified files' },
      { "<leader>ft", mode = { "n" }, function() require('telescope').extensions.live_grep_args.live_grep_args() end, desc = 'Search for a string in your current working directory and get results live as you type, respects .gitignore.' },
      { "<leader>fd", mode = { "n" }, function() require('telescope.builtin').diagnostics() end, desc = 'Lists Diagnostics for all open buffers or a specific buffer. Use option bufnr=0 for current buffer.' },
      { "<leader>fr", mode = { "n" }, function() require('telescope.builtin').resume() end, desc = 'Lists the results incl. multi-selections of the previous picker' },
      { "<leader>fm", mode = { "n" }, function() require('telescope.builtin').marks() end, desc = 'Lists vim marks and their value' },
      { "<leader>f.", mode = { "n" }, function() require('telescope.builtin').oldfiles() end, desc = 'Find Recent Files ("." for repeat)' },
      { "<leader><leader>", mode = { "n" }, function() require('telescope.builtin').buffers() end, desc = 'Find existing buffers' }
    },
    -- stylua: ignore end
  },

  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },
    },
    opts = {
      inlay_hints = { enabled = true },
    },
    config = function()
      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself
          -- many times.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gD', vim.lsp.buf.declaration, 'Goto Declaration')

          -- map('<leader>fs', require('telescope.builtin').lsp_document_symbols, 'Lists LSP document symbols in the current buffer')
          -- map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

          map('<leader>lr', vim.lsp.buf.rename, 'LSP Rename')

          map('<leader>la', vim.lsp.buf.code_action, 'LSP Action')

          -- Git
          -- map(
          --   '<leader>gc',
          --   require('telescope.builtin').git_commits,
          --   'Lists git commits with diff preview, checkout action <cr>, reset mixed <C-r>m, reset soft <C-r>s and reset hard <C-r>h'
          -- )
          -- map('<leader>gc', require('telescope.builtin').git_commits, 'Git commits')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,

        require('lspconfig').gleam.setup {},

        require('lspconfig').rust_analyzer.setup {
          settings = {
            ['rust-analyzer'] = {
              check = {
                command = 'clippy',
              },
              diagnostics = {
                enable = true,
              },
            },
          },
        },
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP Specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        -- clangd = {},
        -- gopls = {},
        -- pyright = {},
        -- rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`tsserver`) will work just fine
        -- tsserver = {},
        --

        lua_ls = {
          -- cmd = {...},
          -- filetypes { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              runtime = { version = 'LuaJIT' },
              workspace = {
                checkThirdParty = false,
                -- Tells lua_ls where to find all the Lua files that you have loaded
                -- for your neovim configuration.
                library = {
                  '${3rd}/luv/library',
                  unpack(vim.api.nvim_get_runtime_file('', true)),
                },
                -- If lua_ls is really slow on your computer, you can try this instead:
                -- library = { vim.env.VIMRUNTIME },
              },
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      -- Ensure the servers and tools above are installed
      --  To check the current status of installed tools and/or manually install
      --  other tools, you can run
      --    :Mason
      --
      --  You can press `g?` for help in this menu
      require('mason').setup()

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format lua code
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    opts = {
      notify_on_error = false,
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        python = { 'isort', 'black' },
        --
        -- You can use a sub-list to tell conform to run *until* a formatter
        typescript = { { 'prettierd', 'prettier' } },
        typescriptreact = { { 'prettierd', 'prettier' } },
        javascript = { { 'prettierd', 'prettier' } },
        javascriptreact = { { 'prettierd', 'prettier' } },
        json = { { 'prettierd', 'prettier' } },
        html = { { 'prettierd', 'prettier' } },
        css = { { 'prettierd', 'prettier' } },
      },
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },

  -- Sorting plugin for Neovim that supports line-wise and delimiter sorting.
  {
    'sQVe/sort.nvim',
    config = true,
  },

  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets
          -- This step is not supported in many windows environments
          -- Remove the below condition to re-enable on windows
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
      },
      'hrsh7th/cmp-nvim-lsp',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
    },
    config = function()
      -- See `:help cmp`
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      local compare = require 'cmp.config.compare'
      local copilot_suggestion = require 'copilot.suggestion'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },

        -- :help ins-completion
        mapping = cmp.mapping.preset.insert {
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() and not copilot_suggestion.is_visible() then
              cmp.confirm { select = true }
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<C-n>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
          ['<C-p>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-y>'] = cmp.mapping.confirm { select = true },
          ['<CR>'] = cmp.mapping.confirm { select = true },
          ['<C-Space>'] = cmp.mapping.complete {},
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),

          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
        },
        sources = cmp.config.sources {
          { name = 'nvim_lsp', priority = 10 },
          { name = 'luasnip' },
          { name = 'buffer', keyword_length = 5, max_item_count = 5 },
          { name = 'path' },
        },
        experimental = {
          ghost_text = {
            hl_group = 'CmpGhostText',
          },
        },
        sorting = {
          comparators = {
            compare.recently_used,
            compare.offset,
            compare.exact,
            compare.score,
            compare.locality,
            compare.kind,
            compare.sort_text,
            compare.length,
            compare.order,
          },
        },
      }
    end,
  },

  {
    'Mofiqul/dracula.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      local dracula = require 'dracula'
      dracula.setup {
        colors = {
          bg = '#282A36',
          fg = '#F8F8F2',
          selection = '#44475A',
          comment = '#6272A4',
          red = '#FF5555',
          orange = '#FFB86C',
          yellow = '#F1FA8C',
          green = '#50fa7b',
          purple = '#BD93F9',
          cyan = '#8BE9FD',
          pink = '#FF79C6',
          -- bright_red = '#FF6E6E',
          -- bright_green = '#69FF94',
          -- bright_yellow = '#FFFFA5',
          -- bright_blue = '#D6ACFF',
          -- bright_magenta = '#FF92DF',
          -- bright_cyan = '#A4FFFF',
          -- bright_white = '#FFFFFF',
          -- menu = '#21222C',
          -- visual = '#3E4452',
          -- gutter_fg = '#4B5263',
          -- nontext = '#3B4048',
          -- white = '#ABB2BF',
          -- black = '#191A21',
        },
        -- show the '~' characters after the end of buffers
        show_end_of_buffer = true, -- default false
        -- use transparent background
        -- transparent_bg = true, -- default false
        -- set custom lualine background color
        lualine_bg_color = '#44475a', -- default nil
        -- set italic comment
        italic_comment = true, -- default false
        -- overrides the default highlights with table see `:h synIDattr`
        overrides = {},
        -- You can use overrides as table like this
        -- overrides = {
        --   NonText = { fg = "white" }, -- set NonText fg to white
        --   NvimTreeIndentMarker = { link = "NonText" }, -- link to NonText highlight
        --   Nothing = {} -- clear highlight of Nothing
        -- },
        -- Or you can also use it like a function to get color from theme
        -- overrides = function (colors)
        --   return {
        --     NonText = { fg = colors.white }, -- set NonText fg to white of theme
        --   }
        -- end,
      }
      vim.cmd [[colorscheme dracula]]
    end,
  },

  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  -- Highlight, edit, and navigate code
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {
      -- 'nvim-treesitter/nvim-treesitter-refactor',
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/nvim-treesitter-context',
      -- 'nvim-treesitter/nvim-treesitter-highlight',
      -- 'nvim-treesitter/nvim-treesitter-indent',
    },
    config = function()
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup {
        ensure_installed = { 'bash', 'c', 'html', 'lua', 'markdown', 'vim', 'vimdoc' },
        -- Autoinstall languages that are not installed
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      }

      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
      require('treesitter-context').setup {
        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
        min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        line_numbers = true,
        multiline_threshold = 10, -- Maximum number of lines to show for a single context
        trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        mode = 'cursor', -- Line used to calculate context. Choices: 'cursor', 'topline'
        -- Separator between context and content. Should be a single character string, like '-'.
        -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
        separator = nil,
        zindex = 20, -- The Z-index of the context window
        on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
      }
      vim.cmd [[hi TreesitterContextLineNumberBottom gui=underline guisp=Grey]]
    end,
  },

  -- A task runner and job management plugin for Neovim
  {
    'stevearc/overseer.nvim',
    config = true,
    init = function()
      -- TODO: add to keys
      vim.keymap.set('n', '<leader>oo', '<cmd>OverseerToggle bottom<cr>', { silent = true, desc = 'Toggle' })
      vim.keymap.set('n', '<leader>or', '<cmd>OverseerRun<cr>', { silent = true, desc = 'Run' })
      vim.keymap.set('n', '<leader>oi', '<cmd>OverseerInfo<cr>', { silent = true, desc = 'Info' })
      vim.keymap.set('n', '<leader>oa', '<cmd>OverseerQuickAction<cr>', { silent = true, desc = 'Action' })
    end,
  },

  {
    'ThePrimeagen/harpoon',
    enabled = false,
    branch = 'harpoon2',
    opts = {
      menu = {
        width = vim.api.nvim_win_get_width(0) - 4,
      },
      settings = {
        save_on_toggle = true,
      },
    },
    keys = function()
      local keys = {
        {
          '<leader>k',
          function()
            require('harpoon'):list():add()
          end,
          desc = 'Harpoon Add File',
        },
        {
          '<leader>h',
          function()
            local harpoon = require 'harpoon'
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
          desc = 'Harpoon Quick Menu',
        },
      }

      for i = 1, 5 do
        table.insert(keys, {
          '<leader>' .. i,
          function()
            require('harpoon'):list():select(i)
          end,
          desc = 'Harpoon to File ' .. i,
        })
      end
      return keys
    end,
  },

  -- lsp symbol navigation for lualine
  {
    'SmiteshP/nvim-navic',
    lazy = true,
    config = true,
  },

  -- Autopairs
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
  },

  -- Edit and review GitHub issues and pull requests from the comfort of your favorite editor
  {
    'pwntester/octo.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      { 'kyazdani42/nvim-web-devicons', name = 'kyazdani42-nvim-web-devicons' },
    },
    config = function()
      require('octo').setup {
        {
          suppress_missing_scope = {
            projects_v2 = true,
          },
        },
      }
    end,
  },

  {
    'nvim-telescope/telescope-file-browser.nvim',
    enabled = false,
    dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
    -- keys = {
    --   { '<leader>e', ':Telescope file_browser path=%:p:h select_buffer=true<CR>', desc = 'Toggle Telescope file broswer', mode = { 'n' } },
    -- },
  },

  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons',
      {
        -- only needed if you want to use the commands with "_with_window_picker" suffix
        's1n7ax/nvim-window-picker',
        --tag = "v1.*",
        config = function()
          require('window-picker').setup {
            autoselect_one = true,
            include_current = false,
            filter_rules = {
              -- filter using buffer options
              bo = {
                -- if the file type is one of following, the window will be ignored
                filetype = { 'neo-tree', 'neo-tree-popup', 'notify' },
                -- if the buffer type is one of following, the window will be ignored
                buftype = { 'terminal', 'quickfix' },
              },
            },
            other_win_hl_color = '#e35e4f',
          }
        end,
      },
    },
    config = function()
      require('neo-tree').setup {
        buffers = {
          follow_current_file = {
            enabled = true,
            leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
          },
        },
        filesystem = {
          hijack_netrw_behavior = 'open_current',
          follow_current_file = {
            enabled = true,
            leave_dirs_open = false,
          },
          filtered_items = {
            hide_dotfiles = false,
            hide_gitignore = false,
          },
        },
      }
    end,
    lazy = false,
    keys = {
      { '<leader>e', '<cmd>Neotree toggle filesystem reveal_force_cwd position=left<cr>', desc = 'Toggle Explorer', mode = { 'n' } },
    },
  },

  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      local Terminal = require('toggleterm.terminal').Terminal
      local toggleterm = require 'toggleterm'

      toggleterm.setup {
        shell = vim.o.shell,
      }

      -- TODO: open lazygit file from inside nvim
      local lazygit = Terminal:new {
        cmd = 'lazygit',
        dir = 'git_dir',
        -- hidden = true,
        direction = 'float',
        float_opts = {
          border = 'none',
        },
        -- function to run on opening the terminal
        on_open = function(_term)
          vim.cmd 'startinsert!'
          -- vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
        end,
        -- function to run on closing the terminal
        on_close = function(_term)
          vim.cmd 'startinsert!'
        end,
        count = 99,
      }

      local function _lazygit_toggle()
        lazygit:toggle()
      end

      vim.keymap.set('n', '<leader>gg', _lazygit_toggle, { noremap = true, silent = true, desc = 'Toggle Lazygit' })

      --

      function _G.set_terminal_keymaps()
        local opts = { buffer = 0 }
        vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
        vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
        vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
      end

      -- if you only want these mappings for toggle term use term://*toggleterm#* instead
      vim.cmd 'autocmd! TermOpen term://*toggleterm#1 lua set_terminal_keymaps()'

      -- Open term
      vim.keymap.set('n', '<c-\\>', [[<Cmd>:ToggleTerm size=35<CR>]], { noremap = true, silent = true })
      vim.keymap.set('t', '<c-\\>', [[<Cmd>:ToggleTerm size=35<CR>]], { noremap = true, silent = true })
    end,
  },

  {
    'zbirenbaum/copilot.lua',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {
        panel = {
          enabled = true,
          auto_refresh = true,
          keymap = {
            jump_prev = '[[',
            jump_next = ']]',
            accept = '<CR>',
            refresh = 'gr',
            open = '<M-CR>',
          },
          layout = {
            position = 'bottom', -- | top | left | right
            ratio = 0.4,
          },
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 50,
          keymap = {
            accept = '<C-y>',
            accept_word = false,
            accept_line = false,
            next = '<C-n>',
            prev = '<C-p>',
            dismiss = '<C-k>',
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
          ['.'] = false,
        },
        copilot_node_command = 'node', -- Node.js version must be > 18.x
        server_opts_overrides = {},
      }
      local cmp = require 'cmp'
      cmp.event:on('menu_opened', function()
        vim.b.copilot_suggestion_hidden = true
      end)

      cmp.event:on('menu_closed', function()
        vim.b.copilot_suggestion_hidden = false
      end)
    end,
  },

  -- 💥 Highly experimental plugin that completely replaces the UI for messages, cmdline and the popupmenu.
  {
    'folke/noice.nvim',
    enabled = false,
    event = 'VeryLazy',
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      'MunifTanjim/nui.nvim',
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      'rcarriga/nvim-notify',
    },
    config = function()
      require('noice').setup {
        require('noice').setup {
          lsp = {
            -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
            override = {
              ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
              ['vim.lsp.util.stylize_markdown'] = true,
              ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
            },
          },
          -- you can enable a preset for easier configuration
          presets = {
            bottom_search = true, -- use a classic bottom cmdline for search
            command_palette = true, -- position the cmdline and popupmenu together
            long_message_to_split = true, -- long messages will be sent to a split
            inc_rename = false, -- enables an input dialog for inc-rename.nvim
            lsp_doc_border = false, -- add a border to hover docs and signature help
          },
        },
      }
    end,
  },

  -- Not UFO in the sky, but an ultra fold in Neovim.
  -- TODO: add keymap
  {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
  },

  -- Open files and command output from wezterm, kitty, and neovim terminals in your current neovim instance
  {
    'willothy/flatten.nvim',
    config = true,
    -- or pass configuration with
    -- opts = {  }
    -- Ensure that it runs first to minimize delay when opening file from terminal
    lazy = false,
    priority = 1001,
  },

  -- A snazzy bufferline for Neovim
  -- TODO: add keymaps
  {
    -- 'akinsho/bufferline.nvim',
    -- version = '*',
    -- dependencies = 'nvim-tree/nvim-web-devicons',
    -- config = function()
    --   require('bufferline').setup {}
    --   vim.keymap.set('n', 'H', '<cmd>BufferLineCyclePrev<CR>', { desc = 'Cycle Previous Buffer' })
    --   vim.keymap.set('n', 'L', '<cmd>BufferLineCycleNext<CR>', { desc = 'Cycle Next Buffer' })
    --   vim.keymap.set('n', '<leader>bp', '<cmd>BufferLinePick<CR>', { desc = '[B]uffer [P]ick' })
    --   vim.keymap.set('n', '<leader>bo', '<cmd>BufferLineCloseOthers<CR>', { desc = '[B]uffer Close [O]thers' })
    --   vim.keymap.set('n', '<leader>bp', '<cmd>BufferLineTogglePin<CR>', { desc = '[B]uffer Toggle [P]in' })
    --   vim.keymap.set('n', '<leader>bP', '<cmd>BufferLineCloseOthers<CR>', { desc = '[B]uffer Delete non-[P]inned' })
    -- end,
  },
  -- Neovim plugin for a code outline window
  -- TODO: Add keymap
  {
    'stevearc/aerial.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
  },

  -- tokyonight
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    opts = {},
  },

  -- catppuccin
  {
    'catppuccin/nvim',
    disable = true,
    -- lazy = true,
    name = 'catppuccin',
    opts = {
      integrations = {
        aerial = true,
        alpha = true,
        cmp = true,
        dashboard = true,
        flash = true,
        gitsigns = true,
        headlines = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        leap = true,
        lsp_trouble = true,
        mason = true,
        markdown = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { 'undercurl' },
            hints = { 'undercurl' },
            warnings = { 'undercurl' },
            information = { 'undercurl' },
          },
        },
        navic = { enabled = true, custom_bg = 'lualine' },
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        semantic_tokens = true,
        -- telescope = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    },
  },

  -- nvim-surround
  {
    'kylechui/nvim-surround',
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup {}
    end,
  },

  -- better yank/paste
  {
    'gbprod/yanky.nvim',
    dependencies = not jit.os:find 'Windows' and { 'kkharji/sqlite.lua' } or {},
    opts = {
      highlight = {
        on_put = true,
        on_yank = true,
        timer = 250,
      },
      ring = { storage = jit.os:find 'Windows' and 'shada' or 'sqlite' },
    },
    keys = {
      -- stylua: ignore start
      -- { "<leader>p", function() require("telescope").extensions.yank_history.yank_history({}) end, desc = "Open Yank History" },
      { 'y',         '<Plug>(YankyYank)',                                                          mode = { 'n', 'x' },                                  desc = 'Yank text' },
      { 'p',         '<Plug>(YankyPutAfter)',                                                      mode = { 'n', 'x' },                                  desc = 'Put yanked text after cursor' },
      { 'P',         '<Plug>(YankyPutBefore)',                                                     mode = { 'n', 'x' },                                  desc = 'Put yanked text before cursor' },
      { 'gp',        '<Plug>(YankyGPutAfter)',                                                     mode = { 'n', 'x' },                                  desc = 'Put yanked text after selection' },
      { 'gP',        '<Plug>(YankyGPutBefore)',                                                    mode = { 'n', 'x' },                                  desc = 'Put yanked text before selection' },
      { '[y',        '<Plug>(YankyCycleForward)',                                                  desc = 'Cycle forward through yank history' },
      { ']y',        '<Plug>(YankyCycleBackward)',                                                 desc = 'Cycle backward through yank history' },
      { ']p',        '<Plug>(YankyPutIndentAfterLinewise)',                                        desc = 'Put yanked indented after cursor (linewise)' },
      { '[p',        '<Plug>(YankyPutIndentBeforeLinewise)',                                       desc = 'Put yanked indented before cursor (linewise)' },
      { ']P',        '<Plug>(YankyPutIndentAfterLinewise)',                                        desc = 'Put yanked indented after cursor (linewise)' },
      { '[P',        '<Plug>(YankyPutIndentBeforeLinewise)',                                       desc = 'Put yanked indented before cursor (linewise)' },
      { '>p',        '<Plug>(YankyPutIndentAfterShiftRight)',                                      desc = 'Put yanked and indent right' },
      { '<p',        '<Plug>(YankyPutIndentAfterShiftLeft)',                                       desc = 'Put yanked and indent left' },
      { '>P',        '<Plug>(YankyPutIndentBeforeShiftRight)',                                     desc = 'Put yanked before and indent right' },
      { '<P',        '<Plug>(YankyPutIndentBeforeShiftLeft)',                                      desc = 'Put yanked before and indent left' },
      { '=p',        '<Plug>(YankyPutAfterFilter)',                                                desc = 'Put yanked after applying a filter' },
      { '=P',        '<Plug>(YankyPutBeforeFilter)',                                               desc = 'Put yanked before applying a filter' },
      -- stylua: ignore end
    },
  },
  -- Indent guides for Neovim
  {
    'lukas-reineke/indent-blankline.nvim',
    opts = {
      indent = {
        char = '│',
        tab_char = '│',
      },
      scope = { enabled = true },
      exclude = {
        filetypes = {
          'help',
          'alpha',
          'dashboard',
          'neo-tree',
          'Trouble',
          'trouble',
          'lazy',
          'mason',
          'notify',
          'toggleterm',
          'lazyterm',
        },
      },
    },
    main = 'ibl',
    init = function() end,
  },

  -- A blazing fast and easy to configure neovim statusline plugin written in pure lua.
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = true,
  },

  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    opts = function()
      local opts = {
        theme = 'doom',
        hide = {
          -- this is taken care of by lualine
          -- enabling this messes up the actual laststatus setting after loading a file
          statusline = false,
        },
        config = {
          header = { 'Hi' },
          -- stylua: ignore
          center = {
            -- { action = Util.telescope("files"),                                    desc = " Find file",       icon = " ", key = "f" },
            { action = "ene | startinsert", desc = " New file", icon = " ", key = "n" },
            { action = [[lua require("lazyvim.util").telescope.config_files()()]], desc = " Config",          icon = " ", key = "c" },
            -- { action = 'lua require("persistence").load()',                        desc = " Restore Session", icon = " ", key = "s" },
            { action = "e ~/.config/nvim/init.lua", desc = " Open Neovim config", icon = " ", key = "c" },
            { action = "Lazy", desc = " Lazy", icon = "󰒲 ", key = "l" },
            -- { action = "qa", desc = " Quit", icon = " ", key = "q" },
          },
          footer = function()
            local stats = require('lazy').stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return { '⚡ Neovim loaded ' .. stats.loaded .. '/' .. stats.count .. ' plugins in ' .. ms .. 'ms' }
          end,
        },
      }

      for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(' ', 43 - #button.desc)
        button.key_format = '  %s'
      end

      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == 'lazy' then
        vim.cmd.close()
        vim.api.nvim_create_autocmd('User', {
          pattern = 'DashboardLoaded',
          callback = function()
            require('lazy').show()
          end,
        })
      end

      return opts
    end,
  },
  --
  {
    'mfussenegger/nvim-dap',

    dependencies = {

      -- fancy UI for the debugger
      {
        'rcarriga/nvim-dap-ui',
        -- stylua: ignore
        keys = {
          { "<leader>du", function() require("dapui").toggle({}) end, desc = "Dap UI" },
          { "<leader>de", function() require("dapui").eval() end,     desc = "Eval",  mode = { "n", "v" } },
        },
        opts = {},
        config = function(_, opts)
          -- setup dap config by VsCode launch.json file
          -- require("dap.ext.vscode").load_launchjs()
          local dap = require 'dap'
          local dapui = require 'dapui'
          dapui.setup(opts)
          dap.listeners.after.event_initialized['dapui_config'] = function()
            dapui.open {}
          end
          dap.listeners.before.event_terminated['dapui_config'] = function()
            dapui.close {}
          end
          dap.listeners.before.event_exited['dapui_config'] = function()
            dapui.close {}
          end
        end,
      },

      -- virtual text for the debugger
      {
        'theHamsta/nvim-dap-virtual-text',
        opts = {},
      },

      -- A library for asynchronous IO in Neovim
      { 'nvim-neotest/nvim-nio' },

      -- mason.nvim integration
      {
        'jay-babu/mason-nvim-dap.nvim',
        dependencies = 'mason.nvim',
        cmd = { 'DapInstall', 'DapUninstall' },
        opts = {
          -- Makes a best effort to setup the various debuggers with
          -- reasonable debug configurations
          automatic_installation = true,

          -- You can provide additional configuration to the handlers,
          -- see mason-nvim-dap README for more information
          handlers = {},

          -- You'll need to check that you have the required things installed
          -- online, please don't ask me how to install them :)
          ensure_installed = {
            -- Update this to ensure that you have the debuggers for the langs you want
          },
        },
      },

      -- Install the vscode-js-debug adapter
      {
        'microsoft/vscode-js-debug',
        -- After install, build it and rename the dist directory to out
        build = 'npm install --legacy-peer-deps --no-save && npx gulp vsDebugServerBundle && rm -rf out && mv dist out',
        version = '1.*',
      },
      {
        'mxsdev/nvim-dap-vscode-js',
        config = function()
          ---@diagnostic disable-next-line: missing-fields
          require('dap-vscode-js').setup {
            -- Path of node executable. Defaults to $NODE_PATH, and then "node"
            -- node_path = "node",

            -- Path to vscode-js-debug installation.
            debugger_path = vim.fn.resolve(vim.fn.stdpath 'data' .. '/lazy/vscode-js-debug'),

            -- Command to use to launch the debug server. Takes precedence over "node_path" and "debugger_path"
            -- debugger_cmd = { "js-debug-adapter" },

            -- which adapters to register in nvim-dap
            adapters = {
              'chrome',
              'pwa-node',
              'pwa-chrome',
              'pwa-msedge',
              'pwa-extensionHost',
              'node-terminal',
            },

            -- Path for file logging
            -- log_file_path = "(stdpath cache)/dap_vscode_js.log",

            -- Logging level for output to file. Set to false to disable logging.
            -- log_file_level = false,

            -- Logging level for output to console. Set to false to disable console output.
            -- log_console_level = vim.log.levels.ERROR,
          }
        end,
      },
      config = function()
        local dap = require 'dap'

        JS_BASED_LANGUAGES = {
          'typescript',
          'javascript',
          'typescriptreact',
          'javascriptreact',
          'vue',
        }

        for _, language in ipairs(JS_BASED_LANGUAGES) do
          dap.configurations[language] = {
            -- Debug single nodejs files
            {
              type = 'pwa-node',
              request = 'launch',
              name = 'Launch file',
              program = '${file}',
              cwd = vim.fn.getcwd(),
              sourceMaps = true,
            },
            -- Debug nodejs processes (make sure to add --inspect when you run the process)
            {
              type = 'pwa-node',
              request = 'attach',
              name = 'Attach',
              processId = require('dap.utils').pick_process,
              cwd = vim.fn.getcwd(),
              sourceMaps = true,
            },
            -- Debug web applications (client side)
            {
              type = 'pwa-chrome',
              request = 'launch',
              name = 'Launch & Debug Chrome',
              url = function()
                local co = coroutine.running()
                return coroutine.create(function()
                  vim.ui.input({
                    prompt = 'Enter URL: ',
                    default = 'http://localhost:3000',
                  }, function(url)
                    if url == nil or url == '' then
                      return
                    else
                      coroutine.resume(co, url)
                    end
                  end)
                end)
              end,
              webRoot = vim.fn.getcwd(),
              protocol = 'inspector',
              sourceMaps = true,
              userDataDir = false,
            },
            -- Divider for the launch.json derived configs
            {
              name = '----- ↓ launch.json configs ↓ -----',
              type = '',
              request = 'launch',
            },
          }
        end
      end,
    },
    -- stylua: ignore start
    keys = {
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end,                                    desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end,                                             desc = "Continue" },
      {
        "<leader>da",
        function()
          if vim.fn.filereadable(".vscode/launch.json") then
            local dap_vscode = require("dap.ext.vscode")
            dap_vscode.load_launchjs(nil, {
              ["pwa-node"] = JS_BASED_LANGUAGES,
              ["chrome"] = JS_BASED_LANGUAGES,
              ["pwa-chrome"] = JS_BASED_LANGUAGES,
            })
          end
          require("dap").continue()
        end,
        desc = "Run with Args",
      },
      { "<leader>dC", function() require("dap").un_to_cursor() end,    desc = "Run to Cursor" },
      { "<leader>dg", function() require("dap").goto_() end,            desc = "Go to line (no execute)" },
      { "<leader>di", function() require("dap").step_into() end,        desc = "Step Into" },
      { "<leader>dj", function() require("dap").down() end,             desc = "Down" },
      { "<leader>dk", function() require("dap").up() end,               desc = "Up" },
      { "<leader>dl", function() require("dap").run_last() end,         desc = "Run Last" },
      { "<leader>do", function() require("dap").step_out() end,         desc = "Step Out" },
      { "<leader>dO", function() require("dap").step_over() end,        desc = "Step Over" },
      { "<leader>dp", function() require("dap").pause() end,            desc = "Pause" },
      { "<leader>dr", function() require("dap").repl.toggle() end,      desc = "Toggle REPL" },
      { "<leader>ds", function() require("dap").session() end,          desc = "Session" },
      { "<leader>dt", function() require("dap").terminate() end,        desc = "Terminate" },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
    },
    -- stylua: ignore end
    --
  },
  {
    'robitx/gp.nvim',
    config = function()
      local conf = {
        providers = {
          openai = {
            disable = true,
            endpoint = 'https://api.openai.com/v1/chat/completions',
            secret = os.getenv 'OPENAI_API_KEY',
          },
          copilot = {
            disable = false,
            endpoint = 'https://api.githubcopilot.com/chat/completions',
            secret = {
              'bash',
              '-c',
              "cat ~/.config/github-copilot/hosts.json | sed -e 's/.*oauth_token...//;s/\".*//'",
            },
          },
        },
        chat_shortcut_respond = { modes = { 'n', 'i', 'v', 'x' }, shortcut = '<CR>' },
        chat_shortcut_delete = { modes = { 'n', 'i', 'v', 'x' }, shortcut = '<C-g>d' },
        chat_shortcut_stop = { modes = { 'n', 'i', 'v', 'x' }, shortcut = '<C-g>s' },
        chat_shortcut_new = { modes = { 'n', 'i', 'v', 'x' }, shortcut = '<C-n>' },

        chat_free_cursor = true,
      }
      require('gp').setup(conf)
    end,

    keys = {
      -- Cursor keymapping

      { '<D-l>', mode = { 'n', 'i' }, '<cmd>GpChatToggle<cr>', desc = 'GPT prompt Toggle Chat' },
      { '<D-l>', mode = 'v', ":<C-u>'<,'>GpChatToggle<cr>", desc = 'GPT prompt Visual Toggle Chat' },

      -- Chat commands
      { '<C-g>c', mode = { 'n', 'i' }, '<cmd>GpChatNew<cr>', desc = 'GPT prompt New Chat' },
      { '<C-g>t', mode = { 'n', 'i' }, '<cmd>GpChatToggle<cr>', desc = 'GPT prompt Toggle Chat' },
      { '<C-g>f', mode = { 'n', 'i' }, '<cmd>GpChatFinder<cr>', desc = 'GPT prompt Chat Finder' },
      { '<C-g>c', mode = 'v', ":<C-u>'<,'>GpChatNew<cr>", desc = 'GPT prompt Visual Chat New' },
      { '<C-g>p', mode = 'v', ":<C-u>'<,'>GpChatPaste<cr>", desc = 'GPT prompt Visual Chat Paste' },
      { '<C-g>t', mode = 'v', ":<C-u>'<,'>GpChatToggle<cr>", desc = 'GPT prompt Visual Toggle Chat' },
      { '<C-g><C-x>', mode = { 'n', 'i' }, '<cmd>GpChatNew split<cr>', desc = 'GPT prompt New Chat split' },
      { '<C-g><C-v>', mode = { 'n', 'i' }, '<cmd>GpChatNew vsplit<cr>', desc = 'GPT prompt New Chat vsplit' },
      { '<C-g><C-t>', mode = { 'n', 'i' }, '<cmd>GpChatNew tabnew<cr>', desc = 'GPT prompt New Chat tabnew' },
      { '<C-g><C-x>', mode = 'v', ":<C-u>'<,'>GpChatNew split<cr>", desc = 'GPT prompt Visual Chat New split' },
      { '<C-g><C-v>', mode = 'v', ":<C-u>'<,'>GpChatNew vsplit<cr>", desc = 'GPT prompt Visual Chat New vsplit' },
      { '<C-g><C-t>', mode = 'v', ":<C-u>'<,'>GpChatNew tabnew<cr>", desc = 'GPT prompt Visual Chat New tabnew' },

      -- Prompt commands
      { '<D-k>r', mode = { 'n', 'i' }, '<cmd>GpRewrite<cr>', desc = 'GPT prompt Inline Rewrite' },
      { '<D-k>a', mode = { 'n', 'i' }, '<cmd>GpAppend<cr>', desc = 'GPT prompt Append (after)' },
      { '<D-k>b', mode = { 'n', 'i' }, '<cmd>GpPrepend<cr>', desc = 'GPT prompt Prepend (before)' },
      { '<D-k>r', mode = 'v', ":<C-u>'<,'>GpRewrite<cr>", desc = 'GPT prompt Visual Rewrite' },
      { '<D-k>a', mode = 'v', ":<C-u>'<,'>GpAppend<cr>", desc = 'GPT prompt Visual Append (after)' },
      { '<D-k>b', mode = 'v', ":<C-u>'<,'>GpPrepend<cr>", desc = 'GPT prompt Visual Prepend (before)' },
      { '<D-k>i', mode = 'v', ":<C-u>'<,'>GpImplement<cr>", desc = 'GPT prompt Implement selection' },

      { '<C-g>gp', mode = { 'n', 'i' }, '<cmd>GpPopup<cr>', desc = 'GPT prompt Popup' },
      { '<C-g>ge', mode = { 'n', 'i' }, '<cmd>GpEnew<cr>', desc = 'GPT prompt GpEnew' },
      { '<C-g>gn', mode = { 'n', 'i' }, '<cmd>GpNew<cr>', desc = 'GPT prompt GpNew' },
      { '<C-g>gv', mode = { 'n', 'i' }, '<cmd>GpVnew<cr>', desc = 'GPT prompt GpVnew' },
      { '<C-g>gt', mode = { 'n', 'i' }, '<cmd>GpTabnew<cr>', desc = 'GPT prompt GpTabnew' },
      { '<C-g>gp', mode = 'v', ":<C-u>'<,'>GpPopup<cr>", desc = 'GPT prompt Visual Popup' },
      { '<C-g>ge', mode = 'v', ":<C-u>'<,'>GpEnew<cr>", desc = 'GPT prompt Visual GpEnew' },
      { '<C-g>gn', mode = 'v', ":<C-u>'<,'>GpNew<cr>", desc = 'GPT prompt Visual GpNew' },
      { '<C-g>gv', mode = 'v', ":<C-u>'<,'>GpVnew<cr>", desc = 'GPT prompt Visual GpVnew' },
      { '<C-g>gt', mode = 'v', ":<C-u>'<,'>GpTabnew<cr>", desc = 'GPT prompt Visual GpTabnew' },

      { '<C-g>x', mode = { 'n', 'i' }, '<cmd>GpContext<cr>', desc = 'GPT prompt Toggle Context' },
      { '<C-g>x', mode = 'v', ":<C-u>'<,'>GpContext<cr>", desc = 'GPT prompt Visual Toggle Context' },

      -- General commands
      { '<C-g>s', mode = { 'n', 'i', 'v', 'x' }, '<cmd>GpStop<cr>', desc = 'GPT prompt Stop' },
      { '<C-g>n', mode = { 'n', 'i', 'v', 'x' }, '<cmd>GpNextAgent<cr>', desc = 'GPT prompt Next Agent' },
    },
  },

  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  },
  {
    'felpafel/inlay-hint.nvim',
    event = 'LspAttach',
    config = true,
  },
  -- Plugin to improve viewing Markdown files in Neovim
  {
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {},
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  },
}
