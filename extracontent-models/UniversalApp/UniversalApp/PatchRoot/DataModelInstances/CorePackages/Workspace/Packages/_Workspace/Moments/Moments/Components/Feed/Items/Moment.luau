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
local toMediaItem = require(Moments.Components.Feed.Media.toMediaItem)
local MomentMediaView = MomentsCommon.Media.MomentMediaView

local function momentAttribution(p1) -- line: 46
	if p1 == nil then
		return nil
	end

	local recommendationMetadata = p1.recommendationMetadata

	if recommendationMetadata == nil or recommendationMetadata.itemId == nil or recommendationMetadata.itemId == "" then
		return nil
	end

	return {
		itemId = recommendationMetadata.itemId,
		tracingId = recommendationMetadata.tracingId
	}
end

return {
	{
		kind = "moment",
		getKey = function(p2) -- line: 65
			local moment = p2.moment
			local recommendationMetadata = moment.recommendationMetadata

			if recommendationMetadata and (recommendationMetadata.itemId and recommendationMetadata.itemId ~= "") then
				return recommendationMetadata.itemId
			end

			return moment.momentId
		end,
		getAttribution = function(p3) -- line: 79
			local moment = p3.moment

			if moment == nil then
				return nil
			end

			local recommendationMetadata = moment.recommendationMetadata

			if recommendationMetadata == nil or recommendationMetadata.itemId == nil or recommendationMetadata.itemId == "" then
				return nil
			end

			return {
				itemId = recommendationMetadata.itemId,
				tracingId = recommendationMetadata.tracingId
			}
		end,
		render = function(p4, _: number) -- line: 83
			-- upvalues: toMediaItem (copy), React (copy), MomentMediaView (copy), GetMomentsPreferencesStore (copy), GetFFlagMomentsPartnerContentLabel (copy), MomentItem (copy)
			local moment = p4.moment

			if moment == nil then
				return nil
			end

			local v23 = nil
			local v24 = toMediaItem(p4)

			if v24 ~= nil then
				v23 = React.createElement(MomentMediaView, {
					suppressTapToToggle = true,
					momentId = v24.momentId,
					posterContent = v24.posterContent,
					showLoadingSkeleton = v24.captureType == Enum.CaptureType.Video,
					getScaleType = GetMomentsPreferencesStore(false).getMediaScaleType
				})
			end

			local recommendationMetadata = moment.recommendationMetadata
			local v26 = GetFFlagMomentsPartnerContentLabel() and moment.metadata.partnerUploadType == "influencer"
			local t1 = {
				kind = "experience",
				creatorIsVerified = nil,
				commentCount = nil,
				momentId = moment.momentId,
				itemId = moment.recommendationMetadata and moment.recommendationMetadata.itemId,
				creatorId = moment.creatorId,
				placeId = moment.metadata.placeId or 0,
				universeId = moment.metadata.universeId or 0,
				isSponsored = v26,
				description = moment.metadata.description,
				isModerated = moment.isModerated == true,
				feedItemId = if recommendationMetadata == nil then nil else recommendationMetadata.itemId,
				feedSessionId = if recommendationMetadata == nil then nil else recommendationMetadata.tracingId
			}

			return React.createElement(MomentItem, {
				data = t1,
				mediaSurface = v23,
				moment = moment
			})
		end
	},
	{
		kind = "skeleton",
		getKey = function(_) -- line: 154
			return "__feed_skeleton__"
		end,
		getAttribution = function(_) -- line: 159
			return nil
		end,
		render = function(_, _: number) -- line: 163
			-- upvalues: React (copy), MomentItemSkeleton (copy)
			return React.createElement(MomentItemSkeleton)
		end
	}
}
