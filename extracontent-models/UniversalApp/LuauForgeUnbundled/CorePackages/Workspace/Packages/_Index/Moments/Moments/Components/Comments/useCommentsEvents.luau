local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local MomentsGetMomentsCommentsStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsGetMomentsCommentsStore")
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/RobloxAppHooks").useRoactService
local appAppLifecycleObserverService = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/RoactServiceTags").AppAppLifecycleObserverService

local useFeedOptional = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedContext").useFeedOptional
local makeRecommendationAttribution = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Analytics/makeRecommendationAttribution")
local makeCommentCountFields = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Analytics/makeCommentCountFields")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Analytics/RecommendationContentType")
local FFlagMomentsCommentsCountAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsCommentsCountAnalytics")
local FFlagMomentsRecommendationContentType = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsRecommendationContentType")
local getCommentsSheetStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/Sheet/getCommentsSheetStore")
local createCommentsRecommendationSession = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/createCommentsRecommendationSession")
local createCommentsAnalyticsSession = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/createCommentsAnalyticsSession")
local useCommentCapabilities = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/useCommentCapabilities")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/Sheet/createCommentsSheetStore")
local fFlagMomentsCommentDeepLinks = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags").FFlagMomentsCommentDeepLinks
local v5 = if fFlagMomentsCommentDeepLinks then require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetDeepLinkStore") else nil

local function useCommentsEvents(p2, callback, p3)
	local v6 = useFeedOptional()
	local v7 = useRoactService(appAppLifecycleObserverService)
	local v8 = getCommentsSheetStore(false)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local v9 = not (v6 == nil) and (v6.isActiveFeed and v6.isPlaybackActive)
	local v10 = React.useMemo(function()
		local signal, v11 = Signals.createSignal(true)
		return { get = signal, set = v11 }
	end, {})

	React.useEffect(function()
		if v7 == nil then
			return
		end

		local onHideConnection = v7.OnHide:Connect(function()
			v10.set(false)
		end)
		local onUnhideConnection = v7.OnUnhide:Connect(function()
			v10.set(true)
		end)
		return function()
			onHideConnection:Disconnect()
			onUnhideConnection:Disconnect()
		end
	end, { v7, v10 })

	React.useEffect(function()
		return Signals.createEffect(function(p4)
			local v11 = v10.get(p4)
			local isOpen = v8.getIsOpen(p4)
			local openSessionId = v8.getOpenSessionId(p4)
			local v12 = v8.getFeedItemId(false) or ""
			local current = ref.current
			local current2 = ref2.current
			local v13 = v9 and v11 and isOpen

			if current ~= nil then
				if v13 and v8.getRecommendationSession(v12, openSessionId) == current then
					current.startView()
				else
					current.finishView()
				end
			end

			if current2 ~= nil then
				if v13 and v8.getAnalyticsSession(v12, openSessionId) == current2 then
					current2.startView()
				elseif v11 then
					if not v9 then
						current2.finishView("navigation_hidden")
					end
				else
					current2.finishView("app_hidden")
				end
			end
		end)
	end, { v9, v8, v10 })

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

	local function fn(p4)
		local feedItemId = if p2 ~= nil then p2.feedItemId else nil

		if feedItemId == nil or feedItemId == "" or not canRead then
			return
		end

		local v11 = nil
		local v15 = if FFlagMomentsRecommendationContentType then p3 else nil
		local v16 = makeRecommendationAttribution(p2, nil, v15)

		if v6 ~= nil and v16 ~= nil then
			v11 = createCommentsRecommendationSession(v6.logAction, v16, callback(false))
		end

		local v17 = MomentsGetMomentsCommentsStore(false)
		local ownerGeneration = v17.getOwnerGeneration(false)
		local v18

		if v6 == nil then
			v18 = false
		else
			v18 = v6.recommendationSource == MomentsCommon.Analytics.RecommendationSource.Profile
				or v6.recommendationSource == MomentsCommon.Analytics.RecommendationSource.MyMoments
		end

		local fn2 = FFlagMomentsCommentsCountAnalytics and function()
			return makeCommentCountFields(v17.getCachedMomentComments(feedItemId).data(false))
		end or nil

		local v19 = createCommentsAnalyticsSession(feedItemId, v18 and "profile" or "watch_tab", function(): boolean
			return v17.getOwnerGeneration(false) == ownerGeneration
		end, nil, nil, nil, fn2)

		ref.current = v11
		ref2.current = v19
		local open = v8.open

		if not fFlagMomentsCommentDeepLinks then
			p4 = nil
		end

		open(feedItemId, v11, v19, p4)
	end

	local v14 = if FFlagMomentsRecommendationContentType then p3 or false else false
	local v15 = React.useCallback(fn, {
		p2 or false,
		v6 or false,
		v8,
		callback,
		v14,
		canRead
	})

	if not fFlagMomentsCommentDeepLinks or v5 == nil then
		return v15
	end

	local feedItemId = if p2 ~= nil then p2.feedItemId else nil
	local getCurrentItem = if v6 ~= nil then v6.getCurrentItem else nil

	React.useEffect(function()
		if not v9 or not canRead or getCurrentItem == nil or feedItemId == nil or feedItemId == "" then
			return
		end

		local v16 = v5()
		return Signals.createEffect(function(p4)
			local pendingCommentsTarget = v16.getPendingCommentsTarget(p4)

			if pendingCommentsTarget == nil or pendingCommentsTarget.feedItemId ~= feedItemId then
				return
			end

			local currentItem = getCurrentItem(p4)
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

			local v17 = v16.takeCommentsTarget(feedItemId)

			if v17 ~= nil then
				v15(v17)
			end
		end)
	end, {
		v9,
		canRead,
		getCurrentItem or false,
		feedItemId or false,
		v15
	})

	return React.useCallback(function()
		v15(nil)
	end, { v15 })
end

return useCommentsEvents
