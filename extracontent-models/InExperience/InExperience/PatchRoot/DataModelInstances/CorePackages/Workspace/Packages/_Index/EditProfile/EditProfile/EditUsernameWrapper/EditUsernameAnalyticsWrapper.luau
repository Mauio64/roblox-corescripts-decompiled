local EditProfile = script:FindFirstAncestor("EditProfile")
local parent = EditProfile.Parent
local React = require(parent.React)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local EditProfileIXP = require(EditProfile.Flags.EditProfileIXP)

local Analytics = require(EditProfile.Analytics)
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local DefaultAnalyticsService = SocialLuaAnalytics.Analytics.DefaultAnalyticsService

local EditUsernameWrapper = require(script.Parent.EditUsernameWrapper)

return function(p)
	local uid = useLocalUserId()

	if EditProfileIXP.useIsExperimentEnabled() then
		return React.createElement(Analytics.Context.Provider, {
			value = {
				fireAnalyticsEvent = Analytics.setupFireAnalyticsEvents({
					analytics = DefaultAnalyticsService,
					infoForAllEvents = { uid = uid }
				})
			}
		}, { React.createElement(EditUsernameWrapper, p) })
	end

	return React.createElement(EditUsernameWrapper, p)
end
