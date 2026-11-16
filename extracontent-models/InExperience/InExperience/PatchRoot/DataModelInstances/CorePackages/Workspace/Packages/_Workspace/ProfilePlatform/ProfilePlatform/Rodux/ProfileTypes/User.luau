local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local Rodux = require(parent.Rodux)

local Enums = require(ProfilePlatform.Common.Enums)
require(ProfilePlatform.Common.Types)
local getProfilePlatform = require(ProfilePlatform.Networking.getProfilePlatform)
local mergeProfileStateAndResponse = require(ProfilePlatform.Rodux.ProfileTypes.mergeProfileStateAndResponse)
local FFlagProfilePlatformGracefulVisibility = require(ProfilePlatform.Flags.FFlagProfilePlatformGracefulVisibility)

require(ProfilePlatform.Types.Component)

return Rodux.createReducer({}, {
	[getProfilePlatform.Succeeded.name] = function(p, p2)
		local responseBody = p2.responseBody

		if responseBody.profileType ~= Enums.ProfileTypes.User then
			return p
		end

		local v = nil

		if FFlagProfilePlatformGracefulVisibility and responseBody.onlyEssentialComponents ~= true then
			for _, v2 in not (p2.postBody and p2.postBody.components) and {} or p2.postBody.components do
				if
					v2.component == Enums.Components.Friends
					and responseBody.components[Enums.Components.Friends] == nil
				then
					v = { Enums.Components.Friends }
					break
				end
			end
		end

		return mergeProfileStateAndResponse(p, responseBody, v)
	end
})
