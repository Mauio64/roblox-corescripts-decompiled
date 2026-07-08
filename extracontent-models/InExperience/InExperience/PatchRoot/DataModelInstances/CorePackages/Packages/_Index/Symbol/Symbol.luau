local Symbol = require(script.Symbol)
local lib = require(script["Registry.global"])
local self = setmetatable({}, {
	__call = function(_, s1: string?) -- line: 29
		-- upvalues: Symbol (copy)
		return Symbol.new(s1)
	end
})

self.for_ = lib.getOrInit

return self
