local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local useDispatch = require(ProfilePlatformParent.RoactUtils).Hooks.RoactRodux.useDispatch
local EditProfileBackground = require(ProfilePlatformParent.EditProfileBackground)
local refreshProfilePlatformUserInfo = require(ProfilePlatform.Networking.refreshProfilePlatformUserInfo)
local useLocalUserId = require(ProfilePlatformParent.RobloxAppHooks).useLocalUserId
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local Enums = require(ProfilePlatform.Common.Enums)
local DefaultAnalyticsService = require(ProfilePlatformParent.SocialLuaAnalytics).Analytics.DefaultAnalyticsService
local Analytics = require(ProfilePlatformParent.EditProfileBackground).Analytics

local function EditProfileBackgroundPageWrapper(_) -- line: 17
	-- upvalues: useDispatch (copy), useLocalUserId (copy), useProfileJsonComponent (copy), Enums (copy), React (copy), refreshProfilePlatformUserInfo (copy), Analytics (copy), DefaultAnalyticsService (copy), EditProfileBackground (copy)
	local v14 = useDispatch()
	local v15 = useLocalUserId()
	local v16 = useProfileJsonComponent(Enums.Components.ProfileBackground)
	local v17 = React.useCallback(function() -- line: 23
		-- upvalues: v14 (copy), refreshProfilePlatformUserInfo (copy), v15 (copy)
		v14(refreshProfilePlatformUserInfo((tostring(v15))))
	end)
	local v18 = Analytics.setupFireAnalyticsEvents({
		analytics = {
			EventStream = DefaultAnalyticsService.EventStream,
			Telemetry = DefaultAnalyticsService.Telemetry
		},
		infoForAllEvents = {
			uid = tostring(v15)
		}
	})

	return React.createElement(Analytics.Context.Provider, {
		value = {
			fireAnalyticsEvent = v18
		}
	}, { React.createElement(EditProfileBackground.EditProfileBackgroundPage, {
		onBackgroundChanged = v17,
		profileBackgroundData = v16
	}) })
end

return EditProfileBackgroundPageWrapper
