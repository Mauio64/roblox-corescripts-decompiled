local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local React = require(parent.React)
local Localization = require(parent.Localization)
require(parent.MomentsTypes)

local FeedContext = require(Moments.Components.Feed.FeedContext)
local SignalActionType = require(Moments.Enums.SignalActionType)
local MomentContext = require(Moments.Components.Feed.Items.Moment.MomentContext)
local makeRecommendationAttribution = require(Moments.Analytics.makeRecommendationAttribution)
local FFlagMomentsRecommendationContentType = require(Moments.Flags.FFlagMomentsRecommendationContentType)

local shareMoment = require(script.Parent.shareMoment)

local useLocalization = Localization.Hooks.useLocalization

local v = {
	shareLinkTitle = "Feature.Moments.Label.ShareLinkTitle",
	linkCopied = "Feature.Moments.Label.LinkCopied",
	linkCopyFailed = "Feature.Moments.Label.LinkCopyFailed"
}

local function useShareMoment(p)
	local v2 = MomentContext.useMoment()
	local momentId = v2.momentId
	local v3 = React.useContext(FeedContext.FeedContext)

	local v4 = useLocalization(v)

	local useCallback = React.useCallback
	local function fn()
		local recommendationMetadata

		if p then
			recommendationMetadata = p.recommendationMetadata
		end

		local v5

		if FFlagMomentsRecommendationContentType then
			v5 = v2.store.getData(false).contentType
		end

		local recommendationAttribution = makeRecommendationAttribution(recommendationMetadata, nil, v5)

		local fn2 = nil

		fn2 = recommendationAttribution and v3 and function(p2)
			return v3.logAction(SignalActionType.Share, recommendationAttribution, p2)
		end or fn2

		local v6 = {
			momentId = momentId,
			feedItemId = 0,
			feedSessionId = 0,
			description = 0,
			logAction = 0,
			strings = 0
		}
		local feedItemId

		if p and p.recommendationMetadata then
			feedItemId = p.recommendationMetadata.feedItemId
		end

		v6.feedItemId = feedItemId
		local feedSessionId

		if p and p.recommendationMetadata then
			feedSessionId = p.recommendationMetadata.tracingId
		end

		v6.feedSessionId = feedSessionId
		local description

		if p and p.metadata then
			description = p.metadata.description
		end

		v6.description = description
		v6.logAction = fn2
		v6.strings = {
			linkPreviewTitle = v4.shareLinkTitle,
			linkCopied = v4.linkCopied,
			linkCopyFailed = v4.linkCopyFailed
		}
		shareMoment(v6)
	end

	local v5

	if FFlagMomentsRecommendationContentType then
		v5 = v2.store
	else
		v5 = false
	end

	return {
		onShareActivated = useCallback(fn, { momentId, p, v3, v4, v5 })
	}
end

return useShareMoment
