local module = require("@luauforge/bundled/dPU")
local module2 = require("@luauforge/bundled/dPV")

local v5 = {
	activeCategoryId = module2.createSignal(nil),
	activeSubcategoryId = module2.createSignal(nil)
}

return { Context = module.createContext(v5) }
