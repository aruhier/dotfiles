  ----------------------------------------------------------------
  -------------------- GENERAL CONFIGURATION ---------------------
  ----------------------------------------------------------------

require('config.lua')

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
map('n', '<leader>o', 'o<Space><BS><Esc>', {noremap = true, desc = 'Same as \'o\' but stays in normal mode'})
map('n', '<leader>O', 'O<Space><BS><Esc>', {noremap = true, desc = 'Same as \'O\' but stays in normal mode'})
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
