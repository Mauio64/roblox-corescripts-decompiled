local EditProfile = script:FindFirstAncestor("EditProfile")
local EditProfileParent = EditProfile.Parent
local React = require(EditProfileParent.React)
local useLocalUserId = require(EditProfileParent.RobloxAppHooks).useLocalUserId
local Analytics = require(EditProfile.Analytics)
local DefaultAnalyticsService = require(EditProfileParent.SocialLuaAnalytics).Analytics.DefaultAnalyticsService
local EditProfileEntryPointContainer = require(script.Parent.EditProfileEntryPointContainer)

return function(p1) -- line: 11
	-- upvalues: useLocalUserId (copy), React (copy), Analytics (copy), DefaultAnalyticsService (copy), EditProfileEntryPointContainer (copy)
	local v9 = useLocalUserId()

	return React.createElement(Analytics.Context.Provider, {
		value = {
			fireAnalyticsEvent = Analytics.setupFireAnalyticsEvents({
				analytics = DefaultAnalyticsService,
				infoForAllEvents = {
					uid = v9
				}
			})
		}
	}, { React.createElement(EditProfileEntryPointContainer, p1) })
end
