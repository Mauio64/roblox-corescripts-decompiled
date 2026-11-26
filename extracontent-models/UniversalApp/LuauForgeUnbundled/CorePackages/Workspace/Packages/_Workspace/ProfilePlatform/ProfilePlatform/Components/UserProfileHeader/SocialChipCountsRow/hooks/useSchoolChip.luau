local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization")
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Navigation")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppEnums").AppPage
local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SocialLuaAnalytics")

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Types")
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/EventNames")
local useProfileJsonComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileJsonComponent")

local useNavigation = Navigation.useNavigation
local useLocalization = Localization.Hooks.useLocalization
local contexts = SocialLuaAnalytics.Analytics.Enums.Contexts

local function useSchoolChip(p2)
	local v5 = useNavigation()
	local school = useProfileJsonComponent(Enums.Components.UserProfileHeader).school

	local v6 = useLocalization({ classmates = TextKeys.Classmates })

	local v7 = React.useMemo(function()
		local v8 = if school then school.isSameSchool else nil

		if v8 then
			return v6.classmates
		end

		return nil
	end, { school, v6 })

	local v8 = React.useCallback(function()
		p2.fireAnalyticsEvent(EventNames.SchoolButton)
		v5.navigate(appPage.Schools, {
			extraProps = { source = contexts.PlayerProfile }
		})
	end, { p2, v5 })

	return React.useMemo(function()
		if v7 == nil then
			return nil
		end

		return { text = v7, layoutOrder = 0, isDisabled = false, onActivated = v8 }
	end, { v7, v8 })
end

return useSchoolChip
