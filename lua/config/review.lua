-- Open a pull-request-style comparison against an explicit base. Git does not
-- record a future PR's target branch, so refusing to guess is the only
-- project-independent behavior.

local M = {}

local function git(args)
  local command = { "git" }
  vim.list_extend(command, args)
  local result = vim.system(command, { text = true }):wait()
  if result.code ~= 0 then
    return nil
  end
  return vim.trim(result.stdout)
end

local function is_commit(revision)
  return revision and git({ "rev-parse", "--verify", "--quiet", revision .. "^{commit}" }) ~= nil
end

function M.resolve_base(explicit)
  if not explicit or explicit == "" then
    return nil, "ReviewBranch: provide the intended base, for example :ReviewBranch origin/main"
  end
  if is_commit(explicit) then
    return explicit
  end
  return nil, ("ReviewBranch: revision %q does not resolve to a commit"):format(explicit)
end

function M.open(explicit)
  local base, err = M.resolve_base(explicit)
  if not base then
    vim.notify(err, vim.log.levels.ERROR)
    return
  end
  vim.api.nvim_cmd({ cmd = "DiffviewOpen", args = { base .. "...HEAD" } }, {})
end

return M
