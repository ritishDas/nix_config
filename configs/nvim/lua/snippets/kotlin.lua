local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local f = ls.function_node

local function kotlin_package()
  local file = vim.api.nvim_buf_get_name(0)

  local package_path = file:match("/src/[%w_.-]+/[kotlin|java]+/(.-)/[^/]+%.kts?$")

  if not package_path then
    return ""
  end

  return package_path:gsub("/", ".")
end

return {
  s("package", {
    t("package "),
    f(kotlin_package),
  }),
}
