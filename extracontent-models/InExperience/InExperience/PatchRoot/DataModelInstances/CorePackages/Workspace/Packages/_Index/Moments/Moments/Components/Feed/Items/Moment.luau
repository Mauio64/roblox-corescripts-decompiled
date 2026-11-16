local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local React = require(parent.React)

require(Moments.Components.Feed.FeedTypes)
local MomentItem = require(script.MomentItem)
local MomentItemSkeleton = require(script.MomentItemSkeleton)

require(script.createMomentStore)

local MomentsCommon = require(parent.MomentsCommon)
local MomentsTypes = require(parent.MomentsTypes)
local SharedFlags = require(parent.SharedFlags)
local FFlagMomentsServeEDPVideos = SharedFlags.FFlagMomentsServeEDPVideos
local FFlagMomentsOptimisticProfilePending = SharedFlags.FFlagMomentsOptimisticProfilePending
local FFlagMomentsHideOfficialContentLabel = SharedFlags.FFlagMomentsHideOfficialContentLabel
local FStringMomentsOfficialContentCreatorId = require(Moments.Flags.FStringMomentsOfficialContentCreatorId)

local GetMomentsPreferencesStore = require(Moments.Stores.GetMomentsPreferencesStore)
local GetFFlagMomentsRenderPostAssets = require(parent.MomentsCommon.GetFFlagMomentsRenderPostAssets)
local FFlagMomentsAvatarLookTryOn = SharedFlags.FFlagMomentsAvatarLookTryOn
local makeRecommendationAttribution = require(Moments.Analytics.makeRecommendationAttribution)
local FFlagMomentsRecommendationContentType = require(Moments.Flags.FFlagMomentsRecommendationContentType)
local toMediaItem = require(Moments.Components.Feed.Media.toMediaItem)
local Comments = require(Moments.Components.Comments)

local MomentMediaView = MomentsCommon.Media.MomentMediaView

local v = tonumber(FStringMomentsOfficialContentCreatorId)

local function momentAttribution(moment)
	if moment == nil then
		return nil
	end

	local recommendationMetadata = moment.recommendationMetadata

	if not FFlagMomentsRecommendationContentType then
		moment = nil
	end

	return makeRecommendationAttribution(recommendationMetadata, moment)
end

local function createMediaSurface(moment)
	local v2 = toMediaItem({ kind = "moment", moment = moment })

	if v2 == nil then
		return nil
	end

	return React.createElement(MomentMediaView, {
		momentId = v2.momentId,
		posterContent = v2.posterContent,
		showLoadingSkeleton = v2.captureType == Enum.CaptureType.Video,
		suppressTapToToggle = true,
		getScaleType = GetMomentsPreferencesStore(false).getMediaScaleType
	})
end

return {
	{
		kind = "moment",
		getKey = function(p)
			local moment = p.moment
			local recommendationMetadata = moment.recommendationMetadata

			if
				recommendationMetadata
				and recommendationMetadata.feedItemId
				and recommendationMetadata.feedItemId ~= ""
			then
				return recommendationMetadata.feedItemId
			end

			return moment.momentId
		end,
		getAttribution = function(p)
			return momentAttribution(p.moment)
		end,
		render = function(p, _: number)
			local moment = p.moment

			if moment == nil then
				return nil
			end

			local mediaSurface = nil

			if not GetFFlagMomentsRenderPostAssets() then
				local v2 = toMediaItem(p)

				if v2 ~= nil then
					mediaSurface = React.createElement(MomentMediaView, {
						momentId = v2.momentId,
						posterContent = v2.posterContent,
						showLoadingSkeleton = v2.captureType == Enum.CaptureType.Video,
						suppressTapToToggle = true,
						getScaleType = GetMomentsPreferencesStore(false).getMediaScaleType
					})
				end
			end

			local recommendationMetadata = moment.recommendationMetadata
			local v2

			if moment ~= nil then
				local recommendationMetadata2 = moment.recommendationMetadata
				local v3

				if FFlagMomentsRecommendationContentType then
					v3 = moment
				end

				v2 = makeRecommendationAttribution(recommendationMetadata2, v3)
			end

			local isSponsored = moment.metadata.partnerUploadType == "influencer"
			local v3 = {
				kind = "experience",
				momentId = moment.momentId,
				creatorId = moment.creatorId,
				placeId = moment.metadata.placeId or 0,
				universeId = moment.metadata.universeId or 0,
				outfitId = 0,
				isSponsored = 0,
				isOfficialContent = 0,
				description = 0,
				isModerated = 0,
				isPending = 0,
				commentCount = 0,
				feedItemId = 0,
				feedSessionId = 0,
				contentType = 0
			}
			local outfitId

			if FFlagMomentsAvatarLookTryOn then
				outfitId = moment.metadata.outfitId
			end

			v3.outfitId = outfitId
			v3.isSponsored = isSponsored
			local isOfficialContent

			if FFlagMomentsHideOfficialContentLabel then
				if v == nil then
					isOfficialContent = false
				else
					isOfficialContent = moment.creatorId == v
				end
			end

			v3.isOfficialContent = isOfficialContent

			v3.description = moment.metadata.description
			v3.isModerated = moment.isModerated == true
			v3.isPending = FFlagMomentsOptimisticProfilePending
				and moment.status == MomentsTypes.Enums.MomentStatus.Pending
			local commentCount

			if SharedFlags.FFlagMomentsComments then
				commentCount = Comments.getSeededCommentCount(moment.comments)
			end

			v3.commentCount = commentCount
			local feedItemId

			if recommendationMetadata ~= nil then
				feedItemId = recommendationMetadata.feedItemId
			end

			v3.feedItemId = feedItemId
			local feedSessionId

			if recommendationMetadata ~= nil then
				feedSessionId = recommendationMetadata.tracingId
			end

			v3.feedSessionId = feedSessionId
			local contentType

			if FFlagMomentsRecommendationContentType and v2 ~= nil then
				contentType = v2.contentType
			end

			v3.contentType = contentType

			local createElement = React.createElement
			local renderMediaSurface

			if GetFFlagMomentsRenderPostAssets() then
				renderMediaSurface = createMediaSurface
			end

			local element = createElement(MomentItem, {
				data = v3,
				mediaSurface = mediaSurface,
				renderMediaSurface = renderMediaSurface,
				moment = moment
			})

			if not FFlagMomentsServeEDPVideos or moment.entityType ~= "edpVideo" then
				return element
			end

			local EdpVideoEligibilityContainer = require(script.EdpVideoEligibility.EdpVideoEligibilityContainer)
			return React.createElement(EdpVideoEligibilityContainer, {
				momentId = moment.momentId,
				universeId = moment.metadata.universeId,
				content = element,
				loadingContent = React.createElement(MomentItemSkeleton)
			})
		end
	},
	{
		kind = "skeleton",
		getKey = function(_): string
			return "__feed_skeleton__"
		end,
		getAttribution = function(_): nil
			return nil
		end,
		render = function(_, _: number)
			return React.createElement(MomentItemSkeleton)
		end
	}
}
