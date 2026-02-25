

--vim.fn.system('powershell -NoProfile -Command "Invoke-WebRequest -Uri https://github.com/astral-sh/uv/releases/download/0.6.10/ -OutFile $env:USERPROFILE/dev/apps/uv"')
--vim.fn.system('Invoke-WebRequest -Uri "https://github.com/astral-sh/uv/releases/download/0.6.10/uv-x86_64-pc-windows-msvc.zip" -OutFile "$env:USERPROFILE/dev/apps/uv.zip"')



local home = vim.fn.expand('~')
vim.fn.mkdir(home .. '/scratch/zipped', 'p')
vim.fn.mkdir(home .. '/scratch/apps', 'p')

vim.fn.system('curl.exe -L -o "' .. home .. '/scratch/zipped/uv.zip" "https://github.com/astral-sh/uv/releases/download/0.6.10/uv-x86_64-pc-windows-msvc.zip"')
vim.fn.system('tar.exe -xf "' .. home .. '/scratch/zipped/uv.zip" -C "' .. home .. '/scratch/apps"')

vim.fn.system('curl.exe -L -o "' .. home .. '/scratch/zipped/fzf.zip" "https://github.com/junegunn/fzf/releases/download/v0.61.1/fzf-0.61.1-windows_amd64.zip"')
vim.fn.system('tar.exe -xf "' .. home .. '/scratch/zipped/fzf.zip" -C "' .. home .. '/scratch/apps"')

vim.env.PATH = vim.env.PATH .. ';' .. home .. '/scratch/apps'

vim.fn.system('Remove-Item "$env:LOCALAPPDATA/Microsoft/WindowsApps/python*.exe" -Force -ErrorAction SilentlyContinue')
vim.fn.system('uv python install 3.11.11 --native-tls')
local python_path = vim.fn.system('uv python find'):gsub('[\r\n]', '')
vim.fn.system('uv pip install --python ' .. python_path .. ' --system debugpy --break-system-packages')



vim.fn.system('uv tool install ty')
vim.fn.system('uv tool install ruff')
vim.fn.system('uv tool update-shell')



-- ================================================================================================
-- title : Suckless NeoVim Config
-- author: Radley E. Sidwell-lewis
-- ================================================================================================

-- theme & transparency
-- BM: need to also set transparency within terminal emulator settings.
vim.cmd.colorscheme("habamax") -- also good: sorbet, habamax, unokai (0.12 only)
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "none" })
vim.api.nvim_set_hl(0, "TabLine", { bg = "none" })
vim.api.nvim_set_hl(0, "TabLineFill", { bg = "none", fg = "#767676" })
vim.api.nvim_set_hl(0, "TabLineSel", { bg = "none" })
vim.api.nvim_set_hl(0, "ColorColumn", { bg = "none" })

-- Basic settings 
vim.opt.shell = "powershell" -- all calls of vim.fn.system() will use powershell syntax. things like && won't work. (found out from nvim-treesitter installation)
vim.opt.shellcmdflag = "-NoLogo -ExecutionPolicy RemoteSigned -Command"
vim.opt.shellquote = ""
vim.opt.shellxquote = ""

vim.opt.number = true                              -- Line numbers
vim.opt.relativenumber = true                      -- Relative line numbers
vim.opt.cursorline = true                          -- Highlight current line
vim.opt.wrap = false                               -- Don't wrap lines
vim.opt.scrolloff = 10                             -- Keep 10 lines above/below cursor 
vim.opt.sidescrolloff = 8                          -- Keep 8 columns left/right of cursor

-- Indentation
vim.opt.tabstop = 2                                -- Tab width
vim.opt.shiftwidth = 2                             -- Indent width
vim.opt.softtabstop = 2                            -- Soft tab stop
vim.opt.expandtab = true                           -- Use spaces instead of tabs
vim.opt.smartindent = true                         -- Smart auto-indenting
vim.opt.autoindent = true                          -- Copy indent from current line

-- Search settings
vim.opt.ignorecase = true                          -- Case insensitive search
vim.opt.smartcase = true                           -- Case sensitive if uppercase in search
vim.opt.hlsearch = false                           -- Don't highlight search results 
vim.opt.incsearch = true                           -- Show matches as you type

-- Visual settings
vim.opt.termguicolors = true                       -- Enable 24-bit colors
vim.opt.signcolumn = "yes"                         -- Always show sign column
vim.opt.colorcolumn = "100"                        -- Show column at 100 characters
vim.opt.showmatch = true                           -- Highlight matching brackets
vim.opt.matchtime = 2                              -- How long to show matching bracket
vim.opt.cmdheight = 1                              -- Command line height
vim.opt.completeopt = "menuone,noinsert,noselect"  -- Completion options 
vim.opt.showmode = false                           -- Don't show mode in command line 
vim.opt.pumheight = 10                             -- Popup menu height 
vim.opt.pumblend = 10                              -- Popup menu transparency 
vim.opt.winblend = 0                               -- Floating window transparency 
vim.opt.conceallevel = 0                           -- Don't hide markup 
vim.opt.concealcursor = ""                         -- Don't hide cursor line markup 
vim.opt.lazyredraw = true                          -- Don't redraw during macros
vim.opt.synmaxcol = 300                            -- Syntax highlighting limit 
vim.opt.fillchars = { eob = " " }                  -- Hide ~ on empty lines

-- Create undo directory if it doesn't exist
local undodir = vim.fn.expand("~/.vim/undodir")
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p")
end

-- File handling
vim.opt.backup = false                             -- Don't create backup files
vim.opt.writebackup = false                        -- Don't create backup before writing
vim.opt.swapfile = false                           -- Don't create swap files
vim.opt.undofile = true                            -- Persistent undo
vim.opt.undodir = vim.fn.expand("~/.vim/undodir")  -- Undo directory
vim.opt.updatetime = 300                           -- Faster completion
vim.opt.timeoutlen = 500                           -- Key timeout duration
vim.opt.ttimeoutlen = 0                            -- Key code timeout
vim.opt.autoread = true                            -- Auto reload files changed outside vim
vim.opt.autowrite = false                          -- Don't auto save

-- Behavior settings
vim.opt.hidden = true                              -- Allow hidden buffers
vim.opt.errorbells = false                         -- No error bells
vim.opt.backspace = "indent,eol,start"             -- Better backspace behavior
vim.opt.autochdir = false                          -- Don't auto change directory
vim.opt.iskeyword:append("-")                      -- Treat dash as part of word
vim.opt.path:append("**")                          -- include subdirectories in search
vim.opt.selection = "exclusive"                    -- Selection behavior
vim.opt.mouse = "a"                                -- Enable mouse support
vim.opt.clipboard:append("unnamedplus")            -- Use system clipboard
vim.opt.modifiable = true                          -- Allow buffer modifications
vim.opt.encoding = "UTF-8"                         -- Set encoding

-- Cursor settings
vim.opt.guicursor = "n-v-c:block,i-ci-ve:block,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"

