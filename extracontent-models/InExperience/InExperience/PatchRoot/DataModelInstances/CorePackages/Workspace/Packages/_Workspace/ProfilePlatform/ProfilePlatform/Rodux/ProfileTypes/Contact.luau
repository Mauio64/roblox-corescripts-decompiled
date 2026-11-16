local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local Rodux = require(parent.Rodux)

local Enums = require(ProfilePlatform.Common.Enums)
require(ProfilePlatform.Common.Types)
local getProfilePlatform = require(ProfilePlatform.Networking.getProfilePlatform)
local mergeProfileStateAndResponse = require(ProfilePlatform.Rodux.ProfileTypes.mergeProfileStateAndResponse)

return Rodux.createReducer({}, {
	[getProfilePlatform.Succeeded.name] = function(p, p2)
		local responseBody = p2.responseBody

		if responseBody.profileType == Enums.ProfileTypes.Contact then
			return mergeProfileStateAndResponse(p, responseBody)
		end

		return p
	end
})
