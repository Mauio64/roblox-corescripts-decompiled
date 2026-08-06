local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local MomentsCommon = require(MomentsParent.MomentsCommon)

require(MomentsParent.MomentsTypes)

local FFlagMomentsImpressionDestinationUniverseId = require(Moments.Flags.FFlagMomentsImpressionDestinationUniverseId)
local GetFFlagMomentsAnalyticsSchemaIdentity = MomentsCommon.Flags.GetFFlagMomentsAnalyticsSchemaIdentity

local function makeMomentViewBeganFields(p1, s1: string) -- line: 32
	-- upvalues: GetFFlagMomentsAnalyticsSchemaIdentity (copy), MomentsCommon (copy), FFlagMomentsImpressionDestinationUniverseId (copy)
	local recommendationMetadata = p1.recommendationMetadata

	if GetFFlagMomentsAnalyticsSchemaIdentity() then
		local feedItemId = recommendationMetadata.feedItemId

		if feedItemId == nil or feedItemId == "" then
			local v11 = feedItemId ~= nil and "empty" or "nil"

			MomentsCommon.Analytics.reportMomentSkip("impression", v11, {
				entry = s1
			})

			return nil
		end

		local t1 = {
			viewMode = "vertical",
			momentId = p1.momentId,
			feedItemId = feedItemId,
			feedSessionId = recommendationMetadata.tracingId or "",
			source = s1
		}
		local universeId = p1.metadata.universeId

		if FFlagMomentsImpressionDestinationUniverseId and universeId ~= nil and universeId > 0 then
			t1.destinationUniverseId = tostring(universeId)
		end

		return t1
	end

	return {
		viewMode = "vertical",
		momentId = p1.momentId,
		itemId = recommendationMetadata.feedItemId,
		tracingId = recommendationMetadata.tracingId or ""
	}
end

return makeMomentViewBeganFields
