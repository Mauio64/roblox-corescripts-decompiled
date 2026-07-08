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
local MomentMediaCoordinatorProvider = require(script.Parent.Media.MomentMediaCoordinatorProvider)
local SurfaceReadyTracker = require(script.Parent.SurfaceReadyTracker)
local VerticalPager2 = VerticalPager.VerticalPager
local FeedContext2 = FeedContext.FeedContext
local GetFFlagMomentsFilterUnavailableFeedItems = require(Moments.Flags.GetFFlagMomentsFilterUnavailableFeedItems)
local v37 = feedTelemetry.createNoopTelemetry()
local t1 = {
	deletedTitle = "Feature.Moments.Label.MomentDeletedTitle",
	deletedBody = "Feature.Moments.Label.MomentDeletedBody"
}

local function renderFeedItem(p1, n1: number) -- line: 88
	-- upvalues: feedItemRegistry (copy)
	local v49 = feedItemRegistry[p1.kind]

	if v49 ~= nil then
		return (v49.render(p1, n1))
	end

	return nil
end
local function feedItemKey(p2, n2: number) -- line: 93
	-- upvalues: feedItemRegistry (copy)
	local v52 = feedItemRegistry[p2.kind]
	local v53 = if v52 == nil then nil else v52.getKey(p2)

	if v53 ~= nil and v53 ~= "" then
		return v53
	end

	return (tostring(n2))
end
local function feedItemDedupeKey(p3) -- line: 103
	-- upvalues: feedItemRegistry (copy)
	local v55 = feedItemRegistry[p3.kind]

	if v55 ~= nil then
		return (v55.getKey(p3))
	end

	return nil
end
local function feedItemAttribution(p4) -- line: 108
	-- upvalues: feedItemRegistry (copy)
	local v57 = feedItemRegistry[p4.kind]

	if v57 ~= nil then
		return (v57.getAttribution(p4))
	end

	return nil
end
local function stringOrNil(p5) -- line: 113
	if p5 ~= nil then
		return (tostring(p5))
	end

	return nil
end

local u44 = nil

local function getLogger() -- line: 118
	-- upvalues: u44 (ref), MomentsParent (copy)
	if u44 == nil then
		u44 = require(MomentsParent.Loggers).Logger:new("Moments.Feed")
	end

	return u44