-- Folding settings
vim.opt.foldmethod = "expr"                        -- Use expression for folding
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"    -- Use treesitter for folding
vim.opt.foldlevel = 2                             -- Start with all folds open

-- Split behavior
vim.opt.splitbelow = true                          -- Horizontal splits go below
vim.opt.splitright = true                          -- Vertical splits go right

-- Key mappings
vim.g.mapleader = " "                              -- Set leader key to space
vim.g.maplocalleader = " "                         -- Set local leader key (NEW)

-- Normal mode mappings
vim.keymap.set("n", "<leader>c", ":nohlsearch<CR>", { desc = "Clear search highlights" })

-- Y to EOL
vim.keymap.set("n", "Y", "y$", { desc = "Yank to end of line" })

-- Center screen when jumping
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

-- Better paste behavior
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })

-- Delete without yanking
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })

-- Buffer navigation
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Splitting & Resizing
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Split window horizontally" })
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Move lines up/down
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Better indenting in visual mode
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Quick file navigation
vim.keymap.set("n", "<leader>e", ":Explore<CR>", { desc = "Open file explorer" })
vim.keymap.set("n", "<leader>ff", ":find ", { desc = "Find file" })

-- Better J behavior
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

-- Quick config editing
vim.keymap.set("n", "<leader>rc", ":e $MYVIMRC<CR>", { desc = "Edit config" })
vim.keymap.set("n", "<leader>rl", ":so $MYVIMRC<CR>", { desc = "Reload config" })

-- ============================================================================
-- USEFUL FUNCTIONS
-- ============================================================================

-- Copy Full File-Path
vim.keymap.set("n", "<leader>pa", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	print("file:", path)
end)

-- Basic autocommands
local augroup = vim.api.nvim_create_augroup("UserConfig", {})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	pattern = "*",
	desc = "highlight selection on yank",
	callback = function()
		vim.highlight.on_yank({ timeout = 300, visual = true })
	end,
})


-- Return to last edit position when opening files
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    local line = mark[1]
    local ft = vim.bo.filetype
    if line > 0 and line <= lcount
      and vim.fn.index({ "commit", "gitrebase", "xxd" }, ft) == -1
      and not vim.o.diff then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Set filetype-specific settings
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "lua", "python" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "javascript", "typescript", "json", "html", "css" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})


-- BM: TermClose autocmd caused buffer wipe on DAP exit + venv-switch errors; removed, floating terminal still works without it.
--[===[
-- Auto-close terminal when process exits
vim.api.nvim_create_autocmd("TermClose", {
  group = augroup,
  callback = function()
    if vim.v.event.status == 0 then
      vim.api.nvim_buf_delete(0, {})
    end
  end,
})
--]===]

-- Disable line numbers in terminal
vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup,
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
  end,
})

-- Equally resize splits when terminal window is resized
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup,
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Create directories when saving files
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  callback = function()
    local dir = vim.fn.expand('<afile>:p:h')
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, 'p')
    end
  end,
})

-- Command-line completion
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"
vim.opt.wildignore:append({ "*.o", "*.obj", "*.pyc", "*.class", "*.jar" })

-- Better diff options
vim.opt.diffopt:append("linematch:60")

-- Performance improvements
vim.opt.redrawtime = 10000
vim.opt.maxmempattern = 20000

-- https://www.youtube.com/watch?v=v36vLiFVOXY&list=PL9JdE_NDdd8FpzKzWhqD3OBYoMvP3nUIX&index=7&t=136s
-- open help in vertical split
vim.api.nvim_create_autocmd("FileType", {
	pattern = "help",
	command = "wincmd L",
})

-- https://www.youtube.com/watch?v=v36vLiFVOXY&list=PL9JdE_NDdd8FpzKzWhqD3OBYoMvP3nUIX&index=7&t=136s
-- show cursorline only in active window enable
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
	group = vim.api.nvim_create_augroup("active_cursorline", { clear = true }),
	callback = function()
		vim.opt_local.cursorline = true
	end,
})

-- show cursorline only in active window disable
vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
	group = "active_cursorline",
	callback = function()
		vim.opt_local.cursorline = false
	end,
})

-- https://www.youtube.com/watch?v=v36vLiFVOXY&list=PL9JdE_NDdd8FpzKzWhqD3OBYoMvP3nUIX&index=7&t=136s
-- ide like highlight when stopping cursor
vim.api.nvim_create_autocmd("CursorMoved", {
	group = vim.api.nvim_create_augroup("LspReferenceHighlight", { clear = true }),
	desc = "Highlight references under cursor",
	callback = function()
		-- Only run if the cursor is not in insert mode
		if vim.fn.mode() ~= "i" then
			local clients = vim.lsp.get_clients({ bufnr = 0 })
			local supports_highlight = false
			for _, client in ipairs(clients) do
				if client.server_capabilities.documentHighlightProvider then
					supports_highlight = true
					break -- Found a supporting client, no need to check others
				end
			end

			-- 3. Proceed only if an LSP is active AND supports the feature
			if supports_highlight then
				vim.lsp.buf.clear_references()
				vim.lsp.buf.document_highlight()
			end
		end
	end,
})

-- ide like highlight when stopping cursor
vim.api.nvim_create_autocmd("CursorMovedI", {
	group = "LspReferenceHighlight",
	desc = "Clear highlights when entering insert mode",
	callback = function()
		vim.lsp.buf.clear_references()
	end,
})

-- ============================================================================
-- FLOATING TERMINAL
-- ============================================================================

-- terminal
local terminal_state = {
  buf = nil,
  win = nil,
  is_open = false
}

local function FloatingTerminal()
  -- If terminal is already open, close it (toggle behavior)
  if terminal_state.is_open and vim.api.nvim_win_is_valid(terminal_state.win) then
    vim.api.nvim_win_close(terminal_state.win, false)
    terminal_state.is_open = false
    return
  end

  -- Create buffer if it doesn't exist or is invalid
  if not terminal_state.buf or not vim.api.nvim_buf_is_valid(terminal_state.buf) then
    terminal_state.buf = vim.api.nvim_create_buf(false, true)
    -- Set buffer options for better terminal experience
    vim.bo[terminal_state.buf].bufhidden = 'hide'
  end

  -- Calculate window dimensions
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Create the floating window
  terminal_state.win = vim.api.nvim_open_win(terminal_state.buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
  })

  -- Set transparency for the floating window
  vim.wo[terminal_state.win].winblend = 0
  vim.wo[terminal_state.win].winhighlight = 'Normal:FloatingTermNormal,FloatBorder:FloatingTermBorder'

  -- Define highlight groups for transparency
  vim.api.nvim_set_hl(0, "FloatingTermNormal", { bg = "none" })
  vim.api.nvim_set_hl(0, "FloatingTermBorder", { bg = "none", })

  -- Start terminal if not already running
  local has_terminal = false
  local lines = vim.api.nvim_buf_get_lines(terminal_state.buf, 0, -1, false)
  for _, line in ipairs(lines) do
    if line ~= "" then
      has_terminal = true
      break
    end
  end

  if not has_terminal then
    -- vim.fn.termopen(os.getenv("SHELL"))  -- SHELL env var doesn't exist on Windows
    vim.fn.termopen(vim.o.shell)
  end

  terminal_state.is_open = true
  vim.cmd("startinsert")

  -- Set up auto-close on buffer leave 
  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = terminal_state.buf,
    callback = function()
      if terminal_state.is_open and vim.api.nvim_win_is_valid(terminal_state.win) then
        vim.api.nvim_win_close(terminal_state.win, false)
        terminal_state.is_open = false
      end
    end,
    once = true
  })
