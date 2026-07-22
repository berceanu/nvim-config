-- Global snippets, available in every filetype.

local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local function today()
  return os.date("%Y-%m-%d")
end

return {
  -- Insert today's date: type "ddate" then <Tab>.
  s({ trig = "ddate", desc = "today's date (YYYY-MM-DD)" }, f(today)),

  -- A quick TODO comment.
  s({ trig = "todo", desc = "TODO note" }, fmt("TODO: {}", { i(1) })),
}
