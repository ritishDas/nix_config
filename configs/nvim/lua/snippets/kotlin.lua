local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local f = ls.function_node

local function kotlin_package()
  local file = vim.api.nvim_buf_get_name(0)

  -- Capture everything after src/<flavor>/(kotlin|java)/ up to the final slash
  local package_path = file:match("/src/[%w_.-]+/[kotlin|java]+/(.-)/[^/]+%.kts?$")

  if not package_path then
    return ""
  end

  -- Convert directory slashes to Kotlin dot notation
  return package_path:gsub("/", ".")
end

return {
  s("package", {
    t("package "),
    f(kotlin_package),
  }),
}
