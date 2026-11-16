local parent = script.Parent
local collectSet = require(parent.collectSet)
local forEach = require(parent.forEach)
require(parent.Types)

local function omit(p, p2)
	local v = {}
	local v2 = collectSet(p2)
	forEach(p, function(_, p3)
		if not v2[p3] then
			v[p3] = p[p3]
		end
	end)
	return v
end

return omit
