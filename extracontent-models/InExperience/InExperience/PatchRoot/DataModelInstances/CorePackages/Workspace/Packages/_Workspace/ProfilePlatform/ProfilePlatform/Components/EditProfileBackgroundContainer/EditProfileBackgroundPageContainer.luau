local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local EditProfileBackground = require(parent.EditProfileBackground)
local refreshProfilePlatformUserInfo = require(ProfilePlatform.Networking.refreshProfilePlatformUserInfo)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local Enums = require(ProfilePlatform.Common.Enums)

local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local DefaultAnalyticsService = SocialLuaAnalytics.Analytics.DefaultAnalyticsService
local EditProfileBackground2 = require(parent.EditProfileBackground)
local Analytics = EditProfileBackground2.Analytics

local function EditProfileBackgroundPageWrapper(_)
	local v = useDispatch()
	local v2 = useLocalUserId()

	local profileBackgroundData = useProfileJsonComponent(Enums.Components.ProfileBackground)

	local onBackgroundChanged = React.useCallback(function()
		v(refreshProfilePlatformUserInfo((tostring(v2))))
	end)

	local fireAnalyticsEvent = Analytics.setupFireAnalyticsEvents({
		analytics = {
			EventStream = DefaultAnalyticsService.EventStream,
			Telemetry = DefaultAnalyticsService.Telemetry
		},
		infoForAllEvents = { uid = tostring(v2) }
	})

	return React.createElement(Analytics.Context.Provider, {
		value = { fireAnalyticsEvent = fireAnalyticsEvent }
	}, { React.createElement(EditProfileBackground.EditProfileBackgroundPage, {
			onBackgroundChanged = onBackgroundChanged,
			profileBackgroundData = profileBackgroundData
		}) })
end

return EditProfileBackgroundPageWrapper
