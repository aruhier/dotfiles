  ----------------------------------------------------------------
  --------------------------- VIM-PLUG ---------------------------
  ----------------------------------------------------------------

require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  use {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
  }
  use 'liuchengxu/vista.vim'
  use 'windwp/nvim-autopairs'
  use 'tpope/vim-surround'
  use 'sainnhe/everforest'
  use 'chaoren/vim-wordmotion'
  use 'dhruvasagar/vim-table-mode'
  use 'tpope/vim-sleuth'
  use 'rhysd/vim-grammarous'
  use 'chentoast/marks.nvim'
  use 'shellRaining/hlchunk.nvim'

  -- Multiple cursors, with ctrl+n
  use {'mg979/vim-visual-multi', branch = 'master'}

  ---- Autocomplete
  use 'neovim/nvim-lspconfig'
  use {'hrsh7th/nvim-cmp', requires={
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-vsnip',
    'hrsh7th/vim-vsnip',
  }}
  use {'williamboman/mason.nvim', 'williamboman/mason-lspconfig.nvim', requires={'neovim/nvim-lspconfig'}}

  ---- Treesitter
  use {
    {
      'nvim-treesitter/nvim-treesitter',
      run = function()
        local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
        ts_update()
      end,
    },
    {"nvim-treesitter/nvim-treesitter-textobjects", requires = "nvim-treesitter/nvim-treesitter", after = "nvim-treesitter"},
  }
  ---- Code diagnostic
  use {'folke/trouble.nvim', requires={'kyazdani42/nvim-web-devicons'}}
  ---- Status line
  use {'aruhier/lualine.nvim', branch = 'pr_tabs', requires={'kyazdani42/nvim-web-devicons', 'arkav/lualine-lsp-progress'}}
  ---- Unit tests
  use 'janko-m/vim-test'
  use {'alfredodeza/coveragepy.vim', ft = {'python'}}
  ---- LaTeX
  use {'lervag/vimtex', ft = {'tex'}}
  ---- Markdown
  use {'preservim/vim-markdown', ft = {'markdown'},
    config = function()
      vim.g['vim_markdown_no_default_key_mappings'] = 1
    end,
  }
  use {'iamcco/markdown-preview.nvim', ft = {'markdown'},
    run = function() vim.fn["mkdp#util#install"]() end,
    config = function()
      vim.api.nvim_set_keymap('n', '<leader>lv', '<cmd>:MarkdownPreview<cr>', {silent = true, noremap = true})
    end,
  }
  use {'ellisonleao/glow.nvim', ft = {'markdown'},
    config = function()
      require('glow').setup()
      vim.api.nvim_set_keymap('n', '<leader>ll', '<cmd>Glow<cr>', {silent = true, noremap = true})
    end,
  }
  ---- Python
  use {'psf/black', ft = {'python'}}
  ---- Rust
  use {'rust-lang/rust.vim', ft = {'rust'}}
  ---- XML
  use {'sukima/xmledit', ft = {'xml'}}

  ---- Git support
  use {'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' }}
  use 'tpope/vim-fugitive'
  use 'rhysd/git-messenger.vim'
end)

  ----------------------------------------------------------------
  -------------------- GENERAL CONFIGURATION ---------------------
  ----------------------------------------------------------------

local map = vim.keymap.set
local opts = { noremap=true, silent=true }

vim.opt.syntax = 'on'

-- Uncomment the following to have Vim jump to the last position when
-- reopening a file
-- vim.cmd [[
--  if has('autocmd')
--    au BufReadPost * if line('"\"') > 1 && line('"\"') <= line('$') | exe 'normal! g"\"' | endif
--  endif
--]]

