local parent = script:FindFirstAncestor("Moments").Parent

local Players = game:GetService("Players")

local MomentsCommon = require(parent.MomentsCommon)

local function firePostInsightsCoachmarkEvent(p: string)
	MomentsCommon.Analytics.fireAnalyticsEvent(p, {
		userId = tostring(not Players.LocalPlayer and 0 or Players.LocalPlayer.UserId),
		timestamp = tostring(os.time()),
		identifier = "moments_post_insights"
	})
end

return firePostInsightsCoachmarkEvent
