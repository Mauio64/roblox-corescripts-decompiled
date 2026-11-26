local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")

local function makeJoinImpressionFields(p2, p3)
	local recommendationMetadata = p2.recommendationMetadata
	local feedItemId = if recommendationMetadata ~= nil then recommendationMetadata.feedItemId else nil

	if feedItemId == nil or feedItemId == "" then
		local v5 = feedItemId == nil and "nil" or "empty"
		MomentsCommon.Analytics.reportMomentSkip("join_impression", v5, { entry = p3 })
		return nil
	else
		local v5 = {
			feedItemId = feedItemId,
			feedSessionId = recommendationMetadata.tracingId or "",
			source = p3,
			surface = "feed_cta"
		}

		local universeId = p2.metadata.universeId

		if universeId ~= nil and universeId > 0 then
			v5.destinationUniverseId = tostring(universeId)
		end

		return v5
	end
end

return makeJoinImpressionFields
