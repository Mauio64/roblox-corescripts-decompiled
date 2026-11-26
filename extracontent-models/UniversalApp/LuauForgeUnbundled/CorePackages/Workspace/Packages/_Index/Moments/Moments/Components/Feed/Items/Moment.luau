local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedTypes")
local MomentItem = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/MomentItem")
local MomentItemSkeleton = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/MomentItemSkeleton")

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/createMomentStore")

local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local MomentsTypes = require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags")
local fFlagMomentsServeEDPVideos = SharedFlags.FFlagMomentsServeEDPVideos
local fFlagMomentsOptimisticProfilePending = SharedFlags.FFlagMomentsOptimisticProfilePending
local fFlagMomentsHideOfficialContentLabel = SharedFlags.FFlagMomentsHideOfficialContentLabel
local FStringMomentsOfficialContentCreatorId = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FStringMomentsOfficialContentCreatorId")

local GetMomentsPreferencesStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsPreferencesStore")
local GetFFlagMomentsRenderPostAssets = require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsCommon/GetFFlagMomentsRenderPostAssets")
local fFlagMomentsAvatarLookTryOn = SharedFlags.FFlagMomentsAvatarLookTryOn
local makeRecommendationAttribution = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Analytics/makeRecommendationAttribution")
local FFlagMomentsRecommendationContentType = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsRecommendationContentType")
local toMediaItem = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Media/toMediaItem")
local Comments = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments")

local momentMediaView = MomentsCommon.Media.MomentMediaView

local v5 = tonumber(FStringMomentsOfficialContentCreatorId)

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

local function createMediaSurface(p2)
	local v6 = toMediaItem({ kind = "moment", moment = p2 })

	if v6 == nil then
		return nil
	end

	return React.createElement(momentMediaView, {
		momentId = v6.momentId,
		posterContent = v6.posterContent,
		showLoadingSkeleton = v6.captureType == Enum.CaptureType.Video,
		suppressTapToToggle = true,
		getScaleType = GetMomentsPreferencesStore(false).getMediaScaleType
	})
end

return {
	{
		kind = "moment",
		getKey = function(p2)
			local moment = p2.moment
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
		getAttribution = function(p2)
			return momentAttribution(p2.moment)
		end,
		render = function(p2, p3)
			local moment = p2.moment

			if moment == nil then
				return nil
			end

			local v6 = nil

			if not GetFFlagMomentsRenderPostAssets() then
				local v7 = toMediaItem(p2)

				if v7 ~= nil then
					v6 = React.createElement(momentMediaView, {
						momentId = v7.momentId,
						posterContent = v7.posterContent,
						showLoadingSkeleton = v7.captureType == Enum.CaptureType.Video,
						suppressTapToToggle = true,
						getScaleType = GetMomentsPreferencesStore(false).getMediaScaleType
					})
				end
			end

			local recommendationMetadata = moment.recommendationMetadata
			local v7

			if moment ~= nil then
				local recommendationMetadata2 = moment.recommendationMetadata
				local v9 = if FFlagMomentsRecommendationContentType then moment else nil
				v7 = makeRecommendationAttribution(recommendationMetadata2, v9)
			end

			local v8 = moment.metadata.partnerUploadType == "influencer"
			local v9 = {
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
			local v10 = if fFlagMomentsAvatarLookTryOn then moment.metadata.outfitId else nil
			v9.outfitId = v10
			v9.isSponsored = v8
			local v11

			if fFlagMomentsHideOfficialContentLabel then
				v11 = not (v5 == nil) and moment.creatorId == v5
			end

			v9.isOfficialContent = v11

			v9.description = moment.metadata.description
			v9.isModerated = moment.isModerated == true
			v9.isPending = fFlagMomentsOptimisticProfilePending
				and moment.status == MomentsTypes.Enums.MomentStatus.Pending
			local v12 = if SharedFlags.FFlagMomentsComments then Comments.getSeededCommentCount(moment.comments) else nil
			v9.commentCount = v12

			local v13 = if recommendationMetadata ~= nil then recommendationMetadata.feedItemId else nil
			v9.feedItemId = v13
			local v14 = if recommendationMetadata ~= nil then recommendationMetadata.tracingId else nil
			v9.feedSessionId = v14

			local v15 = if FFlagMomentsRecommendationContentType and v7 ~= nil then v7.contentType else nil
			v9.contentType = v15

			local createElement = React.createElement

			local v18 = if GetFFlagMomentsRenderPostAssets() then createMediaSurface else nil
			local element = createElement(MomentItem, {
				data = v9,
				mediaSurface = v6,
				renderMediaSurface = v18,
				moment = moment
			})

			if not fFlagMomentsServeEDPVideos or moment.entityType ~= "edpVideo" then
				return element
			end

			local EdpVideoEligibilityContainer = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/EdpVideoEligibility/EdpVideoEligibilityContainer")
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
		getKey = function(p2): string
			return "__feed_skeleton__"
		end,
		getAttribution = function(p2): nil
			return nil
		end,
		render = function(p2, p3)
			return React.createElement(MomentItemSkeleton)
		end
	}
}
