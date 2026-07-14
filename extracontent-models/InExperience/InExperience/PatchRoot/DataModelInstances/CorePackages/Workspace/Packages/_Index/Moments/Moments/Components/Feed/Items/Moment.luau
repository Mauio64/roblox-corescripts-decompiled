local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local React = require(MomentsParent.React)

require(Moments.Components.Feed.FeedTypes)

local MomentItem = require(script.MomentItem)
local MomentItemSkeleton = require(script.MomentItemSkeleton)

require(script.createMomentStore)

local MomentsCommon = require(MomentsParent.MomentsCommon)

require(MomentsParent.MomentsTypes)

local GetMomentsPreferencesStore = require(Moments.Stores.GetMomentsPreferencesStore)
local GetFFlagMomentsPartnerContentLabel = require(Moments.Flags.GetFFlagMomentsPartnerContentLabel)
local makeRecommendationAttribution = require(Moments.Analytics.makeRecommendationAttribution)
local toMediaItem = require(Moments.Components.Feed.Media.toMediaItem)
local MomentMediaView = MomentsCommon.Media.MomentMediaView

local function momentAttribution(p1) -- line: 49
	-- upvalues: makeRecommendationAttribution (copy)
	if p1 == nil then
		return nil
	end

	return makeRecommendationAttribution(p1.recommendationMetadata)
end

return {
	{
		kind = "moment",
		getKey = function(p2) -- line: 61
			local moment = p2.moment
			local recommendationMetadata = moment.recommendationMetadata

			if recommendationMetadata and (recommendationMetadata.itemId and recommendationMetadata.itemId ~= "") then
				return recommendationMetadata.itemId
			end

			return moment.momentId
		end,
		getAttribution = function(p3) -- line: 75
			-- upvalues: momentAttribution (copy)
			return momentAttribution(p3.moment)
		end,
		render = function(p4, _: number) -- line: 79
			-- upvalues: toMediaItem (copy), React (copy), MomentMediaView (copy), GetMomentsPreferencesStore (copy), GetFFlagMomentsPartnerContentLabel (copy), MomentItem (copy)
			local moment = p4.moment

			if moment == nil then
				return nil
			end

			local v21 = nil
			local v22 = toMediaItem(p4)

			if v22 ~= nil then
				v21 = React.createElement(MomentMediaView, {
					suppressTapToToggle = true,
					momentId = v22.momentId,
					posterContent = v22.posterContent,
					showLoadingSkeleton = v22.captureType == Enum.CaptureType.Video,
					getScaleType = GetMomentsPreferencesStore(false).getMediaScaleType
				})
			end

			local recommendationMetadata = moment.recommendationMetadata
			local v24 = GetFFlagMomentsPartnerContentLabel() and moment.metadata.partnerUploadType == "influencer"
			local t1 = {
				kind = "experience",
				creatorIsVerified = nil,
				commentCount = nil,
				momentId = moment.momentId,
				itemId = moment.recommendationMetadata and moment.recommendationMetadata.itemId,
				creatorId = moment.creatorId,
				placeId = moment.metadata.placeId or 0,
				universeId = moment.metadata.universeId or 0,
				isSponsored = v24,
				description = moment.metadata.description,
				isModerated = moment.isModerated == true,
				feedItemId = if recommendationMetadata == nil then nil else recommendationMetadata.itemId,
				feedSessionId = if recommendationMetadata == nil then nil else recommendationMetadata.tracingId,
				feedItemIdRaw = if recommendationMetadata == nil then nil else recommendationMetadata.feedItemId
			}

			return React.createElement(MomentItem, {
				data = t1,
				mediaSurface = v21,
				moment = moment
			})
		end
	},
	{
		kind = "skeleton",
		getKey = function(_) -- line: 153
			return "__feed_skeleton__"
		end,
		getAttribution = function(_) -- line: 158
			return nil
		end,
		render = function(_, _: number) -- line: 162
			-- upvalues: React (copy), MomentItemSkeleton (copy)
			return React.createElement(MomentItemSkeleton)
		end
	}
}
