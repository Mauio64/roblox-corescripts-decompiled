local parent = script.Parent
local parent2 = parent.Parent.Parent
require(parent2.ES7Types)

local map = require(parent.map)

return function(list, value: string?)
	if #list == 0 then
		return ""
	end

	local v = map(list, function(p)
		return (tostring(p))
	end)

	return table.concat(v, value or ",")
end
