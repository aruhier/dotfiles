  ----------------------------------------------------------------
  --------------------------- VIM-PLUG ---------------------------
  ----------------------------------------------------------------

require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  use {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    requires = {
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
  use 'windwp/nvim-autopairs'
  use 'tpope/vim-surround'
  use 'sainnhe/everforest'
  use 'chaoren/vim-wordmotion'
  use 'tpope/vim-sleuth'
  use 'chentoast/marks.nvim'
  use 'shellRaining/hlchunk.nvim'

  ---- Status line
  use {'nvim-lualine/lualine.nvim', requires={'kyazdani42/nvim-web-devicons'}}

  -- Multiple cursors, with ctrl+n
  use {'mg979/vim-visual-multi', branch = 'master'}
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
--  if has("autocmd")
--    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
--  endif
--]]

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

-- Line numbers.
-- Automatic line feature: window with focused will have a relative line number to ease navigation, non focused
-- windows will have a static line number.
vim.opt.nu = true
local numberToggleGroup = vim.api.nvim_create_augroup('NumberToggle', {})
vim.api.nvim_create_autocmd({'BufEnter', 'FocusGained', 'InsertLeave', 'WinEnter' }, {
  group=numberToggleGroup,
  callback = function()
    if vim.opt.nu and vim.api.nvim_get_mode() ~= 'i' then
      vim.opt.rnu = true
    end
  end,
})
vim.api.nvim_create_autocmd({'BufLeave', 'FocusLost', 'InsertEnter', 'WinLeave' }, {
  group=numberToggleGroup,
  callback = function()
    if vim.opt.nu then
      vim.opt.rnu = false
    end
  end,
})

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


-- Marks
--------

require'marks'.setup()


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
