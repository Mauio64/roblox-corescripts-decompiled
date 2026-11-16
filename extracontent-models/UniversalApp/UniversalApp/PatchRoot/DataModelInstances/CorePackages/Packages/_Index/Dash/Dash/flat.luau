local parent = script.Parent
local append = require(parent.append)
local forEach = require(parent.forEach)

local function flat(p)
	local v = {}
	forEach(p, function(p2)
		append(v, p2)
	end)
	return v
end

return flat
