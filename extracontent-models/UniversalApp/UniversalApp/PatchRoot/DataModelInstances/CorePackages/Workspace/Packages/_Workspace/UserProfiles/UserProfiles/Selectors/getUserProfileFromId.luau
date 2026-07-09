local Parent = script:FindFirstAncestor("UserProfiles").Parent
local Cryo = require(Parent.Cryo)

return function(p1, p2) -- line: 5
	-- upvalues: Cryo (copy)
	local v5 = Cryo.List.findWhere(p1.userProfiles, function(p3, _) -- line: 6
		-- upvalues: p2 (copy)
		return p3.id == tostring(p2)
	end)

	return p1.userProfiles[v5] or {}
end