end

-- Function to explicitly close the terminal
local function CloseFloatingTerminal()
  if terminal_state.is_open and vim.api.nvim_win_is_valid(terminal_state.win) then
    vim.api.nvim_win_close(terminal_state.win, false)
    terminal_state.is_open = false
  end
end

-- Key mappings
vim.keymap.set("n", "<leader>t", FloatingTerminal, { noremap = true, silent = true, desc = "Toggle floating terminal" })
vim.keymap.set("t", "<Esc>", function()
  if terminal_state.is_open then
    vim.api.nvim_win_close(terminal_state.win, false)
    terminal_state.is_open = false
  end
end, { noremap = true, silent = true, desc = "Close floating terminal from terminal mode" })


-- ============================================================================
-- TABS
-- ============================================================================

-- Tab display settings
vim.opt.showtabline = 1  -- Always show tabline (0=never, 1=when multiple tabs, 2=always)
vim.opt.tabline = ''     -- Use default tabline (empty string uses built-in)

-- Alternative navigation (more intuitive)
vim.keymap.set('n', '<leader>tn', ':tabnew<CR>', { desc = 'New tab' })
vim.keymap.set('n', '<leader>tx', ':tabclose<CR>', { desc = 'Close tab' })

-- Tab moving
vim.keymap.set('n', '<leader>tm', ':tabmove<CR>', { desc = 'Move tab' })
vim.keymap.set('n', '<leader>t>', ':tabmove +1<CR>', { desc = 'Move tab right' })
vim.keymap.set('n', '<leader>t<', ':tabmove -1<CR>', { desc = 'Move tab left' })

-- Function to open file in new tab
local function open_file_in_tab()
  vim.ui.input({ prompt = 'File to open in new tab: ', completion = 'file' }, function(input)
    if input and input ~= '' then
      vim.cmd('tabnew ' .. input)
    end
  end)
end

-- Function to duplicate current tab
local function duplicate_tab()
  local current_file = vim.fn.expand('%:p')
  if current_file ~= '' then
    vim.cmd('tabnew ' .. current_file)
  else
    vim.cmd('tabnew')
  end
end

-- Function to close tabs to the right
local function close_tabs_right()
  local current_tab = vim.fn.tabpagenr()
  local last_tab = vim.fn.tabpagenr('$')

  for i = last_tab, current_tab + 1, -1 do
    vim.cmd(i .. 'tabclose')
  end
end

-- Function to close tabs to the left
local function close_tabs_left()
  local current_tab = vim.fn.tabpagenr()

  for i = current_tab - 1, 1, -1 do
    vim.cmd('1tabclose')
  end
end

-- Enhanced keybindings
vim.keymap.set('n', '<leader>tO', open_file_in_tab, { desc = 'Open file in new tab' })
vim.keymap.set('n', '<leader>td', duplicate_tab, { desc = 'Duplicate current tab' })
vim.keymap.set('n', '<leader>tr', close_tabs_right, { desc = 'Close tabs to the right' })
vim.keymap.set('n', '<leader>tL', close_tabs_left, { desc = 'Close tabs to the left' })

-- Function to close buffer but keep tab if it's the only buffer in tab
local function smart_close_buffer()
  local buffers_in_tab = #vim.fn.tabpagebuflist()
  if buffers_in_tab > 1 then
    vim.cmd('bdelete')
  else
    -- If it's the only buffer in tab, close the tab
    vim.cmd('tabclose')
  end
end
vim.keymap.set('n', '<leader>bd', smart_close_buffer, { desc = 'Smart close buffer/tab' })

-- ============================================================================
-- STATUSLINE
-- ============================================================================
-- BM replaced with status line from venv-selector-native (includes debug mode indicator)

-- Git branch function with caching and Nerd Font icon
local cached_branch = ""
local last_check = 0
local function git_branch()
  local now = vim.loop.now()
  if now - last_check > 5000 then  -- Check every 5 seconds
    local branch = vim.fn.system("git branch --show-current")
    if vim.v.shell_error == 0 then
      cached_branch = vim.trim(branch)
    else
      cached_branch = ""
    end
    last_check = now
  end
  if cached_branch ~= "" then
    return " \u{e725} " .. cached_branch .. " "  -- nf-dev-git_branch
  end
  return ""
end

-- File type with Nerd Font icon
local function file_type()
  local ft = vim.bo.filetype
  local icons = {
    lua = "\u{e620} ",           -- nf-dev-lua
    python = "\u{e73c} ",        -- nf-dev-python
    javascript = "\u{e74e} ",    -- nf-dev-javascript
    typescript = "\u{e628} ",    -- nf-dev-typescript
    javascriptreact = "\u{e7ba} ",
    typescriptreact = "\u{e7ba} ",
    html = "\u{e736} ",          -- nf-dev-html5
    css = "\u{e749} ",           -- nf-dev-css3
    scss = "\u{e749} ",
    json = "\u{e60b} ",          -- nf-dev-json
    markdown = "\u{e73e} ",      -- nf-dev-markdown
    vim = "\u{e62b} ",           -- nf-dev-vim
    sh = "\u{f489} ",            -- nf-oct-terminal
    bash = "\u{f489} ",
    zsh = "\u{f489} ",
    rust = "\u{e7a8} ",          -- nf-dev-rust
    go = "\u{e724} ",            -- nf-dev-go
    c = "\u{e61e} ",             -- nf-dev-c
    cpp = "\u{e61d} ",           -- nf-dev-cplusplus
    java = "\u{e738} ",          -- nf-dev-java
    php = "\u{e73d} ",           -- nf-dev-php
    ruby = "\u{e739} ",          -- nf-dev-ruby
    swift = "\u{e755} ",         -- nf-dev-swift
    kotlin = "\u{e634} ",
    dart = "\u{e798} ",
    elixir = "\u{e62d} ",
    haskell = "\u{e777} ",
    sql = "\u{e706} ",
    yaml = "\u{f481} ",
    toml = "\u{e615} ",
    xml = "\u{f05c} ",
    dockerfile = "\u{f308} ",    -- nf-linux-docker
    gitcommit = "\u{f418} ",     -- nf-oct-git_commit
    gitconfig = "\u{f1d3} ",     -- nf-fa-git
    vue = "\u{fd42} ",           -- nf-md-vuejs
    svelte = "\u{e697} ",
    astro = "\u{e628} ",
  }

  if ft == "" then
    return " \u{f15b} "          -- nf-fa-file_o
  end

  return (icons[ft] or " \u{f15b} " .. ft)
