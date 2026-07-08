local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local React = require(MomentsParent.React)
local Localization = require(MomentsParent.Localization)

require(MomentsParent.MomentsTypes)

local FeedContext = require(Moments.Components.Feed.FeedContext)
local SignalActionType = require(Moments.Enums.SignalActionType)
local MomentContext = require(Moments.Components.Feed.Items.Moment.MomentContext)
local shareMoment = require(script.Parent.shareMoment)
local useLocalization = Localization.Hooks.useLocalization
local t1 = {
	shareLinkTitle = "Feature.Moments.Label.ShareLinkTitle",
	linkCopied = "Feature.Moments.Label.LinkCopied",
	linkCopyFailed = "Feature.Moments.Label.LinkCopyFailed"
}

local function useShareMoment(p1) -- line: 31
	-- upvalues: MomentContext (copy), React (copy), FeedContext (copy), useLocalization (copy), t1 (copy), SignalActionType (copy), shareMoment (copy)
	local momentId = MomentContext.useMoment().momentId
	local v14 = React.useContext(FeedContext.FeedContext)
	local v15 = useLocalization(t1)

	return {
		onShareActivated = React.useCallback(function() -- line: 39
			-- upvalues: p1 (copy), v14 (copy), SignalActionType (copy), shareMoment (copy), momentId (copy), v15 (copy)
			local t2 = nil

			if p1 and p1.recommendationMetadata then
				local recommendationMetadata = p1.recommendationMetadata

				if recommendationMetadata.itemId and recommendationMetadata.itemId ~= "" then
					t2 = {
						itemId = recommendationMetadata.itemId,
						tracingId = recommendationMetadata.tracingId
					}
				end
			end

			local v18 = nil

			if t2 and v14 then
				function v18(t3: {[any]: any}) -- line: 53
					-- upvalues: v14 (copy), SignalActionType (copy), t2 (ref)
					return v14.logAction(SignalActionType.Share, t2, t3)
				end
			end

			shareMoment({
				momentId = momentId,
				description = if not p1 or not p1.metadata then nil else p1.metadata.description,
				logAction = v18,
				strings = {
					linkPreviewTitle = v15.shareLinkTitle,
					linkCopied = v15.linkCopied,
					linkCopyFailed = v15.linkCopyFailed
				}
			})
		end, {
			momentId,
			p1,
			v14,
			v15
		})
	}
end

return useShareMoment
