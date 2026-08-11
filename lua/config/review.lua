-- Resolve and open a pull-request-style branch review without guessing a
-- project-specific base. Forks prefer upstream/HEAD; ordinary clones fall
-- back to origin/HEAD. Callers may always provide an explicit revision.

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
  if explicit and explicit ~= "" then
    if is_commit(explicit) then
      return explicit
    end
    return nil, ("ReviewBranch: revision %q does not resolve to a commit"):format(explicit)
  end

  for _, remote in ipairs({ "upstream", "origin" }) do
    local head = git({ "symbolic-ref", "--quiet", "--short", "refs/remotes/" .. remote .. "/HEAD" })
    if is_commit(head) then
      return head
    end
  end

  return nil, "ReviewBranch: no upstream/HEAD or origin/HEAD; use :ReviewBranch <base>"
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
