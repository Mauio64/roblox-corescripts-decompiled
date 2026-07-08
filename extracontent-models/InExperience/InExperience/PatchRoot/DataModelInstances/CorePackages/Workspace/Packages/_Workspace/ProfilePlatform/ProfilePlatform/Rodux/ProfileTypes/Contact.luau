local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local Rodux = require(ProfilePlatformParent.Rodux)
local Enums = require(ProfilePlatform.Common.Enums)

require(ProfilePlatform.Common.Types)

local getProfilePlatform = require(ProfilePlatform.Networking.getProfilePlatform)
local mergeProfileStateAndResponse = require(ProfilePlatform.Rodux.ProfileTypes.mergeProfileStateAndResponse)

return Rodux.createReducer({}, {
	[getProfilePlatform.Succeeded.name] = function(p1, t1: {[any]: any}) -- line: 13
		-- upvalues: Enums (copy), mergeProfileStateAndResponse (copy)
		local responseBody = t1.responseBody

		if responseBody.profileType ~= Enums.ProfileTypes.Contact then
			return p1
		end

		return mergeProfileStateAndResponse(p1, responseBody)
	end
})
