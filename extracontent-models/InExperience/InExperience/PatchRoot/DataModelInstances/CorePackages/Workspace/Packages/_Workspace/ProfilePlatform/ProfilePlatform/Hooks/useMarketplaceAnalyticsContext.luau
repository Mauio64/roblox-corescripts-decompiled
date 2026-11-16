local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)

local Enums = require(ProfilePlatform.Common.Enums)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local Contexts = SocialLuaAnalytics.Analytics.Enums.Contexts

local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)

return function()
	local v = useProfileWrapperContext()

	return React.useMemo(function()
		if v.profileType == Enums.ProfileTypes.Community then
			return Contexts.CommunityProfile
		end

		if v.profileType == Enums.ProfileTypes.User then
			return Contexts.PlayerProfile
		end

		return AppPage.ProfilePlatform
	end, { v.profileType })
end
