local scriptParent = script.Parent
local collect = require(scriptParent.collect)

local function keyBy(t1: {[any]: any}, p1) -- line: 15
	-- upvalues: collect (copy)
	return collect(t1, function(p2, p3) -- line: 16
		-- upvalues: p1 (copy)
		return if typeof(p1) ~= "function" then p3[p1] else p1(p3, p2), p3
	end)
end

return keyBy
