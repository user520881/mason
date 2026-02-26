
-- 47 is the jetbrains index for installation but it may change
local fonts_dir = vim.fn.expand('~') .. '/AppData/Local/Microsoft/Windows/Fonts'
local fonts_already_installed = vim.fn.glob(fonts_dir .. '/JetBrainsMono*.ttf') ~= ''

if not fonts_already_installed then
  --vim.fn.termopen(
  --  'powershell -ExecutionPolicy Bypass -Command ' ..
  --  '"curl --progress-bar -o install.ps1 https://raw.githubusercontent.com/officialrajdeepsingh/nerd-fonts-installer/main/install.ps1; ' ..
  --  'echo 47 | powershell -ExecutionPolicy Bypass -File .\\install.ps1"'
  --)
  vim.fn.system("powershell -Command \"Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/officialrajdeepsingh/nerd-fonts-installer/main/install.ps1' -OutFile 'install.ps1'\"")
  vim.cmd([[terminal powershell -Command "echo 47 | powershell -File .\install.ps1"]])


  vim.api.nvim_create_autocmd('TermClose', {
    once = true,
    callback = function()
      vim.schedule(function()
        vim.cmd('bdelete!')
        vim.cmd('intro')
      end)
    end
  })
end


vim.fn.mkdir(vim.fn.expand('~/scratch/zipped'), 'p')
vim.fn.mkdir(vim.fn.expand('~/scratch/apps'), 'p')
vim.env.PATH = vim.env.PATH .. ';' .. vim.fn.expand('~/scratch/apps')

if vim.fn.executable('uv') == 0 then
  vim.fn.system('curl.exe -L -o "%USERPROFILE%/scratch/zipped/uv.zip" "https://github.com/astral-sh/uv/releases/download/0.6.10/uv-x86_64-pc-windows-msvc.zip"')
  vim.fn.system('tar.exe -xf "%USERPROFILE%/scratch/zipped/uv.zip" -C "%USERPROFILE%/scratch/apps"')
end

if vim.fn.executable('fzf') == 0 then
  vim.fn.system('curl.exe -L -o "%USERPROFILE%/scratch/zipped/fzf.zip" "https://github.com/junegunn/fzf/releases/download/v0.61.1/fzf-0.61.1-windows_amd64.zip"')
  vim.fn.system('tar.exe -xf "%USERPROFILE%/scratch/zipped/fzf.zip" -C "%USERPROFILE%/scratch/apps"')
end

--vim.fn.system('Remove-Item "$env:LOCALAPPDATA/Microsoft/WindowsApps/python*.exe" -Force -ErrorAction SilentlyContinue')

if vim.fn.executable('python') == 0 then  
  vim.fn.system('uv python install 3.11.11 --native-tls')
  local python_path = vim.fn.system('uv python find'):gsub('[\r\n]', '')
  vim.fn.system('uv pip install --python ' .. python_path .. ' --system debugpy --break-system-packages')
end

if vim.fn.executable('ty') == 0 then
  vim.fn.system('uv tool install ty')
end

if vim.fn.executable('ruff') == 0 then
  vim.fn.system('uv tool install ruff')
end

vim.fn.system('uv tool update-shell')



