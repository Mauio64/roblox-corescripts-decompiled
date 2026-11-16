local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Rodux")

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Types")
local getProfilePlatform = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/getProfilePlatform")
local mergeProfileStateAndResponse = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Rodux/ProfileTypes/mergeProfileStateAndResponse")
local FFlagProfilePlatformGracefulVisibility = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformGracefulVisibility")

require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Types/Component")

return Rodux.createReducer({}, {
	[getProfilePlatform.Succeeded.name] = function(p2, p3)
		local responseBody = p3.responseBody

		if responseBody.profileType ~= Enums.ProfileTypes.User then
			return p2
		end

		local v6 = nil

		if FFlagProfilePlatformGracefulVisibility and responseBody.onlyEssentialComponents ~= true then
			for k, v8 in not (p3.postBody and p3.postBody.components) and {} or p3.postBody.components do
				if
					v8.component == Enums.Components.Friends
					and responseBody.components[Enums.Components.Friends] == nil
				then
					v6 = { Enums.Components.Friends }
					break
				end
			end
		end

		return mergeProfileStateAndResponse(p2, responseBody, v6)
	end
})
