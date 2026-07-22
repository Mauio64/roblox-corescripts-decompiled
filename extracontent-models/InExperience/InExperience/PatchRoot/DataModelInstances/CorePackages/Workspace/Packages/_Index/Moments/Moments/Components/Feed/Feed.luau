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
local FFlagMomentsFeedHealthAnalytics = MomentsCommon.Flags.FFlagMomentsFeedHealthAnalytics
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
local FFlagMomentsImmersiveChrome = require(Moments.Flags.FFlagMomentsImmersiveChrome)
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
local v40 = feedTelemetry.createNoopTelemetry()
local t1 = {
	deletedTitle = "Feature.Moments.Label.MomentDeletedTitle",
	deletedBody = "Feature.Moments.Label.MomentDeletedBody"
}

local function renderFeedItem(p1, n1: number) -- line: 91
	-- upvalues: feedItemRegistry (copy)
	local v52 = feedItemRegistry[p1.kind]

	if v52 ~= nil then
		return (v52.render(p1, n1))
	end

	return nil
end
local function feedItemKey(p2, n2: number) -- line: 96
	-- upvalues: feedItemRegistry (copy)
	local v55 = feedItemRegistry[p2.kind]
	local v56 = if v55 == nil then nil else v55.getKey(p2)

	if v56 ~= nil and v56 ~= "" then
		return v56
	end

	return (tostring(n2))
end
local function feedItemDedupeKey(p3) -- line: 106
	-- upvalues: feedItemRegistry (copy)
	local v58 = feedItemRegistry[p3.kind]

	if v58 ~= nil then
		return (v58.getKey(p3))
	end

	return nil
end
local function feedItemAttribution(p4) -- line: 111
	-- upvalues: feedItemRegistry (copy)
	local v60 = feedItemRegistry[p4.kind]

	if v60 ~= nil then
		return (v60.getAttribution(p4))
	end

	return nil
end
local function stringOrNil(p5) -- line: 116
	if p5 ~= nil then
		return (tostring(p5))
	end

	return nil
end

local u47 = nil

local function getLogger() -- line: 121
	-- upvalues: u47 (ref), MomentsParent (copy)
	if u47 == nil then
		u47 = require(MomentsParent.Loggers).Logger:new("Moments.Feed")
	end

	return u47