-- Line numbers.
vim.opt.nu = true
-- Disable mouse features.
vim.opt.mouse = ''
-- Enable status.
vim.opt.errorbells = false
-- Delete whitespace at the endline.
vim.cmd [[ autocmd BufWritePre * :%s/\s\+$//e ]]
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.scrolloff = 10
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.encoding = 'utf-8'
-- Disable autowrapping.
vim.opt.colorcolumn = '120'
vim.opt.textwidth = 119
vim.opt.fo:remove('t')
vim.cmd [[
  autocmd FileType {c,sh} set textwidth=79 colorcolumn=80 fo+=t
  autocmd FileType python set textwidth=88 colorcolumn=89 fo+=t
  autocmd FileType {go,rust} set textwidth=119 colorcolumn=120 fo+=t
]]

-- Mappings.
map('n', 'tt', ':tabprevious<CR>', {noremap = true, desc = 'Previous [T]ab'})
map('n', 'ty', ':tabnext<CR>', {noremap = true, desc = 'Next [T]ab'})
map('n', '<F4>', '<cmd>lua vim.opt.hlsearch = !vim.opt.hlsearch<CR>', {noremap = true, desc = 'Toggle highlight search'})
-- Avoid <Esc>.
for _, m in ipairs({'i', 'c', 'o'}) do
  map(m, 'jk', '<Esc>', {noremap = true})
end
map('v', 'ii', '<Esc>', {noremap = true})
-- M for Macros.
map('n', 'Mse', ':set spell spelllang=en<CR>', {noremap = true, desc='[S]pell [E]nglish'})
map('n', 'Msf', ':set spell spelllang=fr<CR>', {noremap = true, desc='[S]pell [F]rench'})

-- Command aliases.
vim.cmd [[ cnoreabbrev t tabnew ]]

-- Autocompletion
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

-- Makefile
-- Make vim turn *off* expandtab for files named Makefile or makefile
-- We need the tab literal
vim.cmd [[ autocmd FileType make set noexpandtab ]]

-- Spell Check
vim.opt.spelllang = 'en'
-- Spell Check for *.txt and *.tex :
vim.cmd [[ autocmd FileType {text,tex} set spell spelllang=en ]]


    ----------------------------------------------------------------
    -------------------------- EXTENSIONS --------------------------
    ----------------------------------------------------------------


-- Theme
---------

vim.opt.termguicolors = true
map('n', '<F10>', ':let &background = ( &background == "dark"? "light" : "dark" )<CR>', {desc = 'Toggle Background (dark/light)'})
vim.opt.background = 'dark'
vim.g['everforest_background'] = 'medium'
vim.g['everforest_ui_contrast'] = 'high'
vim.g['everforest_better_performance'] = 1
vim.cmd [[ colorscheme everforest ]]


-- Status line
---------------

local function setupLualine()
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
          colored=false, icons_enabled=false
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
      lualine_x = {'encoding', {'fileformat' , icons_enabled=false}, {'filetype', icons_enabled=false}},
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
setupLualine()


-- nvim-lsp
------------

vim.diagnostic.config({virtual_text = false})

-- Print LSP diagnostic in the message bar.
-- Only prints the first error, and adds […] to indicate that more are present.
function PrintDiagnostics(opts, bufnr, line_nr, client_id)
  local warning_hlgroup = 'WarningMsg'
  local error_hlgroup = 'ErrorMsg'

  opts = opts or {}

  bufnr = bufnr or 0
  line_nr = line_nr or (vim.api.nvim_win_get_cursor(0)[1] - 1)

  local line_diagnostics = vim.lsp.diagnostic.get_line_diagnostics(bufnr, line_nr, opts, client_id)
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


-- nvim-cmp
------------

local function setupNvimCMP()
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
    mapping = {
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<CR>'] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      }),
      ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' },
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
end
setupNvimCMP()


-- Mason LSP
------------

local function setupLSPInstaller()
  local on_attach = function(client, bufnr)
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
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  end

  require("mason").setup()
  require("mason-lspconfig").setup({
    ensure_installed = {'beancount', 'clangd', 'gopls', 'marksman', 'pyright', 'rust_analyzer'},
  })

  require("mason-lspconfig").setup_handlers {
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler.
    function (server_name) -- default handler (optional)
      require("lspconfig")[server_name].setup {on_attach=on_attach}
    end,

    ["beancount"] = function ()
      local lspconfig = require 'lspconfig'
      local util = require 'lspconfig.util'
      local fname = vim.fn.expand('%:p')

      if (fname ~= nil and fname ~=  '') then
        local root_dir = util.find_git_ancestor(fname) or util.path.dirname(fname)
        local root_file = root_dir .. "/main.beancount"

        require('lspconfig')['beancount'].setup {
          init_options = {
            journal_file = root_file
          }
        }
      end
    end
  }
end
setupLSPInstaller()


-- Black
---------

map('n', '<F9>', ':Black<CR>', {noremap = true})


-- HL Chunk
-----------------

require('hlchunk').setup({
  -- Used a color blender between everforest comment color (#859289) and everforest fg_red (#f85552).
  -- Use a slightly brighter color to make it more readable.
  line_num = {
    style = "#a49088",
  },
  -- Used a color blender between everforest comment color (#859289) and everforest fg_red (#f85552).
  chunk = {
    style = {
      { fg = "#9A877F" },
    },
  },
})


-- Gitsigns
------------

require('gitsigns').setup()


-- Marks
--------

require'marks'.setup()


-- Rust
--------

vim.g['rustfmt_autosave'] = 1


-- Telescope
-------------

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


-- Test
--------

vim.g['test#strategy'] = 'neovim'


-- Treesitter
--------------

require('nvim-treesitter.configs').setup({
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


-- Trouble
-----------

require('trouble').setup()
map('n', '<leader>xx', '<cmd>Trouble<cr>', {silent = true, noremap = true})
map('n', '<leader>xw', '<cmd>Trouble workspace_diagnostics<cr>', {silent = true, noremap = true})
map('n', '<leader>xd', '<cmd>Trouble document_diagnostics<cr>', {silent = true, noremap = true})
map('n', '<leader>xl', '<cmd>Trouble loclist<cr>', {silent = true, noremap = true})
map('n', '<leader>xq', '<cmd>Trouble quickfix<cr>', {silent = true, noremap = true})
map('n', 'gR', '<cmd>Trouble lsp_references<cr>', {silent = true, noremap = true})


-- Vista
---------

vim.g['vista#renderer#enable_icon'] = 0
vim.g['vista_sidebar_position'] = 'vertical topleft'
vim.g['vista_sidebar_width'] = 60


-- Custom functions
--------------------

-- Feature like bare-display in weechat.
-- Creates a new tab to get the current buffer in an unformat way, for copy paste. Writes the content of the buffer in
-- a temp file, read it with `less` at the same current position as nvim.
local function setupBareDisplay()
  local opts = {
    -- Limit the max number of lines copied in the temp file.
    max_lines = 50000,
    -- Mapping to toggle the bare display mode.
    map_toggle = '<M-Z>',
  }

  local function bareDisplay()
    local line = vim.api.nvim_win_get_cursor(0)[1]
    -- Do not use getpos() as it does not support when the window is out-of-focus (for example, when focusing the cmd
    -- line).
    local pos = 1 + line - vim.fn.line('w0')
    local win_height = vim.fn.winheight(0)

    local buffer_nb_lines = vim.api.nvim_buf_line_count(0)
    local range = {1, buffer_nb_lines}
    if buffer_nb_lines >= opts.max_lines then
      local minl = math.floor(pos - opts.max_lines/2)
      local maxl = math.floor(pos + opts.max_lines/2)

      if minl < 1 then
        maxl = maxl + (1-minl)
      end
      if maxl > opts.max_lines then
        minl = minl - (maxl - opts.max_lines)
      end
      range = {math.max(minl, 1), math.min(maxl, buffer_nb_lines)}
    end


    local perc = 0
    if pos > 1 then
      -- Removes 1 line to keep the content aligned with nvim, as `less` UI has an additional command line.
      perc = 100*pos/(win_height - 1)
    end

    local tmpfile = vim.fn.tempname()
    vim.api.nvim_command('silent ' .. string.format('%d,%dw ', unpack(range)) .. tmpfile)
    -- Jumps to a new tab to maximize the buffer, in a split layout.
    vim.api.nvim_command('tabnew')
    vim.api.nvim_command('terminal less ' .. string.format('+%d -j.%d ', line, perc) .. tmpfile)

    -- Gives input to the terminal and hides decorations.
    vim.api.nvim_command('startinsert')
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    map('t', opts.map_toggle, 'q', {buffer = 0, desc = 'Toggle BareDisplay'})

    -- Local buffer autocmd to close the buffer when quitting `less`.
    vim.api.nvim_create_autocmd('TermClose', {callback=function()
      local buf = vim.api.nvim_get_current_buf()
      vim.api.nvim_buf_delete(buf,{})
      vim.fn.delete(tempname)
    end, buffer=0})
  end

  vim.api.nvim_create_user_command('BareDisplay', bareDisplay, {})
  map('n', opts.map_toggle, bareDisplay, {desc = 'Toggle BareDisplay'})
end
setupBareDisplay()
