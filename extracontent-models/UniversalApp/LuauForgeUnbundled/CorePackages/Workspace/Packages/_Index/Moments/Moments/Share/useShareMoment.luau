local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")

local FeedContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedContext")
local SignalActionType = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Enums/SignalActionType")
local MomentContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/MomentContext")
local makeRecommendationAttribution = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Analytics/makeRecommendationAttribution")
local FFlagMomentsRecommendationContentType = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsRecommendationContentType")

local shareMoment = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Share/shareMoment")

local useLocalization = Localization.Hooks.useLocalization

local v5 = {
	shareLinkTitle = "Feature.Moments.Label.ShareLinkTitle",
	linkCopied = "Feature.Moments.Label.LinkCopied",
	linkCopyFailed = "Feature.Moments.Label.LinkCopyFailed"
}

local function useShareMoment(p2)
	local v6 = MomentContext.useMoment()
	local momentId = v6.momentId
	local v7 = React.useContext(FeedContext.FeedContext)

	local v8 = useLocalization(v5)

	local useCallback = React.useCallback
	local function fn()
		local recommendationMetadata = if p2 then p2.recommendationMetadata else nil

		local v11 = if FFlagMomentsRecommendationContentType then v6.store.getData(false).contentType else nil
		local v12 = makeRecommendationAttribution(recommendationMetadata, nil, v11)

		local fn2 = nil

		fn2 = v12 and v7 and function(p3)
			return v7.logAction(SignalActionType.Share, v12, p3)
		end or fn2

		local v14 = {
			momentId = momentId,
			feedItemId = 0,
			feedSessionId = 0,
			description = 0,
			logAction = 0,
			strings = 0
		}

		local v15 = if p2 and p2.recommendationMetadata then p2.recommendationMetadata.feedItemId else nil
		v14.feedItemId = v15

		local v16 = if p2 and p2.recommendationMetadata then p2.recommendationMetadata.tracingId else nil
		v14.feedSessionId = v16

		local v17 = if p2 and p2.metadata then p2.metadata.description else nil
		v14.description = v17
		v14.logAction = fn2
		v14.strings = {
			linkPreviewTitle = v8.shareLinkTitle,
			linkCopied = v8.linkCopied,
			linkCopyFailed = v8.linkCopyFailed
		}
		shareMoment(v14)
	end

	local v10 = if FFlagMomentsRecommendationContentType then v6.store else false
	return {
		onShareActivated = useCallback(fn, { momentId, p2, v7, v8, v10 })
	}
end

return useShareMoment
