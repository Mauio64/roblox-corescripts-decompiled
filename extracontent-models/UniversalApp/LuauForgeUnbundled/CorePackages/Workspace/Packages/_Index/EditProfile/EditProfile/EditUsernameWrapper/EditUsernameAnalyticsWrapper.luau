local React = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/React")
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/RobloxAppHooks").useLocalUserId
local EditProfileIXP = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Flags/EditProfileIXP")

local Analytics = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Analytics")
local defaultAnalyticsService = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/SocialLuaAnalytics").Analytics.DefaultAnalyticsService

local EditUsernameWrapper = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/EditUsernameWrapper/EditUsernameWrapper")

return function(p2)
	local v5 = useLocalUserId()

	if EditProfileIXP.useIsExperimentEnabled() then
		return React.createElement(Analytics.Context.Provider, {
			value = {
				fireAnalyticsEvent = Analytics.setupFireAnalyticsEvents({
					analytics = defaultAnalyticsService,
					infoForAllEvents = { uid = v5 }
				})
			}
		}, { React.createElement(EditUsernameWrapper, p2) })
	end

	return React.createElement(EditUsernameWrapper, p2)
end
