local Players = game:GetService("Players")

local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")

local function firePostInsightsCoachmarkEvent(p2)
	MomentsCommon.Analytics.fireAnalyticsEvent(p2, {
		userId = tostring(not Players.LocalPlayer and 0 or Players.LocalPlayer.UserId),
		timestamp = tostring(os.time()),
		identifier = "moments_post_insights"
	})
end

return firePostInsightsCoachmarkEvent
