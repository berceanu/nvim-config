-- Shared language inventory. Parser installation, LSP activation, and the
-- headless health check all consume this file so support cannot drift silently.

local M = {}

-- Neovim already bundles c, lua, markdown, markdown_inline, query, vim, and
-- vimdoc. Everything below is installed at the revision selected by the locked
-- nvim-treesitter checkout.
M.parsers = {
  "bash",
  "cmake",
  "cpp",
  "cuda",
  "diff",
  "fortran",
  "gitcommit",
  "javascript",
  "json",
  "julia",
  "make",
  "python",
  "regex",
  "rst",
  "rust",
  "toml",
  "tsx",
  "typescript",
  "typst",
  "yaml",
}

M.servers = {
  { name = "basedpyright", command = "basedpyright-langserver" },
  { name = "ruff", command = "ruff" },
  { name = "tinymist", command = "tinymist" },
  { name = "rust_analyzer", command = "rust-analyzer" },
  { name = "clangd", command = "clangd" },
  { name = "fortls", command = "fortls" },
  { name = "julials", command = "julia", project = "julia-lsp" },
  { name = "ts_ls", command = "typescript-language-server" },
}

M.matrix = {
  { label = "Markdown", filename = "notes.md", filetype = "markdown", parser = "markdown" },
  { label = "reStructuredText", filename = "notes.rst", filetype = "rst", parser = "rst" },
  { label = "Typst", filename = "paper.typ", filetype = "typst", parser = "typst" },
  { label = "LaTeX", filename = "paper.tex", filetype = "tex" },
  { label = "Fortran", filename = "solver.f90", filetype = "fortran", parser = "fortran" },
  { label = "C", filename = "solver.c", filetype = "c", parser = "c" },
  { label = "C++", filename = "solver.cpp", filetype = "cpp", parser = "cpp" },
  { label = "Rust", filename = "main.rs", filetype = "rust", parser = "rust" },
  { label = "Julia", filename = "model.jl", filetype = "julia", parser = "julia" },
  { label = "JavaScript", filename = "app.js", filetype = "javascript", parser = "javascript" },
  { label = "TypeScript", filename = "app.ts", filetype = "typescript", parser = "typescript" },
  { label = "TSX", filename = "app.tsx", filetype = "typescriptreact", parser = "tsx" },
  { label = "Python", filename = "model.py", filetype = "python", parser = "python" },
  { label = "CUDA", filename = "kernel.cu", filetype = "cuda", parser = "cuda" },
  { label = "Make", filename = "Makefile", filetype = "make", parser = "make" },
  { label = "CMake", filename = "CMakeLists.txt", filetype = "cmake", parser = "cmake" },
}

local function julia_lsp_project()
  if vim.fn.executable("julia") ~= 1 then
    return nil
  end

  local separator = vim.fn.has("win32") == 1 and ";" or ":"
  local depot = vim.env.JULIA_DEPOT_PATH
  if depot and depot ~= "" then
    depot = vim.split(depot, separator, { plain = true })[1]
  end
  if not depot or depot == "" then
    depot = vim.fs.joinpath(vim.env.HOME, ".julia")
  end
  return vim.fs.joinpath(depot, "environments", "nvim-lspconfig", "Project.toml")
end

function M.server_available(server)
  if vim.fn.executable(server.command) ~= 1 then
    return false
  end
  if server.project == "julia-lsp" then
    local project = julia_lsp_project()
    local manifest = project and vim.fs.joinpath(vim.fs.dirname(project), "Manifest.toml")
    return project ~= nil
      and vim.fn.filereadable(project) == 1
      and vim.fn.filereadable(manifest) == 1
  end
  return true
end

return M