end

-- File size with Nerd Font icon
local function file_size()
  local size = vim.fn.getfsize(vim.fn.expand('%'))
  if size < 0 then return "" end
  
  local size_str
  if size < 1024 then
    size_str = size .. "B"
  elseif size < 1024 * 1024 then
    size_str = string.format("%.1fK", size / 1024)
  else
    size_str = string.format("%.1fM", size / 1024 / 1024)
  end
  
  return " \u{f016} " .. size_str .. " "  -- nf-fa-file_o
end

-- Mode indicators with Nerd Font icons
local function mode_icon()
  local mode = vim.fn.mode()
  local modes = {
    n = " \u{f040} NORMAL",      -- nf-fa-pencil
    i = " \u{f303} INSERT",      -- nf-linux-vim
    v = " \u{f06e} VISUAL",      -- nf-fa-eye
    V = " \u{f06e} V-LINE",
    ["\22"] = " \u{f06e} V-BLOCK",  -- Ctrl-V
    c = " \u{f120} COMMAND",     -- nf-fa-terminal
    s = " \u{f0c5} SELECT",      -- nf-fa-files_o
    S = " \u{f0c5} S-LINE",
    ["\19"] = " \u{f0c5} S-BLOCK",  -- Ctrl-S
    R = " \u{f044} REPLACE",     -- nf-fa-edit
    r = " \u{f044} REPLACE",
    ["!"] = " \u{f489} SHELL",   -- nf-oct-terminal
    t = " \u{f120} TERMINAL"     -- nf-fa-terminal
  }
  return modes[mode] or " \u{f059} " .. mode:upper()  -- nf-fa-question_circle
end

_G.mode_icon = mode_icon
_G.git_branch = git_branch
_G.file_type = file_type
_G.file_size = file_size

vim.cmd([[
  highlight StatusLineBold gui=bold cterm=bold
]])

-- Function to change statusline based on window focus
local function setup_dynamic_statusline()
  vim.api.nvim_create_autocmd({"WinEnter", "BufEnter"}, {
    callback = function()
    vim.opt_local.statusline = table.concat {
      "  ",
      "%#StatusLineBold#",
      "%{v:lua.mode_icon()}",
      "%#StatusLine#",
      " \u{e0b1} %f %h%m%r",     -- nf-pl-left_hard_divider
      "%{v:lua.git_branch()}",
      "\u{e0b1} ",               -- nf-pl-left_hard_divider
      "%{v:lua.file_type()}",
      "\u{e0b1} ",               -- nf-pl-left_hard_divider
      "%{v:lua.file_size()}",
      "%=",                      -- Right-align everything after this
      " \u{f017} %l:%c  %P ",    -- nf-fa-clock_o for line/col
    }
    end
  })
  vim.api.nvim_set_hl(0, "StatusLineBold", { bold = true })

  vim.api.nvim_create_autocmd({"WinLeave", "BufLeave"}, {
    callback = function()
      vim.opt_local.statusline = "  %f %h%m%r \u{e0b1} %{v:lua.file_type()} %=  %l:%c   %P "
    end
  })
end

setup_dynamic_statusline()



-- ============================================================================
-- LSP CONFIGURATION
-- ============================================================================


-- LSP settings
local function setup_lsp()
  -- Show diagnostic signs in the gutter
  local signs = {
    Error = "\u{f06a} ", -- nf-fa-exclamation_circle
    Warn = "\u{f071} ",  -- nf-fa-exclamation_triangle
    Hint = "\u{f0eb} ",  -- nf-fa-lightbulb_o
    Info = "\u{f05a} "   -- nf-fa-info_circle
  }

  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  -- Diagnostic configuration
  vim.diagnostic.config({
    virtual_text = {
      prefix = '●',
      spacing = 4,
    },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
      border = 'rounded',
      source = 'always',
      header = '',
      prefix = '',
    },
  })

  -- LSP keymaps (set when LSP attaches) -- BM potentially remove to use neovim defaults.
  vim.api.nvim_create_autocmd('LspAttach', {
    group = augroup,
    callback = function(ev)
      local opts = { buffer = ev.buf }
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
      vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
      vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
      vim.keymap.set('n', '<leader>f', function()
        vim.lsp.buf.format { async = true }
      end, opts)
    end,
  })

  -- Floating window borders
  local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
  function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or 'rounded'
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
  end
end

