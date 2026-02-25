local function wait_for_stop(callback)
  local function check()
    local clients = vim.lsp.get_clients({ name = "ty" })
    if #clients == 0 then
      callback()
    else
      vim.defer_fn(check, 100)
    end
  end
  check()
end

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

  wait_for_stop(function()
    vim.notify = orig_notify
    vim.lsp.start({
      name = "ty",
      cmd = { "ty", "server" },
      root_dir = vim.fn.getcwd(),
    })
    require("dap").configurations.python[1].pythonPath = venv_path .. "\\Scripts\\python.exe"
    vim.notify("Python environment set to: " .. vim.fs.basename(venv_path))
  end)
end