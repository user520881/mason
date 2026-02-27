

--Package Manager -------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------

local pack_dir = vim.fn.stdpath('data') .. '/site/pack/plugins/opt'
vim.fn.mkdir(pack_dir, 'p')

local plugins = {
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/MironPascalCaseFan/debugmaster.nvim',
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


--Options -------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------

vim.cmd.colorscheme("habamax") --helps with rendering visidata?
vim.opt.shell = 'pwsh' --helps with rendering visidata?
vim.g.mapleader = " " --need to map leader key before it is used in the "Pick Python Virtual environment" keymap
vim.opt.signcolumn = 'yes' -- always show gutter


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
  end, 200)

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
-- AUTOCOMPLETION (requires NVIM 0.12)
-- ============================================================================

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