-- LSP diagnostic keymaps (always available)
vim.keymap.set('n', 'pd', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
vim.keymap.set('n', 'nd', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic list' })
vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Show line diagnostics' }) -- aligned to LazyVim, was <leader>dl

setup_lsp()


-- ============================================================================
-- BUFFER/FILE UTILITIES
-- ============================================================================

-- Close all buffers except current
vim.keymap.set('n', '<leader>bo', ':%bd|e#|bd#<CR>', { desc = 'Close all buffers except current' })

-- Rename current file
vim.keymap.set('n', '<leader>rr', function()
  local old_name = vim.fn.expand('%')
  local new_name = vim.fn.input('New file name: ', old_name)
  if new_name ~= '' and new_name ~= old_name then
    vim.cmd('saveas ' .. new_name)
    vim.fn.delete(old_name)
    print('File renamed to: ' .. new_name)
  end
end, { desc = 'Rename current file' })

-- Copy file path variations
vim.keymap.set('n', '<leader>pf', function()
  local path = vim.fn.expand('%:p')
  vim.fn.setreg('+', path)
  print('Full path: ' .. path)
end, { desc = 'Copy full file path' })

vim.keymap.set('n', '<leader>pr', function()
  local path = vim.fn.expand('%')
  vim.fn.setreg('+', path)
  print('Relative path: ' .. path)
end, { desc = 'Copy relative file path' })






-- ============================================================================
-- PACKAGE MANAGER
-- ============================================================================

local pack_dir = vim.fn.stdpath('data') .. '/site/pack/plugins/opt'
vim.fn.mkdir(pack_dir, 'p')

local plugins = {
  'https://github.com/ibhagwan/fzf-lua'
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/MironPascalCaseFan/debugmaster.nvim',
  'https://github.com/theHamsta/nvim-dap-virtual-text',
  'https://github.com/folke/which-key.nvim',
}

local clones, n = {}, 0
for _, url in ipairs(plugins) do
  local name = url:match('([^/]+)$')
  if not vim.uv.fs_stat(pack_dir .. '/' .. name) then
    clones[#clones + 1] = vim.system({ 'git', 'clone', '--filter=blob:none', url, pack_dir .. '/' .. name }, {}, function()
      n = n + 1; vim.schedule(function() vim.notify(('pack: [%d/%d] installed'):format(n, #clones)); vim.cmd.redraw() end)
    end)
  end
end
vim.wait(200000, function() return n == #clones end)
for _, url in ipairs(plugins) do vim.cmd.packadd(url:match('([^/]+)$')) end


-- ============================================================================
-- WHICH-KEY
-- ============================================================================

require("which-key").setup({
	icons = {
		rules = {
			{ color = "yellow", icon = "󰌠 ", pattern = "python" },
		},
	},
	preset = "helix",
	spec = {
		{ "<leader>dy", group = "python" },
		{ "<leader>d", group = "debug" },
	},
})

-- ============================================================================
-- TREESITTER
-- ============================================================================
-- ── Treesitter Python parser auto-setup ──────────────────────────────────────
-- Skips if parser exists and was built for the correct ABI. Rebuilds on nvim version change.
-- Requires: tree-sitter CLI, git, and a C compiler (gcc / clang / cl) in PATH.

local function setup_treesitter_python()
  local abi  = vim.fn.has('nvim-0.11') == 1 and 15 or 14
  local ext  = vim.fn.has('win32') == 1 and 'dll' or 'so'
  local site = vim.fn.stdpath('data') .. '/site'
  local abi_file   = site .. '/parser-info/python.abi'
  local stored_abi = vim.fn.filereadable(abi_file) == 1 and vim.fn.readfile(abi_file)[1] or ''
  if vim.fn.filereadable(site .. '/parser/python.' .. ext) == 1 and stored_abi == tostring(abi) then return end

  for _, bin in ipairs({ 'tree-sitter', 'git' }) do
    if vim.fn.executable(bin) == 0 then
      return vim.notify('treesitter-setup: ' .. bin .. ' not in PATH', vim.log.levels.ERROR)
    end
  end
  if not (vim.fn.executable('gcc') == 1 or vim.fn.executable('clang') == 1 or vim.fn.executable('cl') == 1) then
    return vim.notify('treesitter-setup: no C compiler found (gcc / clang / cl)', vim.log.levels.ERROR)
  end

  vim.notify(string.format('treesitter-setup: cloning sources and building parser (ABI %d)', abi))
  local tmp = vim.fn.tempname()
  vim.fn.mkdir(tmp, 'p')

  -- resolve latest tag first, then clone that exact release
  local tag = vim.fn.system('git ls-remote --tags --sort=-v:refname https://github.com/tree-sitter/tree-sitter-python')
    :match('\trefs/tags/(v[^\n^]+)\n')
  if not tag then return vim.notify('treesitter-setup: could not resolve latest tag', vim.log.levels.ERROR) end
  local src = tmp .. '/ts-python'
  vim.fn.system('git clone --depth 1 --branch ' .. tag .. ' https://github.com/tree-sitter/tree-sitter-python "' .. src .. '"')
  vim.fn.mkdir(site .. '/parser', 'p')
  local parser_dest = site .. '/parser/python.' .. ext
  vim.fn.chdir(src)
  vim.fn.system('tree-sitter generate --abi ' .. abi)
  vim.fn.system('tree-sitter build --output "' .. parser_dest .. '"')

  -- fetch only runtime/queries/python from nvim-treesitter (shallow clone, no working tree, checkout just that path)
  local nts = tmp .. '/nvim-treesitter'
  vim.fn.system('git clone --filter=blob:none --sparse https://github.com/nvim-treesitter/nvim-treesitter "' .. nts .. '"')
  vim.fn.system('git -C "' .. nts .. '" sparse-checkout set runtime/queries/python')

  -- install query files
  local q_dest = site .. '/queries/python'
  vim.fn.mkdir(q_dest, 'p')
  for _, f in ipairs(vim.fn.glob(nts .. '/runtime/queries/python/*.scm', false, true)) do
    vim.fn.writefile(vim.fn.readfile(f), q_dest .. '/' .. vim.fn.fnamemodify(f, ':t'))
  end

  -- parser-info revision file
  vim.fn.mkdir(site .. '/parser-info', 'p')
  vim.fn.writefile({ tag }, site .. '/parser-info/python.revision')
  vim.fn.writefile({ tostring(abi) }, site .. '/parser-info/python.abi')
  vim.treesitter.language.add('python', { path = parser_dest })
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].filetype == 'python' then
      pcall(vim.treesitter.start, buf, 'python')
    end
  end
  vim.cmd('redraw') --needed to clear cmdline cache otherwise get "press ENTER to continue" prompt.
  vim.notify('treesitter-setup: done — run :checkhealth treesitter to verify', vim.log.levels.INFO)
end
setup_treesitter_python()

-- ── End of setup ─────────────────────────────────────────────────────────────

vim.cmd('syntax off') --turn off native syntax highlighting.

vim.treesitter.language.register('python', { 'python' })

--by default vim.treesitter.start() only enables highlighting. folds, indents, injections need to be enabled manually. 
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldenable = true 

vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function()
    local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
    if lang and pcall(vim.treesitter.start) then 
    end
  end,
})

-- ============================================================================
-- LSP
-- ============================================================================

--install ty to ~/.local/bin/ty.exe
vim.api.nvim_create_autocmd('FileType', {
	pattern = 'python',
	callback = function()
		--local root = vim.fs.root(0, { 'pyproject.toml', 'setup.py', 'requirements.txt', 'pyvenv.cfg', '.git' })
		--vim.notify('ty root_dir: ' .. tostring(root), vim.log.levels.INFO)
		vim.lsp.start({
			name = 'ty',
			cmd = { 'ty', 'server' },
			-- allow ty to resolve root_dir natively https://docs.astral.sh/ty/modules/#module-discovery
			--root_dir = root,
			--root_dir = vim.fs.root(0, { 'pyproject.toml' }),
		})
	end,
})


-- ============================================================================
-- LINTING
-- ============================================================================
--[[
local ns = vim.api.nvim_create_namespace("ruff-lint")
local enabled = false

local error = vim.diagnostic.severity.ERROR
local severities = {
  ["F821"] = error, -- undefined name
  ["E902"] = error, -- IOError
  ["E999"] = error, -- SyntaxError
}

local function get_severity(code, message)
  local severity = severities[code]
  if severity then
    return severity
  end
  if message:find("^SyntaxError:") then
    return error
  end
  return vim.diagnostic.severity.WARN
end

local function lint()
  if not enabled then return end
  local bufnr = vim.api.nvim_get_current_buf()
  local fname = vim.api.nvim_buf_get_name(bufnr)
  if fname == "" or vim.bo[bufnr].filetype ~= "python" then return end
  vim.system(
    { "ruff", "check", "--output-format=json", "--stdin-filename", fname, "-" },
    { stdin = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n") },
    vim.schedule_wrap(function(out)
      if not vim.api.nvim_buf_is_valid(bufnr) then return end
      local ok, data = pcall(vim.json.decode, out.stdout)
      local diags = {}
      for _, d in ipairs(ok and data or {}) do
        diags[#diags + 1] = {
          lnum = d.location.row - 1,
          col = d.location.column - 1,
          end_lnum = d.end_location.row - 1,
          end_col = d.end_location.column - 1,
          message = d.message,
          code = d.code,
          source = "ruff",
          severity = get_severity(d.code, d.message),
        }
      end
      vim.diagnostic.set(ns, bufnr, diags)
    end)
  )
end

local function toggle()
  enabled = not enabled
  if enabled then
    lint()
    vim.notify("Lint ON")
  else
    for _, b in ipairs(vim.api.nvim_list_bufs()) do vim.diagnostic.set(ns, b, {}) end
    vim.notify("Lint OFF")
  end
end

vim.api.nvim_create_user_command("LintToggle", toggle, {})
vim.keymap.set("n", "<leader>tl", toggle, { desc = "Toggle linting" })

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("ruff-lint", { clear = true }),
  callback = lint,
})
--]]

-- ============================================================================
-- AUTOCOMPLETE
-- ============================================================================

if vim.version().minor >= 12 then

	vim.o.complete = ".,o" -- use buffer and omnifunc
	vim.o.completeopt = "fuzzy,menuone,noselect,popup" -- add 'popup' for docs (sometimes)
	vim.o.autocomplete = true -- https://www.reddit.com/r/neovim/comments/1mglgn4/simple_native_autocompletion_with_autocomplete/
	vim.o.pumheight = 7

	vim.api.nvim_create_autocmd("LspAttach", {
	  callback = function(ev)
		vim.lsp.completion.enable(true, ev.data.client_id, ev.buf, {
		  -- Optional formating of items
		  convert = function(item)
			-- Remove leading misc chars for abbr name,
			-- and cap field to 25 chars
			--local abbr = item.label
			--abbr = abbr:match("[%w_.]+.*") or abbr
			--abbr = #abbr > 25 and abbr:sub(1, 24) .. "…" or abbr
			--
			-- Remove return value
			--local menu = ""

			-- Only show abbr name, remove leading misc chars (bullets etc.),
			-- and cap field to 15 chars
			local abbr = item.label
			abbr = abbr:gsub("%b()", ""):gsub("%b{}", "")
			abbr = abbr:match("[%w_.]+.*") or abbr
			abbr = #abbr > 15 and abbr:sub(1, 14) .. "…" or abbr

			-- Cap return value field to 15 chars
			local menu = item.detail or ""
			menu = #menu > 15 and menu:sub(1, 14) .. "…" or menu

			return { abbr = abbr, menu = menu }
		  end,
		})
	  end,
	})

	--add completion (temp solution until PR merged https://github.com/neovim/neovim/pull/32820). ss sakithb comment for this solution in PR request.
	vim.api.nvim_create_autocmd("CompleteChanged", {
		callback = function()
			local event = vim.v.event
			if not event or not event.completed_item then return end

			local cy = event.row
			local cx = event.col
			local cw = event.width
			local ch = event.height

			local item = event.completed_item
			local lsp_item = item.user_data and item.user_data.nvim and item.user_data.nvim.lsp.completion_item
			local client = vim.lsp.get_clients({ bufnr = 0 })[1]

			if not client or not lsp_item then return end

			client:request('completionItem/resolve', lsp_item, function(_, result)
				vim.cmd("pclose")

				if result and result.documentation then
					local docs = result.documentation.value or result.documentation
					if type(docs) == "table" then docs = table.concat(docs, "\n") end
					if not docs or docs == "" then return end

					local buf = vim.api.nvim_create_buf(false, true)
					vim.bo[buf].bufhidden = 'wipe'

					local contents = vim.lsp.util.convert_input_to_markdown_lines(docs)
					vim.api.nvim_buf_set_lines(buf, 0, -1, false, contents)
					vim.treesitter.start(buf, "markdown")

					local dx = cx + cw + 1
					local dw = 60
					local anchor = "NW"

					if dx + dw > vim.o.columns then
						dw = vim.o.columns - dx
						anchor = "NE"
					end

					local win = vim.api.nvim_open_win(buf, false, {
						relative = "editor",
						row = cy,
						col = dx,
						width = dw,
						height = ch,
						anchor = anchor,
						border = "none",
						style = "minimal",
						zindex = 60,
					})

					vim.wo[win].conceallevel = 2
					vim.wo[win].wrap = true
					vim.wo[win].previewwindow = true
				end
			end)
		end,
	})

	vim.api.nvim_create_autocmd("CompleteDone", {
		callback = function()
			vim.cmd("pclose")
		end
	})
end


if vim.version().minor <= 11 then

	-- Minimal native LSP autocompletion for Neovim 0.10 (no plugins)
	-- Uses: ty (Python type checker by Astral), started as `ty server`

	vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
	vim.opt.pumheight = 10

	local function trunc(s, n)
	  return vim.fn.strcharlen(s) > n and vim.fn.strcharpart(s, 0, n - 1) .. '…' or s
	end

	vim.api.nvim_create_autocmd('FileType', {
	  pattern = 'python',
	  callback = function()
		vim.lsp.start({ name = 'ty', cmd = { 'ty', 'server' },
		  root_dir = vim.fs.root(0, { 'pyproject.toml', '.git' }) })
	  end,
	})

	vim.api.nvim_create_autocmd('LspAttach', {
	  callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if not (client and client.server_capabilities.completionProvider) then return end

		vim.api.nvim_create_autocmd('TextChangedI', {
		  buffer = ev.buf,
		  callback = function()
			if vim.fn.pumvisible() == 1 then return end
			local cursor = vim.api.nvim_win_get_cursor(0)
			local col = cursor[2]
			local line = vim.api.nvim_get_current_line()
			if col == 0 or not line:sub(col, col):match('[%w_.]') then return end

			client.request('textDocument/completion', {
			  textDocument = { uri = vim.uri_from_bufnr(ev.buf) },
			  position     = { line = cursor[1] - 1, character = col },
			}, function(err, result)
			  if err or not result or vim.fn.mode() ~= 'i' then return end
			  local sc = vim.api.nvim_win_get_cursor(0)[2]
			  local ln = vim.api.nvim_get_current_line()
			  while sc > 0 and ln:sub(sc, sc):match('[%w_]') do sc = sc - 1 end
			  local raw = result.items or result
			  if type(raw) ~= 'table' or #raw == 0 then return end
			  local words = {}
			  for _, item in ipairs(raw) do
				local doc = item.documentation
				words[#words + 1] = {
				  word = item.insertText or item.label,
				  abbr = trunc(item.label, 25),
				  menu = trunc(item.detail or '', 30),
				  info = type(doc) == 'string' and doc or type(doc) == 'table' and doc.value or '',
				  dup = 1, empty = 1,
				}
			  end
			  if #words > 0 then vim.fn.complete(sc + 1, words) end
			end, ev.buf)
		  end,
		})
	  end,
	})

	local doc_win, doc_buf

	local function close_doc()
	  if doc_win and vim.api.nvim_win_is_valid(doc_win) then
		vim.api.nvim_win_close(doc_win, true)
	  end
	  doc_win = nil
	end

	vim.api.nvim_create_autocmd('CompleteChanged', {
	  callback = function()
		local info = vim.trim((vim.v.completed_item or {}).info or '')
		vim.schedule(function()
		  close_doc()
		  if info == '' or vim.fn.pumvisible() == 0 then return end
		  local pum = vim.fn.pum_getpos()
		  if vim.tbl_isempty(pum) then return end
		  local lines = vim.split(info, '\n')
		  local col = pum.col + pum.width + ((pum.scrollbar == 1) and 1 or 0) + 1
		  local width = math.min(60, vim.o.columns - col - 2)
		  if width < 20 then
			width = math.min(60, pum.col - 2)
			col = pum.col - width - 1
		  end
		  if width < 20 then return end
		  if not doc_buf or not vim.api.nvim_buf_is_valid(doc_buf) then
			doc_buf = vim.api.nvim_create_buf(false, true)
		  end
		  vim.api.nvim_buf_set_lines(doc_buf, 0, -1, false, lines)
		  doc_win = vim.api.nvim_open_win(doc_buf, false, {
			relative = 'editor', row = pum.row, col = col,
			width = width, height = math.min(#lines, 12),
			style = 'minimal', border = 'single', focusable = false,
		  })
		end)
	  end,
	})

	vim.api.nvim_create_autocmd({ 'CompleteDone', 'InsertLeave' }, { callback = close_doc })



end

-- ============================================================================
-- FORMAT
-- ============================================================================


  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'python',
    callback = function()
      vim.lsp.start({
        name = 'ruff',
        cmd = { 'ruff', 'server' },
        root_dir = vim.fs.root(0, { 'pyproject.toml', 'setup.py', 'requirements.txt', 'pyvenv.cfg', '.git' }),
      })
    end,
  })

  
  --vim.g.mapleader = " "
  vim.keymap.set('n', '<leader>cf', vim.lsp.buf.format, { desc = 'Format buffer' })


-- ============================================================================
-- DAP
-- ============================================================================

local dap = require("dap")

dap.adapters.python = {
	type = "executable",
	command = "python", -- "C:\\Users\\test1\\AppData\\Roaming\\uv\\python\\cpython-3.11.11-windows-x86_64-none\\python.exe"
	args = { "-m", "debugpy.adapter" },
}

dap.configurations.python = {
	{
		type = "python",
		request = "launch",
		name = "Run file",
		program = "${file}",
		console = "integratedTerminal",
	},
}

do
	local __dap_signs = {
		DapBreakpoint = { text = " ", texthl = "DapBreakpoint" },
		DapBreakpointCondition = { text = " ", texthl = "dapBreakpointCondition" },
		DapBreakpointRejected = { text = " ", texthl = "DapBreakpointRejected" },
		DapLogPoint = { text = "", texthl = "DapLogPoint" },
		DapStopped = { text = "󰁕 ", texthl = "DapStopped" },
	}

	for sign_name, sign in pairs(__dap_signs) do
		vim.fn.sign_define(sign_name, sign)
	end
end


-- ============================================================================
-- VISIDATA.NVIM (requires: dap)
-- ============================================================================

local function get_visual_selection()
	local _, line_start, col_start = unpack(vim.fn.getpos("v"))
	local _, line_end, col_end = unpack(vim.fn.getpos("."))
	local selection = vim.api.nvim_buf_get_text(0, line_start - 1, col_start - 1, line_end - 1, col_end, {})
	return selection
end

local function visualize_pandas_df()
	local dap = require("dap")
	dap.repl.execute("import visidata")
	local selected_dataframe = get_visual_selection()[1]
	dap.repl.execute("visidata.vd.view_pandas(" .. selected_dataframe .. ")")
end





-- ============================================================================
-- VENV-SELECTOR (requires: dap, lsp)
-- ============================================================================

local function set_python_env(venv_path)
  local orig_notify = vim.notify
  vim.notify = function(msg, ...)
    if msg and msg:find("quit with exit code") then return end
    orig_notify(msg, ...)
  end

  local clients = vim.lsp.get_clients({ name = "ty" })
  for _, client in ipairs(clients) do
    client:stop(true)
  end

  vim.env.VIRTUAL_ENV = venv_path

  vim.defer_fn(function()
    vim.notify = orig_notify
    vim.lsp.start({
      name = "ty",
      cmd = { "ty", "server" },
      root_dir = vim.fn.getcwd(),
    })
  end, 500)

  require("dap").configurations.python[1].pythonPath = venv_path .. "\\Scripts\\python.exe"

  vim.notify("Python environment set to: " .. vim.fs.basename(venv_path)) -- BM: only show basename otherwise string too long for command line width and get "Press Enter to Continue" Error
end

vim.keymap.set("n", "<leader>dyv", function()
  local venv_dir = os.getenv("USERPROFILE") .. "\\Documents\\nvim-configs\\nvim-venv-selector-native\\uv_venvs"
  local items = {}
  for name, t in vim.fs.dir(venv_dir) do
    if t == "directory" then
      table.insert(items, { text = name, path = venv_dir .. "\\" .. name })
    end
  end

  local labels = {}
  for _, item in ipairs(items) do
    table.insert(labels, item.text)
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, labels)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = 40,
    height = #labels,
    row = 10,
    col = 40,
    style = "minimal",
    border = "rounded",
    title = " Select Python Environment ",
    title_pos = "center",
  })

  vim.keymap.set("n", "<CR>", function()
    local idx = vim.api.nvim_win_get_cursor(win)[1]
    local chosen = items[idx]
    vim.api.nvim_win_close(win, true)
    if chosen then
      set_python_env(chosen.path)
    end
  end, { buffer = buf })

  for _, key in ipairs({ "q", "<Esc>" }) do
    vim.keymap.set("n", key, function()
      vim.api.nvim_win_close(win, true)
    end, { buffer = buf })
  end
