local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils").Hooks.RoactRodux.useDispatch
local EditProfileBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/EditProfileBackground")
local refreshProfilePlatformUserInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/refreshProfilePlatformUserInfo")
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppHooks").useLocalUserId
local useProfileJsonComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileJsonComponent")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")

local defaultAnalyticsService = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SocialLuaAnalytics").Analytics.DefaultAnalyticsService
local analytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/EditProfileBackground").Analytics

local function EditProfileBackgroundPageWrapper(p2)
	local v5 = useDispatch()
	local v6 = useLocalUserId()

	local v7 = useProfileJsonComponent(Enums.Components.ProfileBackground)

	local v8 = React.useCallback(function()
		v5(refreshProfilePlatformUserInfo((tostring(v6))))
	end)

	local v9 = analytics.setupFireAnalyticsEvents({
		analytics = {
			EventStream = defaultAnalyticsService.EventStream,
			Telemetry = defaultAnalyticsService.Telemetry
		},
		infoForAllEvents = { uid = tostring(v6) }
	})

	return React.createElement(analytics.Context.Provider, {
		value = { fireAnalyticsEvent = v9 }
	}, { React.createElement(EditProfileBackground.EditProfileBackgroundPage, {
			onBackgroundChanged = v8,
			profileBackgroundData = v7
		}) })
end

return EditProfileBackgroundPageWrapper
