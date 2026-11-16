local parent = script.Parent
local reduce = require(parent.reduce)

local function sum(p)
	return reduce(p, function(p2: number, p3)
		return p2 + p3
	end, 0)
end

return sum
