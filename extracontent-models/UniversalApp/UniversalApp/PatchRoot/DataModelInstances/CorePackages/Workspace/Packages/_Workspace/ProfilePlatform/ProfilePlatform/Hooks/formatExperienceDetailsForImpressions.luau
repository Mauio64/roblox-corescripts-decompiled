local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local Cryo = require(ProfilePlatformParent.Cryo)

require(ProfilePlatform.Common.Types)

return function(t1: {[any]: any}?) -- line: 9
	-- upvalues: Cryo (copy)
	if not t1 then
		return {}
	end

	return Cryo.Dictionary.map(t1, function(p1) -- line: 14
		return {
			id = p1.experienceId,
			universeId = tonumber(p1.experienceId),
			placeId = tonumber(p1.rootPlaceId)
		}
	end)
end
