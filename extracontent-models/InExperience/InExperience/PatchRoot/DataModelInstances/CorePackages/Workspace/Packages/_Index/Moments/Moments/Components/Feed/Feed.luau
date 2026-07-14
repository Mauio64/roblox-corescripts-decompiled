local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local Localization = require(MomentsParent.Localization)
local MomentsCommon = require(MomentsParent.MomentsCommon)

require(MomentsParent.MomentsTypes)

local React = require(MomentsParent.React)
local SharedFlags = require(MomentsParent.SharedFlags)
local SignalsReact = require(MomentsParent.SignalsReact)
local useLocalization = Localization.Hooks.useLocalization
local Analytics = MomentsCommon.Analytics
local EventNames = Analytics.EventNames
local fireAnalyticsEvent = Analytics.fireAnalyticsEvent
local MomentsSurfaceLoadManager = MomentsCommon.Performance.MomentsSurfaceLoadManager
local FFlagMomentsSurfaceLoadTTI = SharedFlags.FFlagMomentsSurfaceLoadTTI
local FFlagMomentsRemoveDeletedFromProfile = SharedFlags.FFlagMomentsRemoveDeletedFromProfile
local VerticalPager = require(Moments.Components.VerticalPager)

require(script.Parent.FeedTypes)

local FeedContext = require(script.Parent.FeedContext)
local FeedStateView = require(script.Parent.FeedStateView)
local createFeedStore = require(script.Parent.createFeedStore)
local feedItemRegistry = require(script.Parent.feedItemRegistry)
local feedTelemetry = require(script.Parent.feedTelemetry)
local useFeedTelemetry = require(script.Parent.useFeedTelemetry)
local FeedNavigationBar = require(script.Parent.FeedNavigationBar)
local ImmersiveChromeController = require(script.Parent.ImmersiveChromeController)
local DeletionConfirmationDialog = require(script.Parent.DeletionConfirmationDialog)
local GetImmersiveChromeStore = require(Moments.Stores.GetImmersiveChromeStore)
local GetFFlagMomentsImmersiveChrome = require(Moments.Flags.GetFFlagMomentsImmersiveChrome)
local useMomentsSession = require(Moments.Stores.GetMomentsStore.MomentsSessionContext).useMomentsSession
local GetFFlagMomentsFixDelete = require(Moments.Flags.GetFFlagMomentsFixDelete)
local GetToastStore = require(Moments.Stores.GetToastStore)
local GetDeletedMomentsStore = require(Moments.Stores.GetDeletedMomentsStore)
local deleteMoment = require(Moments.Moderation.deleteMoment)
local makeMomentViewBeganFields = require(Moments.Analytics.makeMomentViewBeganFields)
local makeFeedActionFields = require(Moments.Analytics.makeFeedActionFields)
local MomentMediaCoordinatorProvider = require(script.Parent.Media.MomentMediaCoordinatorProvider)
local SurfaceReadyTracker = require(script.Parent.SurfaceReadyTracker)
local VerticalPager2 = VerticalPager.VerticalPager
local FeedContext2 = FeedContext.FeedContext
local GetFFlagMomentsFilterUnavailableFeedItems = require(Moments.Flags.GetFFlagMomentsFilterUnavailableFeedItems)
local v39 = feedTelemetry.createNoopTelemetry()
local t1 = {
	deletedTitle = "Feature.Moments.Label.MomentDeletedTitle",
	deletedBody = "Feature.Moments.Label.MomentDeletedBody"
}

local function renderFeedItem(p1, n1: number) -- line: 90
	-- upvalues: feedItemRegistry (copy)
	local v51 = feedItemRegistry[p1.kind]

	if v51 ~= nil then
		return (v51.render(p1, n1))
	end

	return nil
end
local function feedItemKey(p2, n2: number) -- line: 95
	-- upvalues: feedItemRegistry (copy)
	local v54 = feedItemRegistry[p2.kind]
	local v55 = if v54 == nil then nil else v54.getKey(p2)

	if v55 ~= nil and v55 ~= "" then
		return v55
	end

	return (tostring(n2))