end, { desc = "Pick Python Virtual environment" })







-- ============================================================================
-- DEBUGMASTER (requires visidata.nvim)
-- ============================================================================

vim.api.nvim_create_autocmd('User', {
  pattern = 'DebugModeChanged',
  callback = function(args)
    vim.g.debug_mode_enabled = args.data.enabled
	vim.cmd("redrawstatus") -- need to manually redraw the statusline. lualine was previously handling this automatically. 
  end,
})

vim.keymap.set({'n', 'v'}, '<leader>dd', function()
	require('debugmaster').mode.toggle()
end, { desc = 'Toggle debug mode', nowait = true })

vim.keymap.set('n', '<leader>dt', function()
	vim.cmd('normal! viw')
	visualize_pandas_df()
	local state = require('debugmaster.state')
	state.sidepanel:set_active(state.terminal)
	vim.cmd('wincmd l')
	vim.cmd.startinsert()
end, { desc = 'show dataframe (pane)' })

vim.keymap.set('n', '<leader>dT', function()
	vim.cmd('normal! viw')
	visualize_pandas_df()
	local state = require('debugmaster.state')
	state.sidepanel:set_active(state.terminal)
	state.sidepanel:toggle_layout()
	vim.cmd.startinsert()
end, { desc = 'show dataframe (float)' })

