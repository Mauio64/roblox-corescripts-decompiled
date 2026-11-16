local parent = script.Parent
local None = require(parent.None)
require(parent.Types)
local forEach = require(parent.forEach)
local function joinDeep(p, p2)
	local clone = table.clone(p)

	forEach(p2, function(p3, p4)
		if typeof(p[p4]) == "table" and typeof(p3) == "table" then
			clone[p4] = joinDeep(p[p4], p3)
		elseif p3 == None then
			clone[p4] = nil
		else
			clone[p4] = p3
		end
	end)
	return clone
end

return joinDeep
