local parent = script:FindFirstAncestor("Moments").Parent

local MomentsCommon = require(parent.MomentsCommon)

local firePostInsightsCoachmarkEvent = require(script.Parent.firePostInsightsCoachmarkEvent)
local postInsightsCoachmarkImpressionCache = require(script.Parent.postInsightsCoachmarkImpressionCache)

local EventNames = MomentsCommon.Analytics.EventNames

local function dismissPostInsightsCoachmark()
	local value = postInsightsCoachmarkImpressionCache.getValue()

	if value < 0 then
		return
	end

	postInsightsCoachmarkImpressionCache.dismissValue()

	if value > 0 then
		firePostInsightsCoachmarkEvent(EventNames.FTUXTooltipDismissed)
	end
end

return dismissPostInsightsCoachmark