vim.keymap.set('t', '@', function()
	vim.api.nvim_put({ 'gq' }, 'c', false, true)
	vim.cmd('stopinsert')
	local state = require('debugmaster.state')
	state.sidepanel:set_active(state.scopes)
	vim.cmd('wincmd h')
end, { desc = 'Exit Visidata sidepanel' })

vim.keymap.set('t', '@@', function()
	vim.api.nvim_put({ 'gq' }, 'c', false, true)
	vim.cmd('stopinsert')
	local state = require('debugmaster.state')
	state.sidepanel:toggle_layout()
	state.sidepanel:set_active(state.scopes)
	vim.cmd('wincmd h')
end, { desc = 'Exit Visidata floating window' })

-- ============================================================================
-- STATUSLINE (requires vim.g.debug_mode_enabled)
-- ============================================================================

-- Git branch function with caching and Nerd Font icon
local cached_branch = ""
local last_check = 0
local function git_branch()
  local now = vim.loop.now()
  if now - last_check > 5000 then  -- Check every 5 seconds
    local branch = vim.fn.system("git branch --show-current")
    if vim.v.shell_error == 0 then
      cached_branch = vim.trim(branch)
    else
      cached_branch = ""
    end
    last_check = now
  end
  if cached_branch ~= "" then
    return " \u{e725} " .. cached_branch .. " "  -- nf-dev-git_branch
  end
  return ""
