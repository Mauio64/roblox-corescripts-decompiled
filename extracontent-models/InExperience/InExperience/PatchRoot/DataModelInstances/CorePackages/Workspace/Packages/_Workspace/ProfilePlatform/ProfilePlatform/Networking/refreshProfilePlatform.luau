local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local Cryo = require(parent.Cryo)

local Enums = require(ProfilePlatform.Common.Enums)
local getProfilePlatform = require(ProfilePlatform.Networking.getProfilePlatform)

function refreshProfilePlatform(data)
	local mapped = Cryo.List.map(data.components, function(component)
		local v = { component = component }

		if component == Enums.Components.Actions then
			v.isActionsV2Supported = true
		end

		return v
	end)

	return getProfilePlatform.API({
		profileType = data.profileType,
		profileId = data.profileId,
		components = mapped,
		includeComponentOrdering = false
	})
end

return refreshProfilePlatform
