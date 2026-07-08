local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent

require(ParentParent.ES7Types)

local map = require(scriptParent.map)

return function(p1, s1: string?) -- line: 22
	-- upvalues: map (copy)
	if #p1 == 0 then
		return ""
	end

	local v6 = map(p1, function(p2) -- line: 27
		return (tostring(p2))
	end)

	return table.concat(v6, s1 or ",")
end