end
local function Feed(t2: {[any]: any}) -- line: 173
	-- upvalues: v37 (copy), FFlagMomentsSurfaceLoadTTI (copy), GetImmersiveChromeStore (copy), GetFFlagMomentsImmersiveChrome (copy), useLocalization (copy), t1 (copy), useMomentsSession (copy), GetToastStore (copy), SignalsReact (copy), React (copy), createFeedStore (copy), feedItemDedupeKey (copy), fireAnalyticsEvent (copy), EventNames (copy), useFeedTelemetry (copy), feedItemAttribution (copy), MomentsSurfaceLoadManager (copy), deleteMoment (copy), u44 (ref), MomentsParent (copy), GetFFlagMomentsFixDelete (copy), FFlagMomentsRemoveDeletedFromProfile (copy), GetDeletedMomentsStore (copy), GetFFlagMomentsFilterUnavailableFeedItems (copy), FeedContext2 (copy), VerticalPager2 (copy), renderFeedItem (copy), feedItemKey (copy), FeedStateView (copy), FeedNavigationBar (copy), ImmersiveChromeController (copy), DeletionConfirmationDialog (copy), MomentMediaCoordinatorProvider (copy), SurfaceReadyTracker (copy)
	local source = t2.source
	local v61 = t2.active == nil or t2.active
	local v62 = if t2.playbackActive == nil then v61 else t2.playbackActive
	local v63 = t2.showNavigationBar == nil or t2.showNavigationBar
	local v64 = t2.telemetry or v37
	local v65 = FFlagMomentsSurfaceLoadTTI and t2.trackSurfaceLoad == true
	local v66 = GetImmersiveChromeStore(false)
	local v67 = GetFFlagMomentsImmersiveChrome()
	local v68 = useLocalization(t1)
	local v69 = useMomentsSession()
	local v70 = GetToastStore(false)
	local v71 = SignalsReact.useSignalState(v69.getPendingDeletion)
	local v72 = React.useMemo(function() -- line: 199
		-- upvalues: createFeedStore (copy), source (copy), feedItemDedupeKey (copy), v65 (copy)
		return createFeedStore(source, feedItemDedupeKey, v65)
	end, { source })

	React.useEffect(function() -- line: 204
		-- upvalues: v72 (copy)
		v72.loadInitial()

		return function() -- line: 206
			-- upvalues: v72 (copy)
			v72.dispose()
		end
	end, { v72 })

	local v73 = React.useRef(nil)
	local v74 = React.useRef(0)
	local v75 = React.useRef(false)
	local v76 = React.useRef(0)
	local v77 = React.useCallback(function() -- line: 217
		-- upvalues: v75 (copy), v74 (copy), v76 (copy), v72 (copy)
		if v75.current or DateTime.now().UnixTimestampMillis < v74.current then
			return
		end

		v75.current = true

		local v100 = v76

		v100.current = v100.current + 1

		local current = v76.current

		v72.refresh()
		task.spawn(function() -- line: 226
			-- upvalues: v75 (copy), current (copy), v76 (copy), v72 (copy), v74 (copy)
			while v75.current and current == v76.current do
				local v128 = v72.getStatus(false)

				if v128 == "Loaded" or v128 == "Empty" then
					v75.current = false
					v74.current = DateTime.now().UnixTimestampMillis + 1000

					return
				end

				if v128 == "Failed" then
					v75.current = false

					return
				end

				task.wait()
			end
		end)
	end, { v72 })
	local v78 = React.useCallback(function(p6) -- line: 243
		-- upvalues: v72 (copy), v73 (copy)
		v72.prependItem({
			kind = "moment",
			moment = p6
		})

		local current = v73.current

		if current ~= nil then
			current.scrollToIndex(1)
		end
	end, { v72 })

	React.useImperativeHandle(t2.controllerRef, function() -- line: 251
		-- upvalues: v78 (copy), v77 (copy)
		return {
			prependMoment = v78,
			refresh = v77
		}
	end, {
		v78,
		v77
	})

	local v79 = React.useCallback(function(p7) -- line: 258
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy)
		if p7.kind ~= "moment" then
			return
		end

		local moment = p7.moment

		fireAnalyticsEvent(EventNames.MomentViewBegan, {
			viewMode = "vertical",
			momentId = moment.momentId,
			itemId = moment.recommendationMetadata.itemId,
			tracingId = moment.recommendationMetadata.tracingId or ""
		})
	end, {})
	local v80 = useFeedTelemetry(v72.pager, {
		telemetry = v64,
		active = v61,
		getAttribution = feedItemAttribution,
		recommendationSource = source.recommendationSource,
		onItemBecameActive = v79
	})
	local v81 = React.useRef(v62)

	React.useEffect(function() -- line: 284
		-- upvalues: v81 (copy), v62 (copy), v72 (copy), v79 (copy)
		local current = v81.current

		v81.current = v62

		if v62 and not current then
			local v107 = v72.pager.getCurrentItem(false)

			if v107 ~= nil then
				v79(v107)
			end
		end
	end, {
		v62,
		v72,
		v79
	})

	local v82 = React.useCallback(function() -- line: 295
		-- upvalues: v73 (copy)
		local current = v73.current

		if current ~= nil then
			current.next()
		end
	end, {})
	local v83 = React.useCallback(function() -- line: 301
		-- upvalues: v73 (copy)
		local current = v73.current

		if current ~= nil then
			current.previous()
		end
	end, {})
	local v84 = SignalsReact.useSignalState(v72.getStatus)
	local v85 = SignalsReact.useSignalState(v72.getLoadMoreFailed)
	local v86 = React.useRef({})

	React.useEffect(function() -- line: 315
		-- upvalues: v76 (copy), v75 (copy), v74 (copy)
		return function() -- line: 316
			-- upvalues: v76 (copy), v75 (copy), v74 (copy)
			local v129 = v76

			v129.current = v129.current + 1
			v75.current = false
			v74.current = 0
		end
	end, { v72 })

	local v87 = React.useRef(false)
	local v88 = React.useRef(false)

	React.useEffect(function() -- line: 327
		-- upvalues: v87 (copy), v65 (copy), MomentsSurfaceLoadManager (copy), fireAnalyticsEvent (copy), EventNames (copy)
		if not v87.current then
			v87.current = true

			if v65 then
				MomentsSurfaceLoadManager.renderStarted()
				MomentsSurfaceLoadManager.surfaceMounted()
			end

			fireAnalyticsEvent(EventNames.MomentsFirstUIRenderedTimestamp, {
				value = if not v65 or not MomentsSurfaceLoadManager.isSessionActive() then DateTime.now().UnixTimestampMillis else MomentsSurfaceLoadManager.elapsedMs()
			})
		end
	end, {})
	React.useEffect(function() -- line: 345
		-- upvalues: v65 (copy), v88 (copy), v84 (copy), fireAnalyticsEvent (copy), EventNames (copy)
		if v65 then
			return
		end

		if not v88.current and (v84 == "Loaded" or v84 == "LoadingMore") then
			v88.current = true
			fireAnalyticsEvent(EventNames.MomentsFirstContentLoadedTimestamp, {
				value = DateTime.now().UnixTimestampMillis
			})
		end
	end, { v84 })

	local v89 = React.useCallback(function() -- line: 357
		-- upvalues: v72 (copy), v73 (copy)
		local v110 = v72.pager.getCurrentIndex(false)
		local current = v73.current

		if current ~= nil then
			current.removeItem(v110)
		end
	end, { v72 })
	local v90 = React.useCallback(function() -- line: 369
		-- upvalues: v71 (copy), deleteMoment (copy), u44 (ref), MomentsParent (copy), GetFFlagMomentsFixDelete (copy), v89 (copy), FFlagMomentsRemoveDeletedFromProfile (copy), GetDeletedMomentsStore (copy), fireAnalyticsEvent (copy), EventNames (copy), v70 (copy), v68 (copy), v69 (copy)
		if v71 then
			local v112 = v71

			task.spawn(function() -- line: 376
				-- upvalues: deleteMoment (copy), v112 (copy), u44 (ref), MomentsParent (copy)
				local v130, v131 = deleteMoment(v112):await()

				if not v130 then
					if u44 == nil then
						u44 = require(MomentsParent.Loggers).Logger:new("Moments.Feed")
					end

					u44:warning("Failed to delete moment {}: {}", v112, (tostring(v131)))
				end
			end)

			if GetFFlagMomentsFixDelete() then
				v89()

				if FFlagMomentsRemoveDeletedFromProfile then
					GetDeletedMomentsStore(false).markDeleted(v112)
				end
			end

			fireAnalyticsEvent(EventNames.MomentItemDeleted, {
				momentId = v112
			})
			v70.triggerToast({
				title = v68.deletedTitle,
				text = v68.deletedBody
			})
		end

		v69.clearPendingDeletion()
	end, {
		v71,
		v69,
		v70,
		v68,
		v89
	})
	local v91 = React.useCallback(function() -- line: 409
		-- upvalues: v69 (copy)
		v69.clearPendingDeletion()
	end, { v69 })
	local v92 = React.useCallback(function(p8, s1: string?) -- line: 413
		-- upvalues: u44 (ref), MomentsParent (copy), fireAnalyticsEvent (copy), EventNames (copy), source (copy)
		local recommendationMetadata = p8.recommendationMetadata

		if u44 == nil then
			u44 = require(MomentsParent.Loggers).Logger:new("Moments.Feed")
		end

		u44:debug("Filtering moment after media load failure | momentId: {}, assetId: {}, captureType: {}, failureReason: {}", p8.momentId, tostring(p8.assetId), p8.metadata.captureType.Name, s1 or "nil")

		local v116 = fireAnalyticsEvent
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
		v116(FeedMediaLoadFailed, t3)
	end, { source })
	local v93 = React.useCallback(function(s2: string, s3: string?) -- line: 437
		-- upvalues: v86 (copy), v72 (copy), v92 (copy), v73 (copy)
		if v86.current[s2] then
			return
		end

		for v123, v124 in (v72.pager.getItems(false)) do
			if v124.kind == "moment" and s2 == v124.moment.momentId then
				v86.current[s2] = true
				v92(v124.moment, s3)

				local current = v73.current

				if current ~= nil then
					current.removeItem(v123)

					return
				end

				v72.pager.removeItem(v123)

				return
			end
		end
	end, {
		v72,
		v92
	})
	local v94 = React.useCallback(function(s4: string, s5: string?) -- line: 458
		-- upvalues: GetFFlagMomentsFilterUnavailableFeedItems (copy), v93 (copy)
		if GetFFlagMomentsFilterUnavailableFeedItems() then
			v93(s4, s5)
		end
	end, { v93 })
	local v95 = React.useMemo(function() -- line: 465
		-- upvalues: v72 (copy), v61 (copy), v62 (copy), source (copy), v64 (copy), v80 (copy), v66 (copy), v89 (copy)
		return {
			getStatus = v72.getStatus,
			isActiveFeed = v61,
			isPlaybackActive = v62,
			recommendationSource = source.recommendationSource,
			logAction = function(p9, p10, t4: {[any]: any}) -- line: 471
				-- upvalues: v64 (copy)
				return v64.logAction(p9, p10, t4)
			end,
			flushView = v80.flushView,
			getChromeVisible = v66.getChromeVisible,
			revealChrome = v66.revealChrome,
			removeCurrentItem = v89
		}
	end, {
		v72,
		v61,
		v62,
		source,
		v64,
		v80.flushView,
		v66,
		v89
	})
	local v96 = v84 == "Loaded" or v84 == "LoadingMore"
	local v97 = v63 and v96
	local v98 = v61 and (v84 ~= "Failed" and v84 ~= "Empty")
	local v99 = React.createElement(FeedContext2.Provider, {
		value = v95
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
				store = v72.pager,
				renderItem = renderFeedItem,
				keyExtractor = feedItemKey,
				onEndReached = v72.loadMore,
				active = v98,
				controllerRef = v73,
				initialIndex = t2.initialIndex,
				tuning = t2.pager,
				Size = UDim2.fromScale(1, 1)
			}),
			StateOverlay = React.createElement(FeedStateView, {
				zIndex = 2,
				status = v84,
				loadMoreFailed = v85,
				onRetry = v72.retry,
				emptyContent = t2.emptyContent
			}),
			NavBar = if not v97 then nil else React.createElement(FeedNavigationBar, {
				zIndex = 3,
				pager = v72.pager,
				active = v61,
				onScrollToNext = v82,
				onScrollToPrevious = v83
			}),
			ImmersiveController = if not v67 then nil else React.createElement(ImmersiveChromeController, {
				pager = v72.pager,
				active = v61 and v62,
				controllerRef = v73
			}),
			DeletionDialog = if v71 == nil then nil else React.createElement(DeletionConfirmationDialog, {
				onCancel = v91,
				onConfirm = v90
			})
		})
	})

	return React.createElement(MomentMediaCoordinatorProvider, {
		pager = v72.pager,
		playbackActive = v62,
		createCoordinator = t2.createCoordinator,
		onMediaItemFailed = if not GetFFlagMomentsFilterUnavailableFeedItems() then nil else v94
	}, if not v65 then v99 else {
		Feed = v99,
		SurfaceReadyTracker = React.createElement(SurfaceReadyTracker, {
			pager = v72.pager
		})
	})
end

return Feed
