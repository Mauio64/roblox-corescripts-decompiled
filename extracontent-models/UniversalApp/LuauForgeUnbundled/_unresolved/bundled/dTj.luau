local module = require("@luauforge/bundled/dTk")
local module2 = require("@luauforge/bundled/dTl")

local v5 = {
	activeCategoryId = module2.createSignal(nil),
	activeSubcategoryId = module2.createSignal(nil)
}

return { Context = module.createContext(v5) }
