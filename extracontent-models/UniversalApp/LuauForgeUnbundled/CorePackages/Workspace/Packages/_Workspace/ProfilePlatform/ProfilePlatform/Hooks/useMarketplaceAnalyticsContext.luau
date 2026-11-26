local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppEnums").AppPage

local contexts = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SocialLuaAnalytics").Analytics.Enums.Contexts

local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")

return function()
	local v5 = useProfileWrapperContext()

	return React.useMemo(function()
		if v5.profileType == Enums.ProfileTypes.Community then
			return contexts.CommunityProfile
		end

		if v5.profileType == Enums.ProfileTypes.User then
			return contexts.PlayerProfile
		end

		return appPage.ProfilePlatform
	end, { v5.profileType })
end
