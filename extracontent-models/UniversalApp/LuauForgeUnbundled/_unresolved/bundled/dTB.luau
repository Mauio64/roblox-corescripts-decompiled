local module = require("@luauforge/bundled/dTl")

local signal, v5 = module.createSignal(nil)

local signal2, v6 = module.createSignal(nil)

return {
	getActiveL1Id = signal,
	getActiveLeafId = signal2,
	setFromL1 = function(p2, p3)
		v5(p2)
		v6(p3)
	end,
	setFromL2 = function(p2)
		v6(p2)
	end,
	resetForTests = function()
		v5(nil)
		v6(nil)
	end
}
