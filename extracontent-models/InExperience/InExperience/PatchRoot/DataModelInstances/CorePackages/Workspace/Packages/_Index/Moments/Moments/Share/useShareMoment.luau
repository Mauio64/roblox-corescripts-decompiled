local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local React = require(MomentsParent.React)
local Localization = require(MomentsParent.Localization)

require(MomentsParent.MomentsTypes)

local FeedContext = require(Moments.Components.Feed.FeedContext)
local SignalActionType = require(Moments.Enums.SignalActionType)
local MomentContext = require(Moments.Components.Feed.Items.Moment.MomentContext)
local makeRecommendationAttribution = require(Moments.Analytics.makeRecommendationAttribution)
local shareMoment = require(script.Parent.shareMoment)
local useLocalization = Localization.Hooks.useLocalization
local t1 = {
	shareLinkTitle = "Feature.Moments.Label.ShareLinkTitle",
	linkCopied = "Feature.Moments.Label.LinkCopied",
	linkCopyFailed = "Feature.Moments.Label.LinkCopyFailed"
}

local function useShareMoment(p1) -- line: 32
	-- upvalues: MomentContext (copy), React (copy), FeedContext (copy), useLocalization (copy), t1 (copy), makeRecommendationAttribution (copy), SignalActionType (copy), shareMoment (copy)
	local momentId = MomentContext.useMoment().momentId
	local v15 = React.useContext(FeedContext.FeedContext)
	local v16 = useLocalization(t1)

	return {
		onShareActivated = React.useCallback(function() -- line: 40
			-- upvalues: makeRecommendationAttribution (copy), p1 (copy), v15 (copy), SignalActionType (copy), shareMoment (copy), momentId (copy), v16 (copy)
			local v17 = makeRecommendationAttribution(if not p1 then nil else p1.recommendationMetadata)
			local v18 = nil

			if v17 and v15 then
				function v18(t2: {[any]: any}) -- line: 49
					-- upvalues: v15 (copy), SignalActionType (copy), v17 (copy)
					return v15.logAction(SignalActionType.Share, v17, t2)
				end
			end

			shareMoment({
				momentId = momentId,
				feedItemId = if not p1 or not p1.recommendationMetadata then nil else p1.recommendationMetadata.feedItemId,
				feedSessionId = if not p1 or not p1.recommendationMetadata then nil else p1.recommendationMetadata.tracingId,
				description = if not p1 or not p1.metadata then nil else p1.metadata.description,
				logAction = v18,
				strings = {
					linkPreviewTitle = v16.shareLinkTitle,
					linkCopied = v16.linkCopied,
					linkCopyFailed = v16.linkCopyFailed
				}
			})
		end, {
			momentId,
			p1,
			v15,
			v16
		})
	}
end

return useShareMoment
