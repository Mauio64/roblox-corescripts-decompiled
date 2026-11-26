local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Rodux")

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Types")
local getProfilePlatform = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/getProfilePlatform")
local mergeProfileStateAndResponse = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Rodux/ProfileTypes/mergeProfileStateAndResponse")

return Rodux.createReducer({}, {
	[getProfilePlatform.Succeeded.name] = function(p2, p3)
		local responseBody = p3.responseBody

		if responseBody.profileType == Enums.ProfileTypes.Community then
			return mergeProfileStateAndResponse(p2, responseBody)
		end

		return p2
	end
})
