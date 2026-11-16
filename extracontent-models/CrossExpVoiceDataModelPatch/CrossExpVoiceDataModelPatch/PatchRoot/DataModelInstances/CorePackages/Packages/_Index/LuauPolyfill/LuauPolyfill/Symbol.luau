local Symbol = require(script.Symbol)

local GlobalRegistry = require(script.GlobalRegistry)

local self = setmetatable({}, {
	__call = function(_, p: string?)
		return Symbol.new(p)
	end
})

self.for_ = GlobalRegistry.getOrInit

return self
