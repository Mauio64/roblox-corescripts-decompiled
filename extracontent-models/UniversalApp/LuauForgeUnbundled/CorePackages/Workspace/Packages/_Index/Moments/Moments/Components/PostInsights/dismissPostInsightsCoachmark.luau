local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")

local firePostInsightsCoachmarkEvent = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostInsights/firePostInsightsCoachmarkEvent")
local postInsightsCoachmarkImpressionCache = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostInsights/postInsightsCoachmarkImpressionCache")

local eventNames = MomentsCommon.Analytics.EventNames

local function dismissPostInsightsCoachmark()
	local value = postInsightsCoachmarkImpressionCache.getValue()

	if value < 0 then
		return
	end

	postInsightsCoachmarkImpressionCache.dismissValue()

	if value > 0 then
		firePostInsightsCoachmarkEvent(eventNames.FTUXTooltipDismissed)
	end
end

return dismissPostInsightsCoachmark
