require("@luauforge/bundled/hVt")

local module = require("@luauforge/bundled/hVv")
local module2 = require("@luauforge/bundled/hVw")

return table.freeze({
	tab = module.tab,
	page = module.page,
	overlay = module.overlay,
	root = module2.root,
	stack = module2.stack,
	switch = module2.switch
})
