local scriptParent = script.Parent
local None = require(scriptParent.None)

require(scriptParent.Types)

local function union(t1: {[any]: any}, t2: {[any]: any}) -- line: 14
	-- upvalues: None (copy)
	local v6 = table.clone(t1)

	for v7, v8 in t2 do
		if v8 == None then
			v6[v7] = nil
		else
			v6[v7] = v8
		end
	end

	return v6
end

return union
