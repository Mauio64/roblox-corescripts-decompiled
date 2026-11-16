local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
require(parent.MomentsTypes)
local MomentsCommon = require(parent.MomentsCommon)
local MomentsGetMomentsCommentsStore = require(parent.DataHydration.MomentsGetMomentsCommentsStore)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags = require(parent.RoactServiceTags)
local AppAppLifecycleObserverService = RoactServiceTags.AppAppLifecycleObserverService

local FeedContext = require(Moments.Components.Feed.FeedContext)
local useFeedOptional = FeedContext.useFeedOptional
local makeRecommendationAttribution = require(Moments.Analytics.makeRecommendationAttribution)
local makeCommentCountFields = require(Moments.Analytics.makeCommentCountFields)
require(Moments.Analytics.RecommendationContentType)
local FFlagMomentsCommentsCountAnalytics = require(Moments.Flags.FFlagMomentsCommentsCountAnalytics)
local FFlagMomentsRecommendationContentType = require(Moments.Flags.FFlagMomentsRecommendationContentType)
local getCommentsSheetStore = require(script.Parent.Sheet.getCommentsSheetStore)
local createCommentsRecommendationSession = require(script.Parent.createCommentsRecommendationSession)
local createCommentsAnalyticsSession = require(script.Parent.createCommentsAnalyticsSession)
local useCommentCapabilities = require(script.Parent.useCommentCapabilities)
require(script.Parent.Sheet.createCommentsSheetStore)
local SharedFlags = require(parent.SharedFlags)
local FFlagMomentsCommentDeepLinks = SharedFlags.FFlagMomentsCommentDeepLinks
local GetDeepLinkStore

if FFlagMomentsCommentDeepLinks then
	GetDeepLinkStore = require(Moments.Stores.GetDeepLinkStore)
else
	GetDeepLinkStore = nil
end

