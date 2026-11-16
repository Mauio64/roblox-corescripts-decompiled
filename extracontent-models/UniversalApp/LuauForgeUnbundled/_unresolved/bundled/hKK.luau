require("@luauforge/bundled/hKL")

local module = require("@luauforge/bundled/hKN")
local module2 = require("@luauforge/bundled/hKO")

return table.freeze({
	tab = module.tab,
	page = module.page,
	overlay = module.overlay,
	root = module2.root,
	stack = module2.stack,
	switch = module2.switch
})
