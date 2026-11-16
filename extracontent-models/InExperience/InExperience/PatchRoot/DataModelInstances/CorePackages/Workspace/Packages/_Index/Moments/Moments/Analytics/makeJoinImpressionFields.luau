local parent = script:FindFirstAncestor("Moments").Parent

local MomentsCommon = require(parent.MomentsCommon)
require(parent.MomentsTypes)

local function makeJoinImpressionFields(p, p2: string)
	local recommendationMetadata = p.recommendationMetadata
	local feedItemId

	if recommendationMetadata ~= nil then
		feedItemId = recommendationMetadata.feedItemId
	end

	if feedItemId == nil or feedItemId == "" then
		local v = feedItemId == nil and "nil" or "empty"
		MomentsCommon.Analytics.reportMomentSkip("join_impression", v, { entry = p2 })
		return nil
	else
		local v = {
			feedItemId = feedItemId,
			feedSessionId = recommendationMetadata.tracingId or "",
			source = p2,
			surface = "feed_cta"
		}

		local universeId = p.metadata.universeId

		if universeId ~= nil and universeId > 0 then
			v.destinationUniverseId = tostring(universeId)
		end

		return v
	end
end

return makeJoinImpressionFields
