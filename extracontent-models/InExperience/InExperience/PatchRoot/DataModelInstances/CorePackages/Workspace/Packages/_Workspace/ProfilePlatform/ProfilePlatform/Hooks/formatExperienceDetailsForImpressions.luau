local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local Cryo = require(parent.Cryo)

require(ProfilePlatform.Common.Types)

return function(p)
	if p then
		return Cryo.Dictionary.map(p, function(p2)
			return {
				id = p2.experienceId,
				universeId = tonumber(p2.experienceId),
				placeId = tonumber(p2.rootPlaceId)
			}
		end)
	end

	return {}
end