end

-- File type with Nerd Font icon
local function file_type()
  local ft = vim.bo.filetype
  local icons = {
    lua = "\u{e620} ",           -- nf-dev-lua
    python = "\u{e73c} ",        -- nf-dev-python
    javascript = "\u{e74e} ",    -- nf-dev-javascript
    typescript = "\u{e628} ",    -- nf-dev-typescript
    javascriptreact = "\u{e7ba} ",
    typescriptreact = "\u{e7ba} ",
    html = "\u{e736} ",          -- nf-dev-html5
    css = "\u{e749} ",           -- nf-dev-css3
    scss = "\u{e749} ",
    json = "\u{e60b} ",          -- nf-dev-json
    markdown = "\u{e73e} ",      -- nf-dev-markdown
    vim = "\u{e62b} ",           -- nf-dev-vim
    sh = "\u{f489} ",            -- nf-oct-terminal
    bash = "\u{f489} ",
    zsh = "\u{f489} ",
    rust = "\u{e7a8} ",          -- nf-dev-rust
    go = "\u{e724} ",            -- nf-dev-go
    c = "\u{e61e} ",             -- nf-dev-c
    cpp = "\u{e61d} ",           -- nf-dev-cplusplus
    java = "\u{e738} ",          -- nf-dev-java
    php = "\u{e73d} ",           -- nf-dev-php
    ruby = "\u{e739} ",          -- nf-dev-ruby
    swift = "\u{e755} ",         -- nf-dev-swift
    kotlin = "\u{e634} ",
    dart = "\u{e798} ",
    elixir = "\u{e62d} ",
    haskell = "\u{e777} ",
    sql = "\u{e706} ",
    yaml = "\u{f481} ",
    toml = "\u{e615} ",
    xml = "\u{f05c} ",
    dockerfile = "\u{f308} ",    -- nf-linux-docker
    gitcommit = "\u{f418} ",     -- nf-oct-git_commit
    gitconfig = "\u{f1d3} ",     -- nf-fa-git
    vue = "\u{fd42} ",           -- nf-md-vuejs
    svelte = "\u{e697} ",
    astro = "\u{e628} ",
  }

  if ft == "" then
    return " \u{f15b} "          -- nf-fa-file_o
  end

  return (icons[ft] or " \u{f15b} " .. ft)
end

-- File size with Nerd Font icon
local function file_size()
  local size = vim.fn.getfsize(vim.fn.expand('%'))
  if size < 0 then return "" end
  
  local size_str
  if size < 1024 then
    size_str = size .. "B"
  elseif size < 1024 * 1024 then
    size_str = string.format("%.1fK", size / 1024)
  else
    size_str = string.format("%.1fM", size / 1024 / 1024)
  end
  
  return " \u{f016} " .. size_str .. " "  -- nf-fa-file_o
end

local function mode_icon()
  local dmode_enabled = vim.g.debug_mode_enabled or false -- for this to work the DebugModeChanged autocmd needs to be set. 
  if dmode_enabled then
    return " \u{f188} DEBUG"  -- nf-fa-bug
  end
  local mode = vim.fn.mode()
  local modes = {
    n = " \u{f040} NORMAL",
    i = " \u{f303} INSERT",
    v = " \u{f06e} VISUAL",
    V = " \u{f06e} V-LINE",
    ["\22"] = " \u{f06e} V-BLOCK",
    c = " \u{f120} COMMAND",
    s = " \u{f0c5} SELECT",
    S = " \u{f0c5} S-LINE",
    ["\19"] = " \u{f0c5} S-BLOCK",
    R = " \u{f044} REPLACE",
    r = " \u{f044} REPLACE",
    ["!"] = " \u{f489} SHELL",
    t = " \u{f120} TERMINAL"
  }
  return modes[mode] or " \u{f059} " .. mode:upper()
end

_G.mode_icon = mode_icon
_G.git_branch = git_branch
_G.file_type = file_type
_G.file_size = file_size

vim.cmd([[
  highlight StatusLineBold gui=bold cterm=bold
]])

-- Function to change statusline based on window focus
local function setup_dynamic_statusline()
  vim.api.nvim_create_autocmd({"WinEnter", "BufEnter"}, {
    callback = function()
    vim.opt_local.statusline = table.concat {
      "  ",
      "%#StatusLineBold#",
      "%{v:lua.mode_icon()}",
      "%#StatusLine#",
      " \u{e0b1} %f %h%m%r",     -- nf-pl-left_hard_divider
      "%{v:lua.git_branch()}",
      "\u{e0b1} ",               -- nf-pl-left_hard_divider
      "%{v:lua.file_type()}",
      "\u{e0b1} ",               -- nf-pl-left_hard_divider
      "%{v:lua.file_size()}",
      "%=",                      -- Right-align everything after this
      " \u{f017} %l:%c  %P ",    -- nf-fa-clock_o for line/col
    }
    end
  })
  vim.api.nvim_set_hl(0, "StatusLineBold", { bold = true })

  vim.api.nvim_create_autocmd({"WinLeave", "BufLeave"}, {
    callback = function()
      vim.opt_local.statusline = "  %f %h%m%r \u{e0b1} %{v:lua.file_type()} %=  %l:%c   %P "
    end
  })
end

setup_dynamic_statusline()

-- ============================================================================
-- DAP-VIRTUAL-TEXT (requires dap, treesitter)
-- ============================================================================

require("nvim-dap-virtual-text").setup()