end
local function Feed(t2: {[any]: any}) -- line: 176
	-- upvalues: v40 (copy), FFlagMomentsSurfaceLoadTTI (copy), GetImmersiveChromeStore (copy), FFlagMomentsImmersiveChrome (copy), useLocalization (copy), t1 (copy), useMomentsSession (copy), GetToastStore (copy), SignalsReact (copy), React (copy), createFeedStore (copy), feedItemDedupeKey (copy), makeMomentViewBeganFields (copy), fireAnalyticsEvent (copy), EventNames (copy), useFeedTelemetry (copy), feedItemAttribution (copy), MomentsSurfaceLoadManager (copy), FFlagMomentsFeedHealthAnalytics (copy), feedItemRegistry (copy), deleteMoment (copy), u47 (ref), MomentsParent (copy), GetFFlagMomentsFixDelete (copy), FFlagMomentsRemoveDeletedFromProfile (copy), GetDeletedMomentsStore (copy), makeFeedActionFields (copy), MomentsCommon (copy), GetFFlagMomentsFilterUnavailableFeedItems (copy), FeedContext2 (copy), VerticalPager2 (copy), renderFeedItem (copy), feedItemKey (copy), FeedStateView (copy), FeedNavigationBar (copy), ImmersiveChromeController (copy), DeletionConfirmationDialog (copy), MomentMediaCoordinatorProvider (copy), SurfaceReadyTracker (copy)
	local source = t2.source
	local v64 = t2.active == nil or t2.active
	local v65 = if t2.playbackActive == nil then v64 else t2.playbackActive
	local v66 = t2.showNavigationBar == nil or t2.showNavigationBar
	local v67 = t2.telemetry or v40
	local v68 = FFlagMomentsSurfaceLoadTTI and t2.trackSurfaceLoad == true
	local v69 = GetImmersiveChromeStore(false)
	local v70 = FFlagMomentsImmersiveChrome
	local v71 = useLocalization(t1)
	local v72 = useMomentsSession()
	local v73 = GetToastStore(false)
	local v74 = SignalsReact.useSignalState(v72.getPendingDeletion)
	local v75 = React.useMemo(function() -- line: 202
		-- upvalues: createFeedStore (copy), source (copy), feedItemDedupeKey (copy), v68 (copy)
		return createFeedStore(source, feedItemDedupeKey, v68)
	end, { source })

	React.useEffect(function() -- line: 207
		-- upvalues: v75 (copy)
		v75.loadInitial()

		return function() -- line: 209
			-- upvalues: v75 (copy)
			v75.dispose()
		end
	end, { v75 })

	local v76 = React.useRef(nil)
	local v77 = React.useRef(0)
	local v78 = React.useRef(false)
	local v79 = React.useRef(0)
	local v80 = React.useCallback(function() -- line: 220
		-- upvalues: v78 (copy), v77 (copy), v79 (copy), v75 (copy)
		if v78.current or DateTime.now().UnixTimestampMillis < v77.current then
			return
		end

		v78.current = true

		local v105 = v79

		v105.current = v105.current + 1

		local current = v79.current

		v75.refresh()
		task.spawn(function() -- line: 229
			-- upvalues: v78 (copy), current (copy), v79 (copy), v75 (copy), v77 (copy)
			while v78.current and current == v79.current do
				local v140 = v75.getStatus(false)

				if v140 == "Loaded" or v140 == "Empty" then
					v78.current = false
					v77.current = DateTime.now().UnixTimestampMillis + 1000

					return
				end

				if v140 == "Failed" then
					v78.current = false

					return
				end

				task.wait()
			end
		end)
	end, { v75 })
	local v81 = React.useCallback(function(p6) -- line: 246
		-- upvalues: v75 (copy), v76 (copy)
		v75.prependItem({
			kind = "moment",
			moment = p6
		})

		local current = v76.current

		if current ~= nil then
			current.scrollToIndex(1)
		end
	end, { v75 })

	React.useImperativeHandle(t2.controllerRef, function() -- line: 254
		-- upvalues: v81 (copy), v80 (copy)
		return {
			prependMoment = v81,
			refresh = v80
		}
	end, {
		v81,
		v80
	})

	local v82 = React.useCallback(function(p7) -- line: 261
		-- upvalues: makeMomentViewBeganFields (copy), v72 (copy), fireAnalyticsEvent (copy), EventNames (copy)
		if p7.kind ~= "moment" then
			return
		end

		local moment = p7.moment
		local v111 = makeMomentViewBeganFields(moment, v72.getSessionSource(false))

		if v111 then
			fireAnalyticsEvent(EventNames.MomentViewBegan, v111)
		end
	end, { v72 })
	local v83 = useFeedTelemetry(v75.pager, {
		telemetry = v67,
		active = v64,
		getAttribution = feedItemAttribution,
		recommendationSource = source.recommendationSource,
		onItemBecameActive = v82
	})
	local v84 = React.useRef(v65)

	React.useEffect(function() -- line: 291
		-- upvalues: v84 (copy), v65 (copy), v75 (copy), v82 (copy)
		local current = v84.current

		v84.current = v65

		if v65 and not current then
			local v113 = v75.pager.getCurrentItem(false)

			if v113 ~= nil then
				v82(v113)
			end
		end
	end, {
		v65,
		v75,
		v82
	})

	local v85 = React.useCallback(function() -- line: 302
		-- upvalues: v76 (copy)
		local current = v76.current

		if current ~= nil then
			current.next()
		end
	end, {})
	local v86 = React.useCallback(function() -- line: 308
		-- upvalues: v76 (copy)
		local current = v76.current

		if current ~= nil then
			current.previous()
		end
	end, {})
	local v87 = SignalsReact.useSignalState(v75.getStatus)
	local v88 = SignalsReact.useSignalState(v75.getLoadMoreFailed)
	local v89 = React.useRef({})

	React.useEffect(function() -- line: 322
		-- upvalues: v79 (copy), v78 (copy), v77 (copy)
		return function() -- line: 323
			-- upvalues: v79 (copy), v78 (copy), v77 (copy)
			local v141 = v79

			v141.current = v141.current + 1
			v78.current = false
			v77.current = 0
		end
	end, { v75 })

	local v90 = React.useRef(false)
	local v91 = React.useRef(false)

	React.useEffect(function() -- line: 334
		-- upvalues: v90 (copy), v68 (copy), MomentsSurfaceLoadManager (copy), fireAnalyticsEvent (copy), EventNames (copy)
		if not v90.current then
			v90.current = true

			if v68 then
				MomentsSurfaceLoadManager.renderStarted()
				MomentsSurfaceLoadManager.surfaceMounted()
			end

			fireAnalyticsEvent(EventNames.MomentsFirstUIRenderedTimestamp, {
				value = if not v68 or not MomentsSurfaceLoadManager.isSessionActive() then DateTime.now().UnixTimestampMillis else MomentsSurfaceLoadManager.elapsedMs()
			})
		end
	end, {})
	React.useEffect(function() -- line: 352
		-- upvalues: v68 (copy), v91 (copy), v87 (copy), fireAnalyticsEvent (copy), EventNames (copy)
		if v68 then
			return
		end

		if not v91.current and (v87 == "Loaded" or v87 == "LoadingMore") then
			v91.current = true
			fireAnalyticsEvent(EventNames.MomentsFirstContentLoadedTimestamp, {
				value = DateTime.now().UnixTimestampMillis
			})
		end
	end, { v87 })

	local v92 = React.useRef(nil)

	React.useEffect(function() -- line: 368
		-- upvalues: FFlagMomentsFeedHealthAnalytics (copy), v87 (copy), v92 (copy), fireAnalyticsEvent (copy), EventNames (copy), source (copy), v75 (copy)
		if not FFlagMomentsFeedHealthAnalytics then
			return
		end

		if v87 ~= v92.current then
			if v87 == "Failed" then
				fireAnalyticsEvent(EventNames.FeedLoadFailed, {
					recommendationSource = source.recommendationSource or "",
					feedSourceId = source.id or "",
					failureReason = v75.getError(false) or ""
				})
			elseif v87 == "Empty" then
				fireAnalyticsEvent(EventNames.FeedNoMomentsFetched, {
					recommendationSource = source.recommendationSource or "",
					feedSourceId = source.id or ""
				})
			end
		end

		v92.current = v87
	end, { v87 })

	local v93 = React.useRef(false)

	React.useEffect(function() -- line: 395
		-- upvalues: FFlagMomentsFeedHealthAnalytics (copy), v88 (copy), v93 (copy), v75 (copy), feedItemRegistry (copy), fireAnalyticsEvent (copy), EventNames (copy), source (copy)
		if not FFlagMomentsFeedHealthAnalytics then
			return
		end

		if v88 and not v93.current then
			local v116 = v75.pager.getItems(false)[v75.pager.getCurrentIndex(false)]
			local v118

			if v116 ~= nil then
				local v117 = feedItemRegistry[v116.kind]

				v118 = if v117 == nil then nil else v117.getAttribution(v116)
			else
				v118 = nil
			end

			fireAnalyticsEvent(EventNames.FeedLoadMoreFailed, {
				recommendationSource = source.recommendationSource or "",
				feedSourceId = source.id or "",
				itemId = if v118 == nil then nil else v118.itemId,
				tracingId = if v118 == nil then nil else v118.tracingId
			})
		end

		v93.current = v88
	end, { v88 })

	local v94 = React.useCallback(function() -- line: 413
		-- upvalues: v75 (copy), v76 (copy)
		local v119 = v75.pager.getCurrentIndex(false)
		local current = v76.current

		if current ~= nil then
			current.removeItem(v119)
		end
	end, { v75 })
	local v95 = React.useCallback(function() -- line: 425
		-- upvalues: v74 (copy), deleteMoment (copy), u47 (ref), MomentsParent (copy), GetFFlagMomentsFixDelete (copy), v94 (copy), FFlagMomentsRemoveDeletedFromProfile (copy), GetDeletedMomentsStore (copy), makeFeedActionFields (copy), MomentsCommon (copy), fireAnalyticsEvent (copy), EventNames (copy), v73 (copy), v71 (copy), v72 (copy)
		if v74 then
			local momentId = v74.momentId
			local feedItemId = v74.feedItemId
			local feedSessionId = v74.feedSessionId

			task.spawn(function() -- line: 434
				-- upvalues: deleteMoment (copy), momentId (copy), u47 (ref), MomentsParent (copy)
				local v142, v143 = deleteMoment(momentId):await()

				if not v142 then
					if u47 == nil then
						u47 = require(MomentsParent.Loggers).Logger:new("Moments.Feed")
					end

					u47:warning("Failed to delete moment {}: {}", momentId, (tostring(v143)))
				end
			end)

			if GetFFlagMomentsFixDelete() then
				v94()

				if FFlagMomentsRemoveDeletedFromProfile then
					GetDeletedMomentsStore(false).markDeleted(momentId)
				end
			end

			local v124 = makeFeedActionFields(momentId, feedItemId, feedSessionId, if not MomentsCommon.Flags.GetFFlagMomentsAnalyticsSchemaIdentity() then nil else "delete")

			if v124 then
				fireAnalyticsEvent(EventNames.MomentItemDeleted, v124)
			end

			v73.triggerToast({
				title = v71.deletedTitle,
				text = v71.deletedBody
			})
		end

		v72.clearPendingDeletion()
	end, {
		v74,
		v72,
		v73,
		v71,
		v94
	})
	local v96 = React.useCallback(function() -- line: 477
		-- upvalues: v72 (copy)
		v72.clearPendingDeletion()
	end, { v72 })
	local v97 = React.useCallback(function(p8, s1: string?) -- line: 481
		-- upvalues: u47 (ref), MomentsParent (copy), fireAnalyticsEvent (copy), EventNames (copy), source (copy)
		local recommendationMetadata = p8.recommendationMetadata

		if u47 == nil then
			u47 = require(MomentsParent.Loggers).Logger:new("Moments.Feed")
		end

		u47:debug("Filtering moment after media load failure | momentId: {}, assetId: {}, captureType: {}, failureReason: {}", p8.momentId, tostring(p8.assetId), p8.metadata.captureType.Name, s1 or "nil")

		local v128 = fireAnalyticsEvent
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
		v128(FeedMediaLoadFailed, t3)
	end, { source })
	local v98 = React.useCallback(function(s2: string, s3: string?) -- line: 505
		-- upvalues: v89 (copy), v75 (copy), v97 (copy), v76 (copy)
		if v89.current[s2] then
			return
		end

		for v135, v136 in (v75.pager.getItems(false)) do
			if v136.kind == "moment" and s2 == v136.moment.momentId then
				v89.current[s2] = true
				v97(v136.moment, s3)

				local current = v76.current

				if current ~= nil then
					current.removeItem(v135)

					return
				end

				v75.pager.removeItem(v135)

				return
			end
		end
	end, {
		v75,
		v97
	})
	local v99 = React.useCallback(function(s4: string, s5: string?) -- line: 526
		-- upvalues: GetFFlagMomentsFilterUnavailableFeedItems (copy), v98 (copy)
		if GetFFlagMomentsFilterUnavailableFeedItems() then
			v98(s4, s5)
		end
	end, { v98 })
	local v100 = React.useMemo(function() -- line: 533
		-- upvalues: v75 (copy), v64 (copy), v65 (copy), source (copy), v67 (copy), v83 (copy), v69 (copy), v94 (copy)
		return {
			getStatus = v75.getStatus,
			isActiveFeed = v64,
			isPlaybackActive = v65,
			recommendationSource = source.recommendationSource,
			logAction = function(p9, p10, t4: {[any]: any}) -- line: 539
				-- upvalues: v67 (copy)
				return v67.logAction(p9, p10, t4)
			end,
			flushView = v83.flushView,
			getChromeVisible = v69.getChromeVisible,
			revealChrome = v69.revealChrome,
			removeCurrentItem = v94
		}
	end, {
		v75,
		v64,
		v65,
		source,
		v67,
		v83.flushView,
		v69,
		v94
	})
	local v101 = v87 == "Loaded" or v87 == "LoadingMore"
	local v102 = v66 and v101
	local v103 = v64 and (v87 ~= "Failed" and v87 ~= "Empty")
	local v104 = React.createElement(FeedContext2.Provider, {
		value = v100
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
				store = v75.pager,
				renderItem = renderFeedItem,
				keyExtractor = feedItemKey,
				onEndReached = v75.loadMore,
				active = v103,
				controllerRef = v76,
				initialIndex = t2.initialIndex,
				tuning = t2.pager,
				Size = UDim2.fromScale(1, 1)
			}),
			StateOverlay = React.createElement(FeedStateView, {
				zIndex = 2,
				status = v87,
				loadMoreFailed = v88,
				onRetry = v75.retry,
				emptyContent = t2.emptyContent
			}),
			NavBar = if not v102 then nil else React.createElement(FeedNavigationBar, {
				zIndex = 3,
				pager = v75.pager,
				active = v64,
				onScrollToNext = v85,
				onScrollToPrevious = v86
			}),
			ImmersiveController = if not v70 then nil else React.createElement(ImmersiveChromeController, {
				pager = v75.pager,
				active = v64 and v65,
				controllerRef = v76
			}),
			DeletionDialog = if v74 == nil then nil else React.createElement(DeletionConfirmationDialog, {
				onCancel = v96,
				onConfirm = v95
			})
		})
	})

	return React.createElement(MomentMediaCoordinatorProvider, {
		pager = v75.pager,
		playbackActive = v65,
		createCoordinator = t2.createCoordinator,
		onMediaItemFailed = if not GetFFlagMomentsFilterUnavailableFeedItems() then nil else v99
	}, if not v68 then v104 else {
		Feed = v104,
		SurfaceReadyTracker = React.createElement(SurfaceReadyTracker, {
			pager = v75.pager
		})
	})
end

return Feed
