-- LaTeX snippets. Loaded by LuaSnip for `tex` buffers.
--
-- The file returns two lists: `snippets` (expand with <Tab>/<C-k>) and
-- `autosnippets` (expand the instant the trigger is typed). Math-only
-- autosnippets use VimTeX's in_mathzone() so e.g. "mk" only makes inline
-- maths outside an existing equation, and fractions only fire inside one.
--
-- This is a deliberately small, high-value starter set in the Gilles Castel /
-- ejmastnak style. Add your own; reload without restarting via <leader>L.

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep
local line_begin = require("luasnip.extras.expand_conditions").line_begin

-- Context helpers ----------------------------------------------------------
local function in_math()
  return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end
local function not_math()
  return not in_math()
end

local snippets = {}
local auto = {}

-- Environments -------------------------------------------------------------
table.insert(
  snippets,
  s(
    { trig = "beg", desc = "generic environment", condition = line_begin },
    fmta(
      [[
\begin{<>}
  <>
\end{<>}
]],
      { i(1, "env"), i(2), rep(1) }
    )
  )
)

table.insert(
  snippets,
  s(
    { trig = "fig", desc = "figure environment", condition = line_begin },
    fmta(
      [[
\begin{figure}[<>]
  \centering
  \includegraphics[width=<>\linewidth]{<>}
  \caption{<>}
  \label{fig:<>}
\end{figure}
]],
      { i(1, "htbp"), i(2, "0.8"), i(3), i(4), i(5) }
    )
  )
)

-- Inline / display maths (only when NOT already in maths) -------------------
table.insert(auto, s({ trig = "mk", wordTrig = true, condition = not_math, desc = "inline math" }, fmta("$<>$", { i(1) })))
table.insert(
  auto,
  s(
    { trig = "dm", wordTrig = true, condition = not_math, desc = "display math" },
    fmta(
      [[
\[
  <>
\]
]],
      { i(1) }
    )
  )
)

-- Maths-only autosnippets --------------------------------------------------
local math_auto = {
  { trig = "//", desc = "fraction", nodes = fmta("\\frac{<>}{<>}", { i(1), i(2) }) },
  { trig = "sq", desc = "square root", nodes = fmta("\\sqrt{<>}", { i(1) }) },
  { trig = "ee", desc = "e^{}", nodes = fmta("e^{<>}", { i(1) }) },
  { trig = "invs", desc = "inverse", nodes = t("^{-1}") },
  { trig = "sr", desc = "squared", nodes = t("^{2}") },
  { trig = "cb", desc = "cubed", nodes = t("^{3}") },
  { trig = "td", desc = "superscript", nodes = fmta("^{<>}", { i(1) }) },
  { trig = "__", desc = "subscript", nodes = fmta("_{<>}", { i(1) }) },
  { trig = "sum", desc = "sum", nodes = fmta("\\sum_{<>}^{<>}", { i(1, "n=1"), i(2, "\\infty") }) },
  { trig = "int", desc = "integral", nodes = fmta("\\int_{<>}^{<>}", { i(1), i(2) }) },
  { trig = "lim", desc = "limit", nodes = fmta("\\lim_{<> \\to <>}", { i(1, "n"), i(2, "\\infty") }) },
  { trig = "->", desc = "to", nodes = t("\\to ") },
  { trig = "!=", desc = "not equal", nodes = t("\\neq ") },
  { trig = ">=", desc = "geq", nodes = t("\\geq ") },
  { trig = "<=", desc = "leq", nodes = t("\\leq ") },
  { trig = "...", desc = "dots", nodes = t("\\dots ") },
}
for _, def in ipairs(math_auto) do
  table.insert(auto, s({ trig = def.trig, wordTrig = false, condition = in_math, desc = def.desc }, def.nodes))
end

-- Greek letters: ";a" -> \alpha, ";b" -> \beta, … (maths only) -------------
local greek = {
  a = "alpha",
  b = "beta",
  g = "gamma",
  d = "delta",
  e = "epsilon",
  z = "zeta",
  h = "eta",
  k = "kappa",
  l = "lambda",
  m = "mu",
  n = "nu",
  p = "pi",
  r = "rho",
  s = "sigma",
  t = "tau",
  f = "phi",
  c = "chi",
  y = "psi",
  o = "omega",
}
for key, name in pairs(greek) do
  table.insert(auto, s({ trig = ";" .. key, wordTrig = false, condition = in_math }, t("\\" .. name .. " ")))
end

return snippets, auto
