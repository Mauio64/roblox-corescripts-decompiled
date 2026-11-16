local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local MomentsCommon = require(parent.MomentsCommon)
local SharedFlags = require(parent.SharedFlags)
local MomentsGetMomentsCommentsStore = require(parent.DataHydration.MomentsGetMomentsCommentsStore)
local FFlagMomentsComments = SharedFlags.FFlagMomentsComments
local FFlagMomentsCommentsIxpEnabled = SharedFlags.FFlagMomentsCommentsIxpEnabled

local VerticalPager = require(Moments.Components.VerticalPager)
local useVerticalPager = VerticalPager.useVerticalPager
local VerticalPager2 = require(Moments.Components.VerticalPager)
local usePagerItem = VerticalPager2.usePagerItem
local FeedContext = require(Moments.Components.Feed.FeedContext)
local useFeedOptional = FeedContext.useFeedOptional
local FStringMomentsCommentsIxpLayer = require(Moments.Flags.FStringMomentsCommentsIxpLayer)
local FFlagMomentsCommentsCountAnalytics = require(Moments.Flags.FFlagMomentsCommentsCountAnalytics)
local makeCommentCountFields = require(Moments.Analytics.makeCommentCountFields)
local MomentImpressionMemory = require(Moments.Components.Feed.Items.Moment.MomentImpressionMemory)
local FFlagMomentsFixOverlayRemountImpressions = require(Moments.Flags.FFlagMomentsFixOverlayRemountImpressions)

local function useCommentActionImpression(flag: boolean)
	local v = useVerticalPager()
	local v2 = usePagerItem()
	local v3 = useFeedOptional()
	local item = v2.item

	local v4 = React.useMemo(function()
		return Signals.createComputed(function(p): boolean
			return item ~= nil and v.store.getCurrentItem(p) == item
		end)
	end, { v, item })
	local current2 = SignalsReact.useSignalState(v4)

	if flag then
		if current2 then
			current2 = not (v3 == nil) and v3.isActiveFeed
		end
	else
		current2 = flag
	end

	local v5

	if FFlagMomentsFixOverlayRemountImpressions then
		v5 = MomentImpressionMemory.useImpressionRef("commentAction")
	else
		v5 = React.useRef(false)
	end

	React.useEffect(function()
		local current = v5.current
		v5.current = current2

		if not current2 or current or item == nil or item.kind ~= "moment" then
			return
		end

		local recommendationMetadata = item.moment.recommendationMetadata
		local feedItemId

		if recommendationMetadata ~= nil then
			feedItemId = recommendationMetadata.feedItemId
		end

		if FFlagMomentsComments and feedItemId ~= nil and feedItemId ~= "" then
			local v6 = not FFlagMomentsCommentsCountAnalytics and {}
				or makeCommentCountFields(MomentsGetMomentsCommentsStore(false).getCachedMomentComments(feedItemId).data(false))

			v6.feedItemId = feedItemId
			MomentsCommon.Analytics.fireAnalyticsEvent(
				MomentsCommon.Analytics.EventNames.MomentCommentActionButtonImpression,
				v6
			)
		end

		if FFlagMomentsCommentsIxpEnabled then
			MomentsCommon.Utils.logMomentsLayerExposure(FStringMomentsCommentsIxpLayer)
		end
	end, { current2, item })
end

return useCommentActionImpression
