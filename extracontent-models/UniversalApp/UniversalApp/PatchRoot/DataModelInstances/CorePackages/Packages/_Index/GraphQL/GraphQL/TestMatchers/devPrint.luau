local parent = script.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local inspect = LuauPolyfill.util.inspect

local function devPrint(...)
	local v = {}

	for i = 1, select("#", ...) do
		v[i] = inspect((select(i, ...)))
	end

	print(table.unpack(v))
end

return devPrint
