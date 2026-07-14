local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local MomentsCommon = require(MomentsParent.MomentsCommon)

require(MomentsParent.MomentsTypes)

local GetFFlagMomentsAnalyticsSchemaIdentity = MomentsCommon.Flags.GetFFlagMomentsAnalyticsSchemaIdentity

require(Moments.Components.Feed.FeedTypes)

local function makeRecommendationAttribution(p1) -- line: 34
	-- upvalues: GetFFlagMomentsAnalyticsSchemaIdentity (copy)
	if p1 == nil then
		return nil
	end

	if GetFFlagMomentsAnalyticsSchemaIdentity() then
		local feedItemId = p1.feedItemId

		if feedItemId == nil or feedItemId == "" then
			return nil
		end

		return {
			itemId = feedItemId,
			tracingId = p1.tracingId
		}
	end

	if p1.itemId == nil or p1.itemId == "" then
		return nil
	end

	return {
		itemId = p1.itemId,
		tracingId = p1.tracingId
	}
end

return makeRecommendationAttribution
