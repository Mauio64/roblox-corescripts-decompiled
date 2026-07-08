local EditProfile = script:FindFirstAncestor("EditProfile")
local EditProfileParent = EditProfile.Parent
local React = require(EditProfileParent.React)
local useLocalUserId = require(EditProfileParent.RobloxAppHooks).useLocalUserId
local EditProfileIXP = require(EditProfile.Flags.EditProfileIXP)
local Analytics = require(EditProfile.Analytics)
local DefaultAnalyticsService = require(EditProfileParent.SocialLuaAnalytics).Analytics.DefaultAnalyticsService
local EditUsernameWrapper = require(script.Parent.EditUsernameWrapper)

return function(p1) -- line: 13
	-- upvalues: useLocalUserId (copy), EditProfileIXP (copy), React (copy), Analytics (copy), DefaultAnalyticsService (copy), EditUsernameWrapper (copy)
	local v10 = useLocalUserId()

	if EditProfileIXP.useIsExperimentEnabled() then
		return React.createElement(Analytics.Context.Provider, {
			value = {
				fireAnalyticsEvent = Analytics.setupFireAnalyticsEvents({
					analytics = DefaultAnalyticsService,
					infoForAllEvents = {
						uid = v10
					}
				})
			}
		}, { React.createElement(EditUsernameWrapper, p1) })
	end

	return React.createElement(EditUsernameWrapper, p1)
end
