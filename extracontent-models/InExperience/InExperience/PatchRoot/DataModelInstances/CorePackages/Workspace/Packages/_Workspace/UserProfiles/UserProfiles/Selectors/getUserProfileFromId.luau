local parent = script:FindFirstAncestor("UserProfiles").Parent
local Cryo = require(parent.Cryo)

return function(p, p2)
	local where = Cryo.List.findWhere(p.userProfiles, function(p3, _): boolean
		return p3.id == tostring(p2)
	end)

	return p.userProfiles[where] or {}
end
