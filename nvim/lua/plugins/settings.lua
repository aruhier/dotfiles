-------------------------------------------------------------------
-------------------------- Configuration --------------------------
-------------------------------------------------------------------

local map = vim.keymap.set
local opts = { noremap=true, silent=true }


-- Black
---------

function PluginSetupBlack()
  map('n', '<F9>', ':Black<CR>', {noremap = true})
end


-- Everforest Theme
--------------------

function PluginSetupEverforestTheme()
  vim.opt.termguicolors = true
  map('n', '<F10>', ':let &background = ( &background == "dark"? "light" : "dark" )<CR>', {desc = 'Toggle Background (dark/light)'})
  vim.g['everforest_background'] = 'medium'
  vim.g['everforest_ui_contrast'] = 'high'
  vim.g['everforest_better_performance'] = 1
  vim.cmd [[ colorscheme everforest ]]
end


-- Status line
---------------

function PluginSetupLuaLine()
  local solarized_dark = require'lualine.themes.solarized_dark'
  solarized_dark.normal.b.bg = '#808e8e'
  solarized_dark.inactive.b.bg = '#808e8e'
  solarized_dark.insert.a.bg = '#b58900'
  local solarized_light = require'lualine.themes.solarized_light'
  solarized_light.insert.a.bg = '#b58900'

  require'lualine'.setup {
    options = {
      icons_enabled = true,
      theme = 'auto',
      component_separators = { left = '', right = ''},
      section_separators = { left = '', right = ''},
      disabled_filetypes = {},
      always_divide_middle = true,
    },
    sections = {
      lualine_a = {'mode'},
      lualine_b = {
        'branch',
        { 'diff', colored=false},
        {
          'diagnostics',
          sources={function()
            if vim.fn.has('nvim-0.5') == 1 then
              return 'nvim-lsp'
            end
            return 'nvim-diagnostic'
          end},
          colored=false, icons_enabled=true
        }
      },
      lualine_c = {
        {
          'filename',
          -- Relative path.
          path=1,
        },
        'lsp_progress'
      },
      lualine_x = {'encoding', {'fileformat' , icons_enabled=true}, {'filetype', icons_enabled=true}},
      lualine_y = {'progress'},
      lualine_z = {'location'}
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {
        {
          'filename',
          -- Relative path.
          path=1,
        },
      },
      lualine_x = {'location'},
      lualine_y = {},
      lualine_z = {}
    },
    tabline = {
      lualine_a = {{'tabs', mode = 1, path=1, max_length = vim.o.columns}},
    },
    extensions = {}
  }

  -- Needed because of that: https://github.com/nvim-lualine/lualine.nvim/discussions/845
  if #vim.api.nvim_list_tabpages() < 2 then
    require('lualine').hide({
      place = { 'tabline' },
    })
  end
  vim.api.nvim_create_autocmd({ 'TabNew', 'TabClosed' }, {
    group = vim.api.nvim_create_augroup('LualineTab', {}),
    callback = function()
      local show = #vim.api.nvim_list_tabpages() > 1
      vim.o.showtabline = show and 1 or 0
      require('lualine').hide({
        place = { 'tabline' },
        unhide = show,
      })
    end,
  })
end


-- HL Chunk
-----------------

