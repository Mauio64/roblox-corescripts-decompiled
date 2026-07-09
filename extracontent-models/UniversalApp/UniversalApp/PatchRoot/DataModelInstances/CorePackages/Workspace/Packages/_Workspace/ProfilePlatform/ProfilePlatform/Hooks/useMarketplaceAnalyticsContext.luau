local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local Enums = require(ProfilePlatform.Common.Enums)
local AppPage = require(ProfilePlatformParent.RobloxAppEnums).AppPage
local Contexts = require(ProfilePlatformParent.SocialLuaAnalytics).Analytics.Enums.Contexts
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)

return function() -- line: 13
	-- upvalues: useProfileWrapperContext (copy), React (copy), Enums (copy), Contexts (copy), AppPage (copy)
	local v8 = useProfileWrapperContext()

	return React.useMemo(function() -- line: 16
		-- upvalues: v8 (copy), Enums (copy), Contexts (copy), AppPage (copy)
		if v8.profileType == Enums.ProfileTypes.Community then
			return Contexts.CommunityProfile
		end

		if v8.profileType == Enums.ProfileTypes.User then
			return Contexts.PlayerProfile
		end

		return AppPage.ProfilePlatform
	end, { v8.profileType })
end
