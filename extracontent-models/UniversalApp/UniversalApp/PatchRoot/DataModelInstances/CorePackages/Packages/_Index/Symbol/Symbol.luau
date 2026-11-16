local Symbol = require(script.Symbol)

local Registryglobal = require(script["Registry.global"])

local self = setmetatable({}, {
	__call = function(_, p: string?)
		return Symbol.new(p)
	end
})

self.for_ = Registryglobal.getOrInit

return self
