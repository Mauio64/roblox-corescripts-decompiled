local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Cryo")

require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Types")

return function(p2)
	if p2 then
		return Cryo.Dictionary.map(p2, function(p3)
			return {
				id = p3.experienceId,
				universeId = tonumber(p3.experienceId),
				placeId = tonumber(p3.rootPlaceId)
			}
		end)
	end

	return {}
end
