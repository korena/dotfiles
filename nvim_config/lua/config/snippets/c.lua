vim.notify("Loading C snippets!")


local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node


return {
  s("td", {
    t("typedef "),
    i(1, "int"),
    t(" "),
    i(2, "my_type"),
    t(";"),
  }),
}
