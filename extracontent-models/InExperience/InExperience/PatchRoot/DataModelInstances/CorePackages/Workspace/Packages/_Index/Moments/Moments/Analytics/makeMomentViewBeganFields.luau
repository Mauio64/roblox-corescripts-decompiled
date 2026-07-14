local Parent = script:FindFirstAncestor("Moments").Parent
local MomentsCommon = require(Parent.MomentsCommon)

require(Parent.MomentsTypes)

local GetFFlagMomentsAnalyticsSchemaIdentity = MomentsCommon.Flags.GetFFlagMomentsAnalyticsSchemaIdentity

local function makeMomentViewBeganFields(p1, s1: string) -- line: 34
	-- upvalues: GetFFlagMomentsAnalyticsSchemaIdentity (copy), MomentsCommon (copy)
	local recommendationMetadata = p1.recommendationMetadata

	if GetFFlagMomentsAnalyticsSchemaIdentity() then
		local feedItemId = recommendationMetadata.feedItemId

		if feedItemId == nil or feedItemId == "" then
			local v9 = feedItemId ~= nil and "empty" or "nil"

			MomentsCommon.Analytics.reportMomentSkip("impression", v9, {
				entry = s1
			})

			return nil
		end

		return {
			viewMode = "vertical",
			momentId = p1.momentId,
			feedItemId = feedItemId,
			feedSessionId = recommendationMetadata.tracingId or "",
			source = s1
		}
	end

	return {
		viewMode = "vertical",
		momentId = p1.momentId,
		itemId = recommendationMetadata.itemId,
		tracingId = recommendationMetadata.tracingId or ""
	}
end

return makeMomentViewBeganFields
