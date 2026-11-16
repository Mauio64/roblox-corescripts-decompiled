local parent = script.Parent.Parent
require(parent.types)

local map = require(script.Parent.map)

return function(list, value: string?)
	if #list == 0 then
		return ""
	end

	local v = map(list, function(p)
		return (tostring(p))
	end)

	return table.concat(v, value or ",")
end
