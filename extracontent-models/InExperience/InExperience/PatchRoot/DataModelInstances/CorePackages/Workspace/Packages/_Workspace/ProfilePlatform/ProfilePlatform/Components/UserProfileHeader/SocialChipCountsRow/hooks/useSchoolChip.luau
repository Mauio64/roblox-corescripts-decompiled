local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local React = require(parent.React)
local Localization = require(parent.Localization)
local Navigation = require(parent.Navigation)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)

local Enums = require(ProfilePlatform.Common.Enums)
require(ProfilePlatform.Common.Types)
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)

local useNavigation = Navigation.useNavigation
local useLocalization = Localization.Hooks.useLocalization
local Contexts = SocialLuaAnalytics.Analytics.Enums.Contexts

local function useSchoolChip(p)
	local v = useNavigation()
	local school = useProfileJsonComponent(Enums.Components.UserProfileHeader).school

	local v2 = useLocalization({ classmates = TextKeys.Classmates })

	local text = React.useMemo(function()
		local v3

		if school then
			v3 = school.isSameSchool
		end

		return if v3 then v2.classmates else nil
	end, { school, v2 })

	local onActivated = React.useCallback(function()
		p.fireAnalyticsEvent(EventNames.SchoolButton)
		v.navigate(AppPage.Schools, {
			extraProps = { source = Contexts.PlayerProfile }
		})
	end, { p, v })

	return React.useMemo(function()
		if text == nil then
			return nil
		end

		return { text = text, layoutOrder = 0, isDisabled = false, onActivated = onActivated }
	end, { text, onActivated })
end

return useSchoolChip
