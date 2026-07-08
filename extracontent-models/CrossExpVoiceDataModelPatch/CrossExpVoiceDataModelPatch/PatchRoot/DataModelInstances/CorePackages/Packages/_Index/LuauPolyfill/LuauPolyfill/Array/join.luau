local ParentParent = script.Parent.Parent

require(ParentParent.types)

local map = require(script.Parent.map)

return function(p1, s1: string?) -- line: 7
	-- upvalues: map (copy)
	if #p1 == 0 then
		return ""
	end

	local v5 = map(p1, function(p2) -- line: 12
		return (tostring(p2))
	end)

	return table.concat(v5, s1 or ",")
end
