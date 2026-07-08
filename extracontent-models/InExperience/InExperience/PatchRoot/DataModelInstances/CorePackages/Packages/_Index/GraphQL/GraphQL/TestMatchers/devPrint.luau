local ParentParent = script.Parent.Parent.Parent
local inspect = require(ParentParent.LuauPolyfill).util.inspect

local function devPrint(...) -- line: 19
	-- upvalues: inspect (copy)
	local t1 = {}

	for i = 1, select("#", ...) do
		local v6 = select(i, ...)

		t1[i] = inspect(v6)
	end

	print(table.unpack(t1))
end

return devPrint
