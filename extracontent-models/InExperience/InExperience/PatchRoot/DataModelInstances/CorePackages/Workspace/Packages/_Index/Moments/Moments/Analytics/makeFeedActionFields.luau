local parent = script:FindFirstAncestor("Moments").Parent

local MomentsCommon = require(parent.MomentsCommon)

local function makeFeedActionFields(momentId: string, feedItemId: string?, value: string?, action: string?)
	if feedItemId ~= nil and feedItemId ~= "" then
		return {
			momentId = momentId,
			feedItemId = feedItemId,
			feedSessionId = value or ""
		}
	end

	local v = feedItemId == nil and "nil" or "empty"
	MomentsCommon.Analytics.reportMomentSkip("feed_action", v, { action = action })
	return nil
end

return makeFeedActionFields
