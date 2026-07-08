local Symbol = require(script.Symbol)
local GlobalRegistry = require(script.GlobalRegistry)
local self = setmetatable({}, {
	__call = function(_, s1: string?) -- line: 14
		-- upvalues: Symbol (copy)
		return Symbol.new(s1)
	end
})

self.for_ = GlobalRegistry.getOrInit

return self