function PluginSetupHLChunk()
  require('hlchunk').setup({
    -- Used a color blender between everforest comment color (#859289) and everforest fg_red (#f85552).
    -- Use a slightly brighter color to make it more readable.
    line_num = {
      enable = true,
      style = "#a49088",
    },
    -- Used a color blender between everforest comment color (#859289) and everforest fg_red (#f85552).
    chunk = {
      enable = true,
      style = {
        { fg = "#9A877F" },
      },
      delay = 0,
    },
    indent = {
      enable = true,
    },
    blank = {
      enable = true,
      chars = {
        '․',
      },
      style = {
        { vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Whitespace")), "fg", "gui"), "" },
      },
    },
  })
end


-- Mason LSP
------------

function PluginSetupLSPInstaller()
  require("mason").setup()
  require("mason-lspconfig").setup {}
  require('mason-tool-installer').setup {
    ensure_installed = {'bashls', 'beancount', 'clangd', 'gopls', 'marksman', 'pyright', 'rust_analyzer'},
    auto_update = false,
    run_on_start = true,
    start_delay = 3000,
    debounce_hours = 24,
  }
end


-- nvim-lsp
------------

function PluginSetupLSP()
  vim.diagnostic.config({virtual_text = false})

  -- Print LSP diagnostic in the message bar.
  -- Only prints the first error, and adds […] to indicate that more are present.
  function PrintDiagnostics(opts, bufnr, line_nr, client_id)
    local warning_hlgroup = 'WarningMsg'
    local error_hlgroup = 'ErrorMsg'

    opts = opts or {}

    bufnr = bufnr or 0
    line_nr = line_nr or (vim.api.nvim_win_get_cursor(0)[1] - 1)

    local line_diagnostics = vim.diagnostic.get(bufnr, { lnum = line_nr })
    if vim.tbl_isempty(line_diagnostics) then return end

    local diagnostic = line_diagnostics[1]
    local kind = 'warning'
    local hlgroup = warning_hlgroup

    if diagnostic.severity == vim.lsp.protocol.DiagnosticSeverity.Error then
      kind = 'error'
      hlgroup = error_hlgroup
    end

    local diagnostic_message = diagnostic.message
    if table.getn(line_diagnostics) > 1 then
      diagnostic_message = diagnostic_message .. ' […]'
    end

    local chunks = {{ kind .. ':', hlgroup }, { ' ' .. diagnostic_message }}
    print(chunks)
    vim.api.nvim_echo(chunks, false, {})
  end
  vim.cmd [[ autocmd CursorHold * lua PrintDiagnostics() ]]

  local default_lsp_attach = function(client, bufnr)
    require "lsp_signature".on_attach()
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap=true, silent=true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  end

  vim.lsp.config("*", {
    capabilities=require('cmp_nvim_lsp').default_capabilities(),
  })

  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      default_lsp_attach(args.client, args.buf)
    end,
  })

  local beancount_journal_file = function ()
    local lspconfig = require('lspconfig')
    local util = require('lspconfig.util')
    local fname = vim.fn.expand('%:p')

    local journal_file = ''

    if (fname ~= nil and fname ~=  '') then
      local root_dir = util.find_git_ancestor(fname) or util.path.dirname(fname)
      journal_file = root_dir .. "/main.beancount"
    end

    return journal_file
  end

  vim.lsp.config('beancount', {
    init_options = {
      journal_file = beancount_journal_file()
    }
  })

  require "lsp_signature".setup({
    hint_enable = false
  })
end


-- nvim-cmp
------------

function PluginSetupNvimCMP()
  vim.opt.updatetime = 300

  local cmp_autopairs = require('nvim-autopairs.completion.cmp')
  local cmp = require'cmp'
  cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))

  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn['vsnip#anonymous'](args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<C-y>'] = cmp.config.disable,
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<Tab>'] = cmp.mapping.select_next_item(),
      ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' },
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
  })
end


-- Rust
--------

function PluginSetupRust()
  vim.g['rustfmt_autosave'] = 1
end


-- Telescope
-------------

function PluginSetupTelescope()
  -- [[ Configure Telescope ]]
  -- See `:help telescope` and `:help telescope.setup()`
  require('telescope').setup {
    defaults = {
      mappings = {
        i = {
          ['<C-u>'] = false,
          ['<C-d>'] = false,
        },
      },
    },
  }

  -- Enable telescope fzf native, if installed
  pcall(require('telescope').load_extension, 'fzf')

  -- See `:help telescope.builtin`
  vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
  vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
  vim.keymap.set('n', '<leader>/', function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      winblend = 10,
      previewer = false,
    })
  end, { desc = '[/] Fuzzily search in current buffer' })

  vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
  vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
  vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
  vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
  vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
  vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
  vim.keymap.set('n', '<leader>sb', require('telescope.builtin').keymaps, { desc = '[S]earch [B]indings' })
  vim.keymap.set('n', '<leader>st', require('telescope.builtin').lsp_document_symbols, { desc = '[S]earch [T]ags' })
end


-- Treesitter
--------------

function PluginSetupTreesitter()
  require('nvim-treesitter').setup({
    ensure_installed = "all",
    ignore_install = {},
    highlight = {
      enable = true,
      disable = {},
      additional_vim_regex_highlighting = false,
    },
    indent = {
      enable = true,
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
    },
  })
end


-- Trouble
-----------

function PluginSetupTrouble()
  require('trouble').setup()
  map('n', '<leader>xx', '<cmd>Trouble<cr>', {silent = true, noremap = true})
  map('n', '<leader>xw', '<cmd>Trouble workspace_diagnostics<cr>', {silent = true, noremap = true})
  map('n', '<leader>xd', '<cmd>Trouble document_diagnostics<cr>', {silent = true, noremap = true})
  map('n', '<leader>xl', '<cmd>Trouble loclist<cr>', {silent = true, noremap = true})
  map('n', '<leader>xq', '<cmd>Trouble quickfix<cr>', {silent = true, noremap = true})
  map('n', 'gR', '<cmd>Trouble lsp_references<cr>', {silent = true, noremap = true})
end


-- Test
--------

function PluginSetupTest()
  vim.g['test#strategy'] = 'neovim'
end


-- Vista
---------

function PluginSetupVista()
  vim.g['vista#renderer#enable_icon'] = 1
  vim.g['vista_sidebar_position'] = 'vertical topleft'
  vim.g['vista_sidebar_width'] = 30
  vim.g['vista_default_executive'] = 'nvim_lsp'
  map('n', '<F3>', '<cmd>Vista<cr>', {noremap = true, desc = 'Toggle Sidebar'})
  map('i', '<F3>', '<cmd>Vista<cr>', {noremap = true, desc = 'Toggle Sidebar'})
end
