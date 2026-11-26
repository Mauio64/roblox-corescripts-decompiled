local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")

local function makeFeedActionFields(p2, p3, value, p4)
	if p3 ~= nil and p3 ~= "" then
		return {
			momentId = p2,
			feedItemId = p3,
			feedSessionId = value or ""
		}
	end

	local v5 = p3 == nil and "nil" or "empty"
	MomentsCommon.Analytics.reportMomentSkip("feed_action", v5, { action = p4 })
	return nil
end

return makeFeedActionFields
