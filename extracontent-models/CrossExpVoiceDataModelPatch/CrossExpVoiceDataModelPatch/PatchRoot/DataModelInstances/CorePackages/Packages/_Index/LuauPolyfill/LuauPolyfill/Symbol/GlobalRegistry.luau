local Symbol = require(script.Parent.Symbol)

local v = {}
local GlobalRegistry = {}

function GlobalRegistry.getOrInit(p: string)
	if v[p] == nil then
		v[p] = Symbol.new(p)
	end

	return v[p]
end

function GlobalRegistry.__clear()
	v = {}
end

return GlobalRegistry
