local getUserProfileFromId = require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/UserProfiles/Selectors/getUserProfileFromId")

return function(p2, p3)
	return getUserProfileFromId(p2, p3).platformProfileId
end
