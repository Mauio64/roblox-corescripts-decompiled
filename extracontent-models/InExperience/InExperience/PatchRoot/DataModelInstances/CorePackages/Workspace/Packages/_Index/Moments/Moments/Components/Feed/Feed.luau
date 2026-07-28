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
local FFlagMomentsPassFeedItemIdToBackendApis = SharedFlags.FFlagMomentsPassFeedItemIdToBackendApis
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
local v41 = feedTelemetry.createNoopTelemetry()
local t1 = {
	deletedTitle = "Feature.Moments.Label.MomentDeletedTitle",
	deletedBody = "Feature.Moments.Label.MomentDeletedBody"
}

local function renderFeedItem(p1, n1: number) -- line: 92
	-- upvalues: feedItemRegistry (copy)
	local v53 = feedItemRegistry[p1.kind]

	if v53 ~= nil then
		return (v53.render(p1, n1))
	end

	return nil
end
local function feedItemKey(p2, n2: number) -- line: 97
	-- upvalues: feedItemRegistry (copy)
	local v56 = feedItemRegistry[p2.kind]
	local v57 = if v56 == nil then nil else v56.getKey(p2)

	if v57 ~= nil and v57 ~= "" then
		return v57
	end

	return (tostring(n2))
end
local function feedItemDedupeKey(p3) -- line: 107
	-- upvalues: feedItemRegistry (copy)
	local v59 = feedItemRegistry[p3.kind]

	if v59 ~= nil then
		return (v59.getKey(p3))
	end

	return nil
end
local function feedItemAttribution(p4) -- line: 112
	-- upvalues: feedItemRegistry (copy)
	local v61 = feedItemRegistry[p4.kind]

	if v61 ~= nil then
		return (v61.getAttribution(p4))
	end

	return nil
end
local function stringOrNil(p5) -- line: 117
	if p5 ~= nil then
		return (tostring(p5))
	end

	return nil
end

local u48 = nil

local function getLogger() -- line: 122
	-- upvalues: u48 (ref), MomentsParent (copy)
	if u48 == nil then
		u48 = require(MomentsParent.Loggers).Logger:new("Moments.Feed")
	end

	return u48