local function useCommentsEvents(p, callback, p2)
	local v = useFeedOptional()
	local v2 = useRoactService(AppAppLifecycleObserverService)
	local commentsSheetStore = getCommentsSheetStore(false)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local v3

	if v == nil then
		v3 = false
	else
		v3 = v.isActiveFeed and v.isPlaybackActive
	end

	local v4 = React.useMemo(function()
		local signal, set = Signals.createSignal(true)
		return { get = signal, set = set }
	end, {})

	React.useEffect(function()
		if v2 == nil then
			return
		end

		local onHideConnection = v2.OnHide:Connect(function()
			v4.set(false)
		end)
		local onUnhideConnection = v2.OnUnhide:Connect(function()
			v4.set(true)
		end)
		return function()
			onHideConnection:Disconnect()
			onUnhideConnection:Disconnect()
		end
	end, { v2, v4 })

	React.useEffect(function()
		return Signals.createEffect(function(p3)
			local v5 = v4.get(p3)
			local isOpen = commentsSheetStore.getIsOpen(p3)
			local openSessionId = commentsSheetStore.getOpenSessionId(p3)
			local v6 = commentsSheetStore.getFeedItemId(false) or ""
			local current = ref.current
			local current2 = ref2.current
			local v7 = v3 and v5 and isOpen

			if current ~= nil then
				if v7 and commentsSheetStore.getRecommendationSession(v6, openSessionId) == current then
					current.startView()
				else
					current.finishView()
				end
			end

			if current2 ~= nil then
				if v7 and commentsSheetStore.getAnalyticsSession(v6, openSessionId) == current2 then
					current2.startView()
				elseif v5 then
					if not v3 then
						current2.finishView("navigation_hidden")
					end
				else
					current2.finishView("app_hidden")
				end
			end
		end)
	end, { v3, commentsSheetStore, v4 })

	React.useEffect(function()
		return function()
			if ref.current ~= nil then
				ref.current.finishView()
			end

			if ref2.current ~= nil then
				ref2.current.finishView("unmounted")
			end
		end
	end, {})

	local canRead = useCommentCapabilities().canRead

	local useCallback = React.useCallback
	local function fn(p3)
		local feedItemId

		if p == nil then
			feedItemId = nil
		else
			feedItemId = p.feedItemId
		end

		if feedItemId == nil or feedItemId == "" or not canRead then
			return
		end

		local current = nil
		local v5

		if FFlagMomentsRecommendationContentType then
			v5 = p2
		end

		local recommendationAttribution = makeRecommendationAttribution(p, nil, v5)

		if v ~= nil and recommendationAttribution ~= nil then
			current = createCommentsRecommendationSession(v.logAction, recommendationAttribution, callback(false))
		end

		local momentsGetMomentsCommentsStore = MomentsGetMomentsCommentsStore(false)
		local ownerGeneration = momentsGetMomentsCommentsStore.getOwnerGeneration(false)
		local v6

		if v == nil then
			v6 = false
		else
			v6 = v.recommendationSource == MomentsCommon.Analytics.RecommendationSource.Profile
				or v.recommendationSource == MomentsCommon.Analytics.RecommendationSource.MyMoments
		end

		local fn2 = FFlagMomentsCommentsCountAnalytics and function()
			return makeCommentCountFields(momentsGetMomentsCommentsStore.getCachedMomentComments(feedItemId).data(false))
		end or nil

		local commentsAnalyticsSession = createCommentsAnalyticsSession(
			feedItemId,
			v6 and "profile" or "watch_tab",
			function(): boolean
				return momentsGetMomentsCommentsStore.getOwnerGeneration(false) == ownerGeneration
			end,
			nil,
			nil,
			nil,
			fn2
		)

		ref.current = current
		ref2.current = commentsAnalyticsSession
		local open = commentsSheetStore.open

		if not FFlagMomentsCommentDeepLinks then
			p3 = nil
		end

		open(feedItemId, current, commentsAnalyticsSession, p3)
	end

	local v5

	if FFlagMomentsRecommendationContentType then
		v5 = p2 or false
	else
		v5 = false
	end

	local v6 = useCallback(fn, {
		p or false,
		v or false,
		commentsSheetStore,
		callback,
		v5,
		canRead
	})

	if not FFlagMomentsCommentDeepLinks or GetDeepLinkStore == nil then
		return v6
	end

	local feedItemId

	if p == nil then
		feedItemId = nil
	else
		feedItemId = p.feedItemId
	end

	local getCurrentItem

	if v == nil then
		getCurrentItem = nil
	else
		getCurrentItem = v.getCurrentItem
	end

	React.useEffect(function()
		if not v3 or not canRead or getCurrentItem == nil or feedItemId == nil or feedItemId == "" then
			return
		end

		local deepLinkStore = GetDeepLinkStore()
		return Signals.createEffect(function(p3)
			local pendingCommentsTarget = deepLinkStore.getPendingCommentsTarget(p3)

			if pendingCommentsTarget == nil or pendingCommentsTarget.feedItemId ~= feedItemId then
				return
			end

			local currentItem = getCurrentItem(p3)
			local feedItemId2 = nil

			if currentItem == nil or currentItem.kind ~= "moment" then
				if currentItem ~= nil and currentItem.kind == "avatarMoment" then
					feedItemId2 = currentItem.moment.recommendationMetadata.feedItemId
				end
			else
				feedItemId2 = currentItem.moment.recommendationMetadata.feedItemId
			end

			if feedItemId2 ~= feedItemId then
				return
			end

			local v7 = deepLinkStore.takeCommentsTarget(feedItemId)

			if v7 ~= nil then
				v6(v7)
			end
		end)
	end, {
		v3,
		canRead,
		getCurrentItem or false,
		feedItemId or false,
		v6
	})

	return React.useCallback(function()
		v6(nil)
	end, { v6 })
end

return useCommentsEvents
