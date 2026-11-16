local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/Cryo")

return function(p2, p3)
	local where = Cryo.List.findWhere(p2.userProfiles, function(p4, p5): boolean
		return p4.id == tostring(p3)
	end)

	return p2.userProfiles[where] or {}
end