end
local function feedItemDedupeKey(p3) -- line: 105
	-- upvalues: feedItemRegistry (copy)
	local v57 = feedItemRegistry[p3.kind]

	if v57 ~= nil then
		return (v57.getKey(p3))
	end

	return nil
end
local function feedItemAttribution(p4) -- line: 110
	-- upvalues: feedItemRegistry (copy)
	local v59 = feedItemRegistry[p4.kind]

	if v59 ~= nil then
		return (v59.getAttribution(p4))
	end

	return nil
end
local function stringOrNil(p5) -- line: 115
	if p5 ~= nil then
		return (tostring(p5))
	end

	return nil
end

local u46 = nil

local function getLogger() -- line: 120
	-- upvalues: u46 (ref), MomentsParent (copy)
	if u46 == nil then
		u46 = require(MomentsParent.Loggers).Logger:new("Moments.Feed")
	end

	return u46
end
local function Feed(t2: {[any]: any}) -- line: 175
	-- upvalues: v39 (copy), FFlagMomentsSurfaceLoadTTI (copy), GetImmersiveChromeStore (copy), GetFFlagMomentsImmersiveChrome (copy), useLocalization (copy), t1 (copy), useMomentsSession (copy), GetToastStore (copy), SignalsReact (copy), React (copy), createFeedStore (copy), feedItemDedupeKey (copy), makeMomentViewBeganFields (copy), fireAnalyticsEvent (copy), EventNames (copy), useFeedTelemetry (copy), feedItemAttribution (copy), MomentsSurfaceLoadManager (copy), deleteMoment (copy), u46 (ref), MomentsParent (copy), GetFFlagMomentsFixDelete (copy), FFlagMomentsRemoveDeletedFromProfile (copy), GetDeletedMomentsStore (copy), makeFeedActionFields (copy), MomentsCommon (copy), GetFFlagMomentsFilterUnavailableFeedItems (copy), FeedContext2 (copy), VerticalPager2 (copy), renderFeedItem (copy), feedItemKey (copy), FeedStateView (copy), FeedNavigationBar (copy), ImmersiveChromeController (copy), DeletionConfirmationDialog (copy), MomentMediaCoordinatorProvider (copy), SurfaceReadyTracker (copy)
	local source = t2.source
	local v63 = t2.active == nil or t2.active
	local v64 = if t2.playbackActive == nil then v63 else t2.playbackActive
	local v65 = t2.showNavigationBar == nil or t2.showNavigationBar
	local v66 = t2.telemetry or v39
	local v67 = FFlagMomentsSurfaceLoadTTI and t2.trackSurfaceLoad == true
	local v68 = GetImmersiveChromeStore(false)
	local v69 = GetFFlagMomentsImmersiveChrome()
	local v70 = useLocalization(t1)
	local v71 = useMomentsSession()
	local v72 = GetToastStore(false)
	local v73 = SignalsReact.useSignalState(v71.getPendingDeletion)
	local v74 = React.useMemo(function() -- line: 201
		-- upvalues: createFeedStore (copy), source (copy), feedItemDedupeKey (copy), v67 (copy)
		return createFeedStore(source, feedItemDedupeKey, v67)
	end, { source })

	React.useEffect(function() -- line: 206
		-- upvalues: v74 (copy)
		v74.loadInitial()

		return function() -- line: 208
			-- upvalues: v74 (copy)
			v74.dispose()
		end
	end, { v74 })

	local v75 = React.useRef(nil)
	local v76 = React.useRef(0)
	local v77 = React.useRef(false)
	local v78 = React.useRef(0)
	local v79 = React.useCallback(function() -- line: 219
		-- upvalues: v77 (copy), v76 (copy), v78 (copy), v74 (copy)
		if v77.current or DateTime.now().UnixTimestampMillis < v76.current then
			return
		end

		v77.current = true

		local v102 = v78

		v102.current = v102.current + 1

		local current = v78.current

		v74.refresh()
		task.spawn(function() -- line: 228
			-- upvalues: v77 (copy), current (copy), v78 (copy), v74 (copy), v76 (copy)
			while v77.current and current == v78.current do
				local v134 = v74.getStatus(false)

				if v134 == "Loaded" or v134 == "Empty" then
					v77.current = false
					v76.current = DateTime.now().UnixTimestampMillis + 1000

					return
				end

				if v134 == "Failed" then
					v77.current = false

					return
				end

				task.wait()
			end
		end)
	end, { v74 })
	local v80 = React.useCallback(function(p6) -- line: 245
		-- upvalues: v74 (copy), v75 (copy)
		v74.prependItem({
			kind = "moment",
			moment = p6
		})

		local current = v75.current

		if current ~= nil then
			current.scrollToIndex(1)
		end
	end, { v74 })

	React.useImperativeHandle(t2.controllerRef, function() -- line: 253
		-- upvalues: v80 (copy), v79 (copy)
		return {
			prependMoment = v80,
			refresh = v79
		}
	end, {
		v80,
		v79
	})

	local v81 = React.useCallback(function(p7) -- line: 260
		-- upvalues: makeMomentViewBeganFields (copy), v71 (copy), fireAnalyticsEvent (copy), EventNames (copy)
		if p7.kind ~= "moment" then
			return
		end

		local moment = p7.moment
		local v108 = makeMomentViewBeganFields(moment, v71.getSessionSource(false))

		if v108 then
			fireAnalyticsEvent(EventNames.MomentViewBegan, v108)
		end
	end, { v71 })
	local v82 = useFeedTelemetry(v74.pager, {
		telemetry = v66,
		active = v63,
		getAttribution = feedItemAttribution,
		recommendationSource = source.recommendationSource,
		onItemBecameActive = v81
	})
	local v83 = React.useRef(v64)

	React.useEffect(function() -- line: 290
		-- upvalues: v83 (copy), v64 (copy), v74 (copy), v81 (copy)
		local current = v83.current

		v83.current = v64

		if v64 and not current then
			local v110 = v74.pager.getCurrentItem(false)

			if v110 ~= nil then
				v81(v110)
			end
		end
	end, {
		v64,
		v74,
		v81
	})

	local v84 = React.useCallback(function() -- line: 301
		-- upvalues: v75 (copy)
		local current = v75.current

		if current ~= nil then
			current.next()
		end
	end, {})
	local v85 = React.useCallback(function() -- line: 307
		-- upvalues: v75 (copy)
		local current = v75.current

		if current ~= nil then
			current.previous()
		end
	end, {})
	local v86 = SignalsReact.useSignalState(v74.getStatus)
	local v87 = SignalsReact.useSignalState(v74.getLoadMoreFailed)
	local v88 = React.useRef({})

	React.useEffect(function() -- line: 321
		-- upvalues: v78 (copy), v77 (copy), v76 (copy)
		return function() -- line: 322
			-- upvalues: v78 (copy), v77 (copy), v76 (copy)
			local v135 = v78

			v135.current = v135.current + 1
			v77.current = false
			v76.current = 0
		end
	end, { v74 })

	local v89 = React.useRef(false)
	local v90 = React.useRef(false)

	React.useEffect(function() -- line: 333
		-- upvalues: v89 (copy), v67 (copy), MomentsSurfaceLoadManager (copy), fireAnalyticsEvent (copy), EventNames (copy)
		if not v89.current then
			v89.current = true

			if v67 then
				MomentsSurfaceLoadManager.renderStarted()
				MomentsSurfaceLoadManager.surfaceMounted()
			end

			fireAnalyticsEvent(EventNames.MomentsFirstUIRenderedTimestamp, {
				value = if not v67 or not MomentsSurfaceLoadManager.isSessionActive() then DateTime.now().UnixTimestampMillis else MomentsSurfaceLoadManager.elapsedMs()
			})
		end
	end, {})
	React.useEffect(function() -- line: 351
		-- upvalues: v67 (copy), v90 (copy), v86 (copy), fireAnalyticsEvent (copy), EventNames (copy)
		if v67 then
			return
		end

		if not v90.current and (v86 == "Loaded" or v86 == "LoadingMore") then
			v90.current = true
			fireAnalyticsEvent(EventNames.MomentsFirstContentLoadedTimestamp, {
				value = DateTime.now().UnixTimestampMillis
			})
		end
	end, { v86 })

	local v91 = React.useCallback(function() -- line: 363
		-- upvalues: v74 (copy), v75 (copy)
		local v113 = v74.pager.getCurrentIndex(false)
		local current = v75.current

		if current ~= nil then
			current.removeItem(v113)
		end
	end, { v74 })
	local v92 = React.useCallback(function() -- line: 375
		-- upvalues: v73 (copy), deleteMoment (copy), u46 (ref), MomentsParent (copy), GetFFlagMomentsFixDelete (copy), v91 (copy), FFlagMomentsRemoveDeletedFromProfile (copy), GetDeletedMomentsStore (copy), makeFeedActionFields (copy), MomentsCommon (copy), fireAnalyticsEvent (copy), EventNames (copy), v72 (copy), v70 (copy), v71 (copy)
		if v73 then
			local momentId = v73.momentId
			local feedItemId = v73.feedItemId
			local feedSessionId = v73.feedSessionId

			task.spawn(function() -- line: 384
				-- upvalues: deleteMoment (copy), momentId (copy), u46 (ref), MomentsParent (copy)
				local v136, v137 = deleteMoment(momentId):await()

				if not v136 then
					if u46 == nil then
						u46 = require(MomentsParent.Loggers).Logger:new("Moments.Feed")
					end

					u46:warning("Failed to delete moment {}: {}", momentId, (tostring(v137)))
				end
			end)

			if GetFFlagMomentsFixDelete() then
				v91()

				if FFlagMomentsRemoveDeletedFromProfile then
					GetDeletedMomentsStore(false).markDeleted(momentId)
				end
			end

			local v118 = makeFeedActionFields(momentId, feedItemId, feedSessionId, if not MomentsCommon.Flags.GetFFlagMomentsAnalyticsSchemaIdentity() then nil else "delete")

			if v118 then
				fireAnalyticsEvent(EventNames.MomentItemDeleted, v118)
			end

			v72.triggerToast({
				title = v70.deletedTitle,
				text = v70.deletedBody
			})
		end

		v71.clearPendingDeletion()
	end, {
		v73,
		v71,
		v72,
		v70,
		v91
	})
	local v93 = React.useCallback(function() -- line: 427
		-- upvalues: v71 (copy)
		v71.clearPendingDeletion()
	end, { v71 })
	local v94 = React.useCallback(function(p8, s1: string?) -- line: 431
		-- upvalues: u46 (ref), MomentsParent (copy), fireAnalyticsEvent (copy), EventNames (copy), source (copy)
		local recommendationMetadata = p8.recommendationMetadata

		if u46 == nil then
			u46 = require(MomentsParent.Loggers).Logger:new("Moments.Feed")
		end

		u46:debug("Filtering moment after media load failure | momentId: {}, assetId: {}, captureType: {}, failureReason: {}", p8.momentId, tostring(p8.assetId), p8.metadata.captureType.Name, s1 or "nil")

		local v122 = fireAnalyticsEvent
		local FeedMediaLoadFailed = EventNames.FeedMediaLoadFailed
		local t3 = {
			momentId = p8.momentId,
			assetId = tostring(p8.assetId),
			captureType = p8.metadata.captureType.Name,
			creatorId = tostring(p8.creatorId),
			itemId = if recommendationMetadata == nil then nil else recommendationMetadata.itemId,
			tracingId = if recommendationMetadata == nil then nil else recommendationMetadata.tracingId,
			recommendationSource = source.recommendationSource or "",
			feedSourceId = source.id or ""
		}
		local placeId = p8.metadata.placeId

		t3.placeId = if placeId == nil then nil else tostring(placeId)

		local universeId = p8.metadata.universeId

		t3.universeId = if universeId == nil then nil else tostring(universeId)
		t3.failureReason = s1
		v122(FeedMediaLoadFailed, t3)
	end, { source })
	local v95 = React.useCallback(function(s2: string, s3: string?) -- line: 455
		-- upvalues: v88 (copy), v74 (copy), v94 (copy), v75 (copy)
		if v88.current[s2] then
			return
		end

		for v129, v130 in (v74.pager.getItems(false)) do
			if v130.kind == "moment" and s2 == v130.moment.momentId then
				v88.current[s2] = true
				v94(v130.moment, s3)

				local current = v75.current

				if current ~= nil then
					current.removeItem(v129)

					return
				end

				v74.pager.removeItem(v129)

				return
			end
		end
	end, {
		v74,
		v94
	})
	local v96 = React.useCallback(function(s4: string, s5: string?) -- line: 476
		-- upvalues: GetFFlagMomentsFilterUnavailableFeedItems (copy), v95 (copy)
		if GetFFlagMomentsFilterUnavailableFeedItems() then
			v95(s4, s5)
		end
	end, { v95 })
	local v97 = React.useMemo(function() -- line: 483
		-- upvalues: v74 (copy), v63 (copy), v64 (copy), source (copy), v66 (copy), v82 (copy), v68 (copy), v91 (copy)
		return {
			getStatus = v74.getStatus,
			isActiveFeed = v63,
			isPlaybackActive = v64,
			recommendationSource = source.recommendationSource,
			logAction = function(p9, p10, t4: {[any]: any}) -- line: 489
				-- upvalues: v66 (copy)
				return v66.logAction(p9, p10, t4)
			end,
			flushView = v82.flushView,
			getChromeVisible = v68.getChromeVisible,
			revealChrome = v68.revealChrome,
			removeCurrentItem = v91
		}
	end, {
		v74,
		v63,
		v64,
		source,
		v66,
		v82.flushView,
		v68,
		v91
	})
	local v98 = v86 == "Loaded" or v86 == "LoadingMore"
	local v99 = v65 and v98
	local v100 = v63 and (v86 ~= "Failed" and v86 ~= "Empty")
	local v101 = React.createElement(FeedContext2.Provider, {
		value = v97
	}, {
		Root = React.createElement("Frame", {
			BackgroundTransparency = 1,
			AnchorPoint = t2.AnchorPoint,
			LayoutOrder = t2.LayoutOrder,
			Position = t2.Position,
			Size = t2.Size or UDim2.fromScale(1, 1),
			ZIndex = t2.ZIndex
		}, {
			Pager = React.createElement(VerticalPager2, {
				ZIndex = 1,
				store = v74.pager,
				renderItem = renderFeedItem,
				keyExtractor = feedItemKey,
				onEndReached = v74.loadMore,
				active = v100,
				controllerRef = v75,
				initialIndex = t2.initialIndex,
				tuning = t2.pager,
				Size = UDim2.fromScale(1, 1)
			}),
			StateOverlay = React.createElement(FeedStateView, {
				zIndex = 2,
				status = v86,
				loadMoreFailed = v87,
				onRetry = v74.retry,
				emptyContent = t2.emptyContent
			}),
			NavBar = if not v99 then nil else React.createElement(FeedNavigationBar, {
				zIndex = 3,
				pager = v74.pager,
				active = v63,
				onScrollToNext = v84,
				onScrollToPrevious = v85
			}),
			ImmersiveController = if not v69 then nil else React.createElement(ImmersiveChromeController, {
				pager = v74.pager,
				active = v63 and v64,
				controllerRef = v75
			}),
			DeletionDialog = if v73 == nil then nil else React.createElement(DeletionConfirmationDialog, {
				onCancel = v93,
				onConfirm = v92
			})
		})
	})

	return React.createElement(MomentMediaCoordinatorProvider, {
		pager = v74.pager,
		playbackActive = v64,
		createCoordinator = t2.createCoordinator,
		onMediaItemFailed = if not GetFFlagMomentsFilterUnavailableFeedItems() then nil else v96
	}, if not v67 then v101 else {
		Feed = v101,
		SurfaceReadyTracker = React.createElement(SurfaceReadyTracker, {
			pager = v74.pager
		})
	})
end

return Feed
