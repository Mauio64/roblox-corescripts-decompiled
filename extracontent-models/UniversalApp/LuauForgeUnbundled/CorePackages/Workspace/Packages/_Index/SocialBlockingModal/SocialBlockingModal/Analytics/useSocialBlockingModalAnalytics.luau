local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialBlockingModal/React")

local AnalyticsSetup = require("@game/CorePackages/Workspace/Packages/_Index/SocialBlockingModal/SocialBlockingModal/Analytics/AnalyticsSetup")

local function useSocialBlockingModalAnalytics(p2)
	return (React.useMemo(function()
		return AnalyticsSetup({ infoForAllEvents = p2 })
	end, { p2 }))
end

return useSocialBlockingModalAnalytics
