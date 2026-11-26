local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags")
local MomentsGetMomentsCommentsStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsGetMomentsCommentsStore")
local fFlagMomentsComments = SharedFlags.FFlagMomentsComments
local fFlagMomentsCommentsIxpEnabled = SharedFlags.FFlagMomentsCommentsIxpEnabled

local useVerticalPager = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/VerticalPager").useVerticalPager
local usePagerItem = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/VerticalPager").usePagerItem
local useFeedOptional = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedContext").useFeedOptional
local FStringMomentsCommentsIxpLayer = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FStringMomentsCommentsIxpLayer")
local FFlagMomentsCommentsCountAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsCommentsCountAnalytics")
local makeCommentCountFields = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Analytics/makeCommentCountFields")
local MomentImpressionMemory = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/MomentImpressionMemory")
local FFlagMomentsFixOverlayRemountImpressions = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsFixOverlayRemountImpressions")

local function useCommentActionImpression(p2)
	local v5 = useVerticalPager()
	local v6 = usePagerItem()
	local v7 = useFeedOptional()
	local item = v6.item

	local v8 = React.useMemo(function()
		return Signals.createComputed(function(p3): boolean
			return item ~= nil and v5.store.getCurrentItem(p3) == item
		end)
	end, { v5, item })
	local v9 = SignalsReact.useSignalState(v8)

	if p2 then
		if v9 then
			v9 = not (v7 == nil) and v7.isActiveFeed
		end
	else
		v9 = p2
	end

	local v10 = if FFlagMomentsFixOverlayRemountImpressions then MomentImpressionMemory.useImpressionRef("commentAction") else React.useRef(false)

	React.useEffect(function()
		local current = v10.current
		v10.current = v9

		if not v9 or current or item == nil or item.kind ~= "moment" then
			return
		end

		local recommendationMetadata = item.moment.recommendationMetadata
		local feedItemId = if recommendationMetadata ~= nil then recommendationMetadata.feedItemId else nil

		if fFlagMomentsComments and feedItemId ~= nil and feedItemId ~= "" then
			local v11 = not FFlagMomentsCommentsCountAnalytics and {}
				or makeCommentCountFields(MomentsGetMomentsCommentsStore(false).getCachedMomentComments(feedItemId).data(false))

			v11.feedItemId = feedItemId
			MomentsCommon.Analytics.fireAnalyticsEvent(
				MomentsCommon.Analytics.EventNames.MomentCommentActionButtonImpression,
				v11
			)
		end

		if fFlagMomentsCommentsIxpEnabled then
			MomentsCommon.Utils.logMomentsLayerExposure(FStringMomentsCommentsIxpLayer)
		end
	end, { v9, item })
end

return useCommentActionImpression
