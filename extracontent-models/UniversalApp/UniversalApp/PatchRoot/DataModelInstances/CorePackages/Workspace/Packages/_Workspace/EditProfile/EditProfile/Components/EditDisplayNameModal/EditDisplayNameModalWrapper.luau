local EditProfile = script:FindFirstAncestor("EditProfile")
local EditProfileParent = EditProfile.Parent
local React = require(EditProfileParent.React)
local useLocalUserId = require(EditProfileParent.RobloxAppHooks).useLocalUserId
local EditProfileIXP = require(EditProfile.Flags.EditProfileIXP)
local Analytics = require(EditProfile.Analytics)
local DefaultAnalyticsService = require(EditProfileParent.SocialLuaAnalytics).Analytics.DefaultAnalyticsService
local EditDisplayNameModalContainer = require(script.Parent.EditDisplayNameModalContainer)

return function(p1) -- line: 13
	-- upvalues: useLocalUserId (copy), EditProfileIXP (copy), React (copy), Analytics (copy), DefaultAnalyticsService (copy), EditDisplayNameModalContainer (copy)
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
		}, { React.createElement(EditDisplayNameModalContainer, p1) })
	end

	return React.createElement(EditDisplayNameModalContainer, p1)
end