end
local function Feed(t2: {[any]: any}) -- line: 177
	-- upvalues: v41 (copy), FFlagMomentsSurfaceLoadTTI (copy), GetImmersiveChromeStore (copy), FFlagMomentsImmersiveChrome (copy), useLocalization (copy), t1 (copy), useMomentsSession (copy), GetToastStore (copy), SignalsReact (copy), React (copy), createFeedStore (copy), feedItemDedupeKey (copy), makeMomentViewBeganFields (copy), fireAnalyticsEvent (copy), EventNames (copy), useFeedTelemetry (copy), feedItemAttribution (copy), MomentsSurfaceLoadManager (copy), FFlagMomentsFeedHealthAnalytics (copy), feedItemRegistry (copy), FFlagMomentsPassFeedItemIdToBackendApis (copy), deleteMoment (copy), u48 (ref), MomentsParent (copy), GetFFlagMomentsFixDelete (copy), FFlagMomentsRemoveDeletedFromProfile (copy), GetDeletedMomentsStore (copy), makeFeedActionFields (copy), MomentsCommon (copy), GetFFlagMomentsFilterUnavailableFeedItems (copy), FeedContext2 (copy), VerticalPager2 (copy), renderFeedItem (copy), feedItemKey (copy), FeedStateView (copy), FeedNavigationBar (copy), ImmersiveChromeController (copy), DeletionConfirmationDialog (copy), MomentMediaCoordinatorProvider (copy), SurfaceReadyTracker (copy)
	local source = t2.source
	local v65 = t2.active == nil or t2.active
	local v66 = if t2.playbackActive == nil then v65 else t2.playbackActive
	local v67 = t2.showNavigationBar == nil or t2.showNavigationBar
	local v68 = t2.telemetry or v41
	local v69 = FFlagMomentsSurfaceLoadTTI and t2.trackSurfaceLoad == true
	local v70 = GetImmersiveChromeStore(false)
	local v71 = FFlagMomentsImmersiveChrome
	local v72 = useLocalization(t1)
	local v73 = useMomentsSession()
	local v74 = GetToastStore(false)
	local v75 = SignalsReact.useSignalState(v73.getPendingDeletion)
	local v76 = React.useMemo(function() -- line: 203
		-- upvalues: createFeedStore (copy), source (copy), feedItemDedupeKey (copy), v69 (copy)
		return createFeedStore(source, feedItemDedupeKey, v69)
	end, { source })

	React.useEffect(function() -- line: 208
		-- upvalues: v76 (copy)
		v76.loadInitial()

		return function() -- line: 210
			-- upvalues: v76 (copy)
			v76.dispose()
		end
	end, { v76 })

	local v77 = React.useRef(nil)
	local v78 = React.useRef(0)
	local v79 = React.useRef(false)
	local v80 = React.useRef(0)
	local v81 = React.useCallback(function() -- line: 221
		-- upvalues: v79 (copy), v78 (copy), v80 (copy), v76 (copy)
		if v79.current or DateTime.now().UnixTimestampMillis < v78.current then
			return
		end

		v79.current = true

		local v106 = v80

		v106.current = v106.current + 1

		local current = v80.current

		v76.refresh()
		task.spawn(function() -- line: 230
			-- upvalues: v79 (copy), current (copy), v80 (copy), v76 (copy), v78 (copy)
			while v79.current and current == v80.current do
				local v141 = v76.getStatus(false)

				if v141 == "Loaded" or v141 == "Empty" then
					v79.current = false
					v78.current = DateTime.now().UnixTimestampMillis + 1000

					return
				end

				if v141 == "Failed" then
					v79.current = false

					return
				end

				task.wait()
			end
		end)
	end, { v76 })
	local v82 = React.useCallback(function(p6) -- line: 247
		-- upvalues: v76 (copy), v77 (copy)
		v76.prependItem({
			kind = "moment",
			moment = p6
		})

		local current = v77.current

		if current ~= nil then
			current.scrollToIndex(1)
		end
	end, { v76 })

	React.useImperativeHandle(t2.controllerRef, function() -- line: 255
		-- upvalues: v82 (copy), v81 (copy)
		return {
			prependMoment = v82,
			refresh = v81
		}
	end, {
		v82,
		v81
	})

	local v83 = React.useCallback(function(p7) -- line: 262
		-- upvalues: makeMomentViewBeganFields (copy), v73 (copy), fireAnalyticsEvent (copy), EventNames (copy)
		if p7.kind ~= "moment" then
			return
		end

		local moment = p7.moment
		local v112 = makeMomentViewBeganFields(moment, v73.getSessionSource(false))

		if v112 then
			fireAnalyticsEvent(EventNames.MomentViewBegan, v112)
		end
	end, { v73 })
	local v84 = useFeedTelemetry(v76.pager, {
		telemetry = v68,
		active = v65,
		getAttribution = feedItemAttribution,
		recommendationSource = source.recommendationSource,
		onItemBecameActive = v83
	})
	local v85 = React.useRef(v66)

	React.useEffect(function() -- line: 292
		-- upvalues: v85 (copy), v66 (copy), v76 (copy), v83 (copy)
		local current = v85.current

		v85.current = v66

		if v66 and not current then
			local v114 = v76.pager.getCurrentItem(false)

			if v114 ~= nil then
				v83(v114)
			end
		end
	end, {
		v66,
		v76,
		v83
	})

	local v86 = React.useCallback(function() -- line: 303
		-- upvalues: v77 (copy)
		local current = v77.current

		if current ~= nil then
			current.next()
		end
	end, {})
	local v87 = React.useCallback(function() -- line: 309
		-- upvalues: v77 (copy)
		local current = v77.current

		if current ~= nil then
			current.previous()
		end
	end, {})
	local v88 = SignalsReact.useSignalState(v76.getStatus)
	local v89 = SignalsReact.useSignalState(v76.getLoadMoreFailed)
	local v90 = React.useRef({})

	React.useEffect(function() -- line: 323
		-- upvalues: v80 (copy), v79 (copy), v78 (copy)
		return function() -- line: 324
			-- upvalues: v80 (copy), v79 (copy), v78 (copy)
			local v142 = v80

			v142.current = v142.current + 1
			v79.current = false
			v78.current = 0
		end
	end, { v76 })

	local v91 = React.useRef(false)
	local v92 = React.useRef(false)

	React.useEffect(function() -- line: 335
		-- upvalues: v91 (copy), v69 (copy), MomentsSurfaceLoadManager (copy), fireAnalyticsEvent (copy), EventNames (copy)
		if not v91.current then
			v91.current = true

			if v69 then
				MomentsSurfaceLoadManager.renderStarted()
				MomentsSurfaceLoadManager.surfaceMounted()
			end

			fireAnalyticsEvent(EventNames.MomentsFirstUIRenderedTimestamp, {
				value = if not v69 or not MomentsSurfaceLoadManager.isSessionActive() then DateTime.now().UnixTimestampMillis else MomentsSurfaceLoadManager.elapsedMs()
			})
		end
	end, {})
	React.useEffect(function() -- line: 353
		-- upvalues: v69 (copy), v92 (copy), v88 (copy), fireAnalyticsEvent (copy), EventNames (copy)
		if v69 then
			return
		end

		if not v92.current and (v88 == "Loaded" or v88 == "LoadingMore") then
			v92.current = true
			fireAnalyticsEvent(EventNames.MomentsFirstContentLoadedTimestamp, {
				value = DateTime.now().UnixTimestampMillis
			})
		end
	end, { v88 })

	local v93 = React.useRef(nil)

	React.useEffect(function() -- line: 369
		-- upvalues: FFlagMomentsFeedHealthAnalytics (copy), v88 (copy), v93 (copy), fireAnalyticsEvent (copy), EventNames (copy), source (copy), v76 (copy)
		if not FFlagMomentsFeedHealthAnalytics then
			return
		end

		if v88 ~= v93.current then
			if v88 == "Failed" then
				fireAnalyticsEvent(EventNames.FeedLoadFailed, {
					recommendationSource = source.recommendationSource or "",
					feedSourceId = source.id or "",
					failureReason = v76.getError(false) or ""
				})
			elseif v88 == "Empty" then
				fireAnalyticsEvent(EventNames.FeedNoMomentsFetched, {
					recommendationSource = source.recommendationSource or "",
					feedSourceId = source.id or ""
				})
			end
		end

		v93.current = v88
	end, { v88 })

	local v94 = React.useRef(false)

	React.useEffect(function() -- line: 396
		-- upvalues: FFlagMomentsFeedHealthAnalytics (copy), v89 (copy), v94 (copy), v76 (copy), feedItemRegistry (copy), fireAnalyticsEvent (copy), EventNames (copy), source (copy)
		if not FFlagMomentsFeedHealthAnalytics then
			return
		end

		if v89 and not v94.current then
			local v117 = v76.pager.getItems(false)[v76.pager.getCurrentIndex(false)]
			local v119

			if v117 ~= nil then
				local v118 = feedItemRegistry[v117.kind]

				v119 = if v118 == nil then nil else v118.getAttribution(v117)
			else
				v119 = nil
			end

			fireAnalyticsEvent(EventNames.FeedLoadMoreFailed, {
				recommendationSource = source.recommendationSource or "",
				feedSourceId = source.id or "",
				itemId = if v119 == nil then nil else v119.itemId,
				tracingId = if v119 == nil then nil else v119.tracingId
			})
		end

		v94.current = v89
	end, { v89 })

	local v95 = React.useCallback(function() -- line: 414
		-- upvalues: v76 (copy), v77 (copy)
		local v120 = v76.pager.getCurrentIndex(false)
		local current = v77.current

		if current ~= nil then
			current.removeItem(v120)
		end
	end, { v76 })
	local v96 = React.useCallback(function() -- line: 426
		-- upvalues: v75 (copy), FFlagMomentsPassFeedItemIdToBackendApis (copy), v73 (copy), deleteMoment (copy), u48 (ref), MomentsParent (copy), GetFFlagMomentsFixDelete (copy), v95 (copy), FFlagMomentsRemoveDeletedFromProfile (copy), GetDeletedMomentsStore (copy), makeFeedActionFields (copy), MomentsCommon (copy), fireAnalyticsEvent (copy), EventNames (copy), v74 (copy), v72 (copy)
		if v75 then
			local momentId = v75.momentId
			local feedItemId = v75.feedItemId
			local feedSessionId = v75.feedSessionId

			if FFlagMomentsPassFeedItemIdToBackendApis and (feedItemId == nil or feedItemId == "") then
				v73.clearPendingDeletion()

				return
			end

			task.spawn(function() -- line: 441
				-- upvalues: FFlagMomentsPassFeedItemIdToBackendApis (copy), deleteMoment (copy), momentId (copy), feedItemId (copy), u48 (ref), MomentsParent (copy)
				local v143, v144 = ((if not FFlagMomentsPassFeedItemIdToBackendApis then deleteMoment(momentId) else deleteMoment(momentId, nil, feedItemId))):await()

				if not v143 then
					if u48 == nil then
						u48 = require(MomentsParent.Loggers).Logger:new("Moments.Feed")
					end

					u48:warning("Failed to delete moment {}: {}", momentId, (tostring(v144)))
				end
			end)

			if GetFFlagMomentsFixDelete() then
				v95()

				if FFlagMomentsRemoveDeletedFromProfile then
					GetDeletedMomentsStore(false).markDeleted(momentId)
				end
			end

			local v125 = makeFeedActionFields(momentId, feedItemId, feedSessionId, if not MomentsCommon.Flags.GetFFlagMomentsAnalyticsSchemaIdentity() then nil else "delete")

			if v125 then
				fireAnalyticsEvent(EventNames.MomentItemDeleted, v125)
			end

			v74.triggerToast({
				title = v72.deletedTitle,
				text = v72.deletedBody
			})
		end

		v73.clearPendingDeletion()
	end, {
		v75,
		v73,
		v74,
		v72,
		v95
	})
	local v97 = React.useCallback(function() -- line: 487
		-- upvalues: v73 (copy)
		v73.clearPendingDeletion()
	end, { v73 })
	local v98 = React.useCallback(function(p8, s1: string?) -- line: 491
		-- upvalues: u48 (ref), MomentsParent (copy), fireAnalyticsEvent (copy), EventNames (copy), source (copy)
		local recommendationMetadata = p8.recommendationMetadata

		if u48 == nil then
			u48 = require(MomentsParent.Loggers).Logger:new("Moments.Feed")
		end

		u48:debug("Filtering moment after media load failure | momentId: {}, assetId: {}, captureType: {}, failureReason: {}", p8.momentId, tostring(p8.assetId), p8.metadata.captureType.Name, s1 or "nil")

		local v129 = fireAnalyticsEvent
		local FeedMediaLoadFailed = EventNames.FeedMediaLoadFailed
		local t3 = {
			momentId = p8.momentId,
			assetId = tostring(p8.assetId),
			captureType = p8.metadata.captureType.Name,
			creatorId = tostring(p8.creatorId),
			itemId = if recommendationMetadata == nil then nil else recommendationMetadata.feedItemId,
			tracingId = if recommendationMetadata == nil then nil else recommendationMetadata.tracingId,
			recommendationSource = source.recommendationSource or "",
			feedSourceId = source.id or ""
		}
		local placeId = p8.metadata.placeId

		t3.placeId = if placeId == nil then nil else tostring(placeId)

		local universeId = p8.metadata.universeId

		t3.universeId = if universeId == nil then nil else tostring(universeId)
		t3.failureReason = s1
		v129(FeedMediaLoadFailed, t3)
	end, { source })
	local v99 = React.useCallback(function(s2: string, s3: string?) -- line: 515
		-- upvalues: v90 (copy), v76 (copy), v98 (copy), v77 (copy)
		if v90.current[s2] then
			return
		end

		for v136, v137 in (v76.pager.getItems(false)) do
			if v137.kind == "moment" and s2 == v137.moment.momentId then
				v90.current[s2] = true
				v98(v137.moment, s3)

				local current = v77.current

				if current ~= nil then
					current.removeItem(v136)

					return
				end

				v76.pager.removeItem(v136)

				return
			end
		end
	end, {
		v76,
		v98
	})
	local v100 = React.useCallback(function(s4: string, s5: string?) -- line: 536
		-- upvalues: GetFFlagMomentsFilterUnavailableFeedItems (copy), v99 (copy)
		if GetFFlagMomentsFilterUnavailableFeedItems() then
			v99(s4, s5)
		end
	end, { v99 })
	local v101 = React.useMemo(function() -- line: 543
		-- upvalues: v76 (copy), v65 (copy), v66 (copy), source (copy), v68 (copy), v84 (copy), v70 (copy), v95 (copy)
		return {
			getStatus = v76.getStatus,
			isActiveFeed = v65,
			isPlaybackActive = v66,
			recommendationSource = source.recommendationSource,
			logAction = function(p9, p10, t4: {[any]: any}) -- line: 549
				-- upvalues: v68 (copy)
				return v68.logAction(p9, p10, t4)
			end,
			flushView = v84.flushView,
			getChromeVisible = v70.getChromeVisible,
			revealChrome = v70.revealChrome,
			removeCurrentItem = v95
		}
	end, {
		v76,
		v65,
		v66,
		source,
		v68,
		v84.flushView,
		v70,
		v95
	})
	local v102 = v88 == "Loaded" or v88 == "LoadingMore"
	local v103 = v67 and v102
	local v104 = v65 and (v88 ~= "Failed" and v88 ~= "Empty")
	local v105 = React.createElement(FeedContext2.Provider, {
		value = v101
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
				store = v76.pager,
				renderItem = renderFeedItem,
				keyExtractor = feedItemKey,
				onEndReached = v76.loadMore,
				active = v104,
				controllerRef = v77,
				initialIndex = t2.initialIndex,
				tuning = t2.pager,
				Size = UDim2.fromScale(1, 1)
			}),
			StateOverlay = React.createElement(FeedStateView, {
				zIndex = 2,
				status = v88,
				loadMoreFailed = v89,
				onRetry = v76.retry,
				emptyContent = t2.emptyContent
			}),
			NavBar = if not v103 then nil else React.createElement(FeedNavigationBar, {
				zIndex = 3,
				pager = v76.pager,
				active = v65,
				onScrollToNext = v86,
				onScrollToPrevious = v87
			}),
			ImmersiveController = if not v71 then nil else React.createElement(ImmersiveChromeController, {
				pager = v76.pager,
				active = v65 and v66,
				controllerRef = v77
			}),
			DeletionDialog = if v75 == nil then nil else React.createElement(DeletionConfirmationDialog, {
				onCancel = v97,
				onConfirm = v96
			})
		})
	})

	return React.createElement(MomentMediaCoordinatorProvider, {
		pager = v76.pager,
		playbackActive = v66,
		createCoordinator = t2.createCoordinator,
		onMediaItemFailed = if not GetFFlagMomentsFilterUnavailableFeedItems() then nil else v100
	}, if not v69 then v105 else {
		Feed = v105,
		SurfaceReadyTracker = React.createElement(SurfaceReadyTracker, {
			pager = v76.pager
		})
	})
end

return Feed
