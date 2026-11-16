local getUserProfileFromId = require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/UserProfiles/Selectors/getUserProfileFromId")

return function(p2, p3)
	local v5 = getUserProfileFromId(p2, p3)

	if v5.names then
		return v5.names.combinedName
	end

	return nil
end
