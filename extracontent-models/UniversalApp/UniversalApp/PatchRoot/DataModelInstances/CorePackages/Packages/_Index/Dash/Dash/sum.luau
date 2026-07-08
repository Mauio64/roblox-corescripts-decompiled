local scriptParent = script.Parent
local reduce = require(scriptParent.reduce)

local function sum(t1: {[any]: any}) -- line: 16
	-- upvalues: reduce (copy)
	return reduce(t1, function(n1: number, p1) -- line: 17
		return n1 + p1
	end, 0)
end

return sum
