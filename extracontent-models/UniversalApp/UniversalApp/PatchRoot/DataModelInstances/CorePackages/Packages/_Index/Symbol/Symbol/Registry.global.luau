local Symbol = require(script.Parent.Symbol)

local v = {}
local Global = {}

function Global.getOrInit(p: string)
	if v[p] == nil then
		v[p] = Symbol.new(p)
	end

	return v[p]
end

function Global.__clear()
	v = {}
end

return Global
