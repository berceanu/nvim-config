-- Headless, read-only validation for the supported language matrix.

local M = {}

local function add_failure(failures, message)
  failures[#failures + 1] = message
end

local function check_plugins(failures)
  local lock_file = vim.fs.joinpath(vim.fn.stdpath("config"), "nvim-pack-lock.json")
  local ok, decoded = pcall(vim.json.decode, table.concat(vim.fn.readfile(lock_file), "\n"))
  if not ok or type(decoded) ~= "table" or type(decoded.plugins) ~= "table" then
    add_failure(failures, "cannot read nvim-pack-lock.json")
    return
  end

  local expected = vim.tbl_count(decoded.plugins)
  local loaded = #vim.pack.get()
  if loaded < expected then
    add_failure(failures, ("loaded %d/%d locked plugins"):format(loaded, expected))
  end
end

local function check_languages(failures, languages)
  for _, entry in ipairs(languages.matrix) do
    local actual = vim.filetype.match({ filename = entry.filename })
    if actual ~= entry.filetype then
      add_failure(failures, ("%s filetype is %s, expected %s"):format(
        entry.label,
        tostring(actual),
        entry.filetype
      ))
    end
    if entry.parser then
      local call_ok, parser_ok, parser_error = pcall(vim.treesitter.language.add, entry.parser)
      if not call_ok or not parser_ok then
        add_failure(failures, ("%s parser unavailable: %s"):format(
          entry.parser,
          tostring(parser_error or parser_ok)
        ))
      end
    end
  end
end

local function check_lsp_definitions(failures, languages)
  for _, server in ipairs(languages.servers) do
    local definition = vim.api.nvim_get_runtime_file("lsp/" .. server.name .. ".lua", false)
    if #definition == 0 then
      add_failure(failures, "missing LSP definition: " .. server.name)
    end
    local available = languages.server_available(server)
    if vim.lsp.is_enabled(server.name) ~= available then
      add_failure(failures, ("%s activation does not match host availability"):format(server.name))
    end
  end
end

function M.check()
  local failures = {}
  local languages = require("config.languages")
  check_plugins(failures)
  check_languages(failures, languages)
  check_lsp_definitions(failures, languages)

  if #failures > 0 then
    error("Neovim health check failed:\n- " .. table.concat(failures, "\n- "))
  end
  print(("NVIM_HEALTH_OK languages=%d parsers=%d servers=%d"):format(
    #languages.matrix,
    #languages.parsers,
    #languages.servers
  ))
end

return M
