local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local useStyle = require(CorePackages.Packages.UIBlox).Core.Style.useStyle
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local Signal = require(CorePackages.Workspace.Packages.AppCommonLib).Signal
local Promise = require(CorePackages.Packages.Promise)
local useUiModeInfo = require(CorePackages.Workspace.Packages.RobloxAppHooks).useUiModeInfo
local RobloxAppEnums = require(CorePackages.Workspace.Packages.RobloxAppEnums)
local UiMode = RobloxAppEnums.UiMode
local AppPage = RobloxAppEnums.AppPage
local useLastInputMode = require(CorePackages.Workspace.Packages.FocusNavigationUtils).useLastInputMode
local DiscoveryTypes = require(CorePackages.Workspace.Packages.DiscoveryTypes)
local OmniFeedTypes = DiscoveryTypes.OmniFeedTypes
local OmniFeedConstants = DiscoveryTypes.OmniFeedConstants
local ViewportVideoAutoplaySync = require(CorePackages.Workspace.Packages.VideoUtils).ViewportVideoAutoplaySync
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useAnimateScrollViewToSelection = require(CorePackages.Workspace.Packages.AppBlox).useAnimateScrollViewToSelection
local ScrollDetector = require(CorePackages.Workspace.Packages.ScrollTelemetry).ScrollDetector
local createScrollIntervalPerformanceTracker = require(CorePackages.Workspace.Packages.IntervalPerformanceTracker).createScrollIntervalPerformanceTracker
local useAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).useAppPolicy
local DiscoveryAppLaunchTracker = require(CorePackages.Workspace.Packages.AppLaunchTracker).DiscoveryAppLaunchTracker
local isSduiGameOmniFeedItem = require(CorePackages.Workspace.Packages.ServerDrivenUi).isSduiGameOmniFeedItem
local OmniFeedImpressionsDetector = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules.Personalization.OmniFeed.OmniFeedImpressionsDetector
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local RefreshScrollingFrameWithLoadMore = require(Modules.LuaApp.Components.RefreshScrollingFrameWithLoadMore)
local JoinYourFriendsRefreshEvent = require(Modules.LuaApp.Components.EventReceivers.JoinYourFriendsRefreshEvent)
local Constants = require(Modules.LuaApp.Constants)
local OmniFeedItemsContainer = require(script.Parent.OmniFeedItemsContainer)
local FIntLuaJoinYourFriendsRefreshInterval = require(Modules.Personalization.Flags.FIntLuaJoinYourFriendsRefreshInterval)
local FFlagSearchOmniAutocompletePage = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSearchOmniAutocompletePage
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagRenameDeprecatedUIBloxTokens = SharedFlags.FFlagRenameDeprecatedUIBloxTokens
local FFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local FFlagLuaAppLayoutParamsInContext = SharedFlags.FFlagLuaAppLayoutParamsInContext
local FFlagLuaAppScrollTelemetryIntegration = SharedFlags.FFlagLuaAppScrollTelemetryIntegration
local FFlagLuaAppChartsStickyHeader = SharedFlags.FFlagLuaAppChartsStickyHeader
local FFlagExtendScrollingFramesBySafeInsets = SharedFlags.FFlagExtendScrollingFramesBySafeInsets
local FFlagLuaAppCompositionAlways = SharedFlags.FFlagLuaAppCompositionAlways
local FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone = SharedFlags.FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone
local FFlagLuaAppHomeTouchAutoplay = SharedFlags.FFlagLuaAppHomeTouchAutoplay
local FFlagLuaAppGameCarouselAmpUpsellAction = SharedFlags.FFlagLuaAppGameCarouselAmpUpsellAction
local FFlagLuaAppsDefaultSelection = SharedFlags.FFlagLuaAppsDefaultSelection
local v44 = game:DefineFastInt("LuaAppOmniFeedInitialNumRows", 6)
local v45 = game:DefineFastInt("LuaAppOmniFeedLoadNumRows", 3)
local FStringLuaAppSortsWithDividers = SharedFlags.FStringLuaAppSortsWithDividers

if SharedFlags.FFlagLuaAppUseSortsWithDividersFString then
	for match in FStringLuaAppSortsWithDividers:gmatch("(%w+)") do
		({})[match] = true
	end
end

local v48 = game:DefineFastInt("LuaAppOmniFeedScrollAnimDurationMs", 400) / 1000
local v49 = if not FFlagLuaAppChartsStickyHeader then nil else {}

local function isGameTreatmentType(s1: string, p1) -- line: 79
	-- upvalues: OmniFeedTypes (copy), isSduiGameOmniFeedItem (copy)
	return s1 == OmniFeedTypes.HomeGameGrid or (s1 == OmniFeedTypes.Carousel or (s1 == OmniFeedTypes.SearchGameGrid or isSduiGameOmniFeedItem(s1, p1)))
end
local function getNumItemsForRows(t1: {[any]: any}, n1: number, n2: number, b1: boolean?) -- line: 89
	-- upvalues: OmniFeedTypes (copy), isSduiGameOmniFeedItem (copy)
	local n3 = 0
	local n4 = 0

	for i = n1, #t1 do
		local v61 = t1[i]
		local v62 = v61 and (not not v61.treatmentProps and v61.treatmentProps.numberOfRows) or 1

		if v62 == -1 then
			v62 = 1
		end

		n4 += 1
		n3 += v62

		local topicId = nil

		if v61 then
			if v61.treatmentProps and v61.treatmentProps.topicId then
				topicId = v61.treatmentProps.topicId
			elseif v61.itemId and v61.itemId.topicId then
				topicId = v61.itemId.topicId
			end
		end

		if n2 <= n3 then
			return n4
		end

		if b1 then
			local treatmentType = v61.treatmentType

			if treatmentType == OmniFeedTypes.HomeGameGrid or (treatmentType == OmniFeedTypes.Carousel or (treatmentType == OmniFeedTypes.SearchGameGrid or isSduiGameOmniFeedItem(treatmentType, topicId))) then
				return n4
			end
		end
	end

	return n4
end

return function(t2: {[any]: any}) -- line: 169
	-- upvalues: useStyle (copy), useAppPolicy (copy), useUiModeInfo (copy), UiMode (copy), React (copy), Signal (copy), FFlagLuaAppLayoutParamsInContext (copy), useLastInputMode (copy), FFlagLuaAppChartsStickyHeader (copy), getNumItemsForRows (copy), v44 (copy), useDesignTokens (copy), FFlagRenameDeprecatedUIBloxTokens (copy), useSelector (copy), OmniFeedConstants (copy), FFlagLuaAppGameCarouselAmpUpsellAction (copy), Constants (copy), JoinYourFriendsRefreshEvent (copy), FIntLuaJoinYourFriendsRefreshInterval (copy), v49 (copy), useAnimateScrollViewToSelection (copy), v48 (copy), FFlagLuaAppScrollTelemetryIntegration (copy), createScrollIntervalPerformanceTracker (copy), v45 (copy), DiscoveryAppLaunchTracker (copy), Roact (copy), RefreshScrollingFrameWithLoadMore (copy), Promise (copy), FFlagSearchOmniAutocompletePage (copy), FFlagAppIaScrollAway (copy), FFlagExtendScrollingFramesBySafeInsets (copy), OmniFeedItemsContainer (copy), FFlagLuaAppCompositionAlways (copy), FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone (copy), FFlagLuaAppHomeTouchAutoplay (copy), AppPage (copy), FFlagLuaAppsDefaultSelection (copy), OmniFeedImpressionsDetector (copy), ViewportVideoAutoplaySync (copy), ScrollDetector (copy)
	local v66 = useStyle()
	local v67 = useAppPolicy(function(p2) -- line: 171
		return p2.useGridPageLayout()
	end)
	local v68 = useAppPolicy(function(p3) -- line: 174
		return p3.getMountAllOmniFeedItems()
	end)
	local v69 = useUiModeInfo().uiMode == UiMode.TenFoot
	local u70 = v67 and not v69
	local v71 = React.useRef(Signal.new())
	local v72 = React.useRef(Signal.new())
	local v73 = React.useRef(0)
	local v74 = React.useRef(false)
	local u75 = if not FFlagLuaAppLayoutParamsInContext then t2.scrollingFrameRef else nil
	local v76 = useLastInputMode() == "Cursor"
	local v77 = t2.shouldStopAfterOneGameSort and not v68
	local v78 = nil

	if FFlagLuaAppLayoutParamsInContext then
		u75 = React.useRef(nil)

		local _, v80 = React.useState(nil)
		local u81 = v80

		if type(t2.scrollingFrameRef) == "table" then
			u75 = t2.scrollingFrameRef
		end

		v78 = React.useCallback(function(p4) -- line: 202
			-- upvalues: u75 (ref), u81 (ref), t2 (copy)
			u75.current = p4
			u81(p4)

			if type(t2.scrollingFrameRef) == "function" then
				t2.scrollingFrameRef(p4)
			end
		end, { t2.scrollingFrameRef })
	end

	local v82 = if not FFlagLuaAppChartsStickyHeader then nil else React.useMemo(function() -- line: 212
		-- upvalues: t2 (copy)
		local t3 = {}

		for _, v113 in t2.omniFeedItems do
			if v113.pageSection == t2.omniFeedPageSection then
				table.insert(t3, v113)
			end
		end

		return t3
	end, {
		t2.omniFeedItems,
		t2.omniFeedPageSection
	})
	local v83, v84 = React.useState(function() -- line: 224
		-- upvalues: v68 (copy), FFlagLuaAppChartsStickyHeader (copy), v82 (copy), t2 (copy), getNumItemsForRows (copy), v44 (copy), v77 (copy)
		if v68 then
			return #if not FFlagLuaAppChartsStickyHeader then t2.omniFeedItems else v82
		end

		return (getNumItemsForRows(if not FFlagLuaAppChartsStickyHeader then t2.omniFeedItems else v82, 1, v44, v77))
	end)
	local pageContext = t2.pageContext
	local impressionsTag = t2.impressionsTag
	local omniFeedItems = t2.omniFeedItems
	local Theme = v66.Theme
	local _ = Theme.BackgroundDefault.Color
	local _ = Theme.BackgroundDefault.Transparency
	local v91 = not u70 and 0 or 4
	local v92 = useDesignTokens()
	local BackgroundColor = v92.LuaApps.App.Page.BackgroundColor
	local PageBackgroundTransparency = v92.LuaApps.App.Page.BackgroundTransparency
	local v95 = React.useMemo(function() -- line: 255
		-- upvalues: v92 (copy), u70 (ref)
		return v92.LuaApps.HomeOmniFeed.getLayoutSpacing(u70)
	end, {
		u70,
		v92
	})
	local v96 = t2.topPadding or v95.topMargin
	local v97 = not t2.loadMoreButtonText and 80 or if not FFlagRenameDeprecatedUIBloxTokens then v92.Global.Size_600 else v92.Size.Size_1200
	local v98 = t2.bottomPadding or v97
	local v99 = useSelector(function(p5) -- line: 265
		return p5.Personalization.OmniItemsGlobalLayoutData
	end)
	local v100 = v99 and (v99[OmniFeedConstants.GlobalLayoutDataKeys.JYFRefresh] == "true" or v99[OmniFeedConstants.GlobalLayoutDataKeys.JYFRefresh] == true)
	local v101 = if not FFlagLuaAppGameCarouselAmpUpsellAction then React.useCallback(function(b2: boolean?) -- line: 276
		-- upvalues: v73 (copy), v72 (copy), OmniFeedConstants (copy), t2 (copy)
		v73.current = tick()
		v72.current:fire()

		local v116 = if not b2 then OmniFeedConstants.OmniRecommendationsRequestIntent.ManualRefresh else OmniFeedConstants.OmniRecommendationsRequestIntent.FriendPresenceChange

		return t2.refresh(v116)
	end) else nil
	local v102 = if not FFlagLuaAppGameCarouselAmpUpsellAction then nil else React.useCallback(function(s2: string?) -- line: 288
		-- upvalues: v73 (copy), v72 (copy), t2 (copy), OmniFeedConstants (copy)
		v73.current = tick()
		v72.current:fire()

		return t2.refresh(s2 or OmniFeedConstants.OmniRecommendationsRequestIntent.ManualRefresh)
	end)

	React.useEffect(function() -- line: 308
		-- upvalues: v100 (copy), JoinYourFriendsRefreshEvent (copy), v74 (copy), v73 (copy), FIntLuaJoinYourFriendsRefreshInterval (copy), u75 (ref), Constants (copy), FFlagLuaAppGameCarouselAmpUpsellAction (copy), v102 (copy), OmniFeedConstants (copy), v101 (copy)
		local connection = nil

		if v100 then
			connection = JoinYourFriendsRefreshEvent.Event:Connect(function() -- line: 311
				-- upvalues: v74 (copy), v73 (copy), FIntLuaJoinYourFriendsRefreshInterval (copy), u75 (ref), Constants (copy), FFlagLuaAppGameCarouselAmpUpsellAction (copy), v102 (copy), OmniFeedConstants (copy), v101 (copy)
				if v74.current then
					return
				end

				local v128 = tick() - v73.current
				local v129 = FIntLuaJoinYourFriendsRefreshInterval - v128

				if v129 < 0 then
					v74.current = false

					if u75.current then
						local CanvasPositionY = u75.current.CanvasPosition.Y
						local JoinYourFriendsTileHeight = Constants.JoinYourFriendsTile.Height

						if CanvasPositionY >= 0 and CanvasPositionY <= JoinYourFriendsTileHeight then
							if FFlagLuaAppGameCarouselAmpUpsellAction then
								v102(OmniFeedConstants.OmniRecommendationsRequestIntent.FriendPresenceChange)

								return
							end

							v101(true)

							return
						end
					end
				else
					v74.current = true
					task.delay(v129, function() -- line: 322
						-- upvalues: v74 (copy), u75 (ref), Constants (copy), FFlagLuaAppGameCarouselAmpUpsellAction (copy), v102 (copy), OmniFeedConstants (copy), v101 (copy)
						v74.current = false

						if u75.current then
							local CanvasPositionY = u75.current.CanvasPosition.Y
							local JoinYourFriendsTileHeight = Constants.JoinYourFriendsTile.Height

							if CanvasPositionY >= 0 and CanvasPositionY <= JoinYourFriendsTileHeight then
								if FFlagLuaAppGameCarouselAmpUpsellAction then
									v102(OmniFeedConstants.OmniRecommendationsRequestIntent.FriendPresenceChange)

									return
								end

								v101(true)
							end
						end
					end)
				end
			end)
		end

		return function() -- line: 328
			-- upvalues: connection (ref)
			if connection then
				connection:Disconnect()
				connection = nil
			end
		end
	end, { t2.refresh })

	local v103 = useSelector(function(p6) -- line: 336
		-- upvalues: pageContext (copy)
		return p6.OmniRecommendations[pageContext]
	end)
	local v104 = v103 and v103.sorts or if not FFlagLuaAppChartsStickyHeader then {} else v49
	local sduiContext = t2.sduiContext

	useAnimateScrollViewToSelection(u75, v48)

	if FFlagLuaAppScrollTelemetryIntegration then
		React.useEffect(function() -- line: 352
			-- upvalues: t2 (copy), u75 (ref), createScrollIntervalPerformanceTracker (copy)
			local scrollPerformanceIntervalName = t2.scrollPerformanceIntervalName

			if scrollPerformanceIntervalName == nil then
				return
			end

			local v123 = if not u75 then nil else u75.current

			if v123 == nil then
				return
			end

			local v124 = createScrollIntervalPerformanceTracker(scrollPerformanceIntervalName, v123)
			local connection = v123:GetPropertyChangedSignal("CanvasPosition"):Connect(v124.onScrollTick)

			return function() -- line: 363
				-- upvalues: connection (copy), v124 (copy)
				connection:Disconnect()
				v124.cleanup()
			end
		end, {
			t2.scrollPerformanceIntervalName,
			u75
		})
	end

	local v106 = React.useCallback(function() -- line: 370
		-- upvalues: v71 (copy)
		v71.current:fire()
	end)

	local function u107() -- line: 375
		-- upvalues: v83 (copy), FFlagLuaAppChartsStickyHeader (copy), v82 (copy), omniFeedItems (copy), v68 (copy), getNumItemsForRows (copy), v45 (copy), v77 (copy), v84 (copy)
		if v83 < #if not FFlagLuaAppChartsStickyHeader then omniFeedItems else v82 then
			local v126 = if not v68 then v83 + getNumItemsForRows(if not FFlagLuaAppChartsStickyHeader then omniFeedItems else v82, v83 + 1, v45, v77) else #if not FFlagLuaAppChartsStickyHeader then omniFeedItems else v82

			v84(v126)

			return true
		end

		return false
	end

	React.useEffect(function() -- line: 399
		-- upvalues: v77 (copy), u107 (ref)
		if not v77 then
			u107()
		end
	end, {
		omniFeedItems,
		v77
	})

	if DiscoveryAppLaunchTracker.isEnabled() and DiscoveryAppLaunchTracker.default then
		DiscoveryAppLaunchTracker.default:trackFeedRender()
		DiscoveryAppLaunchTracker.default:trackNumFeedItems(v83)
	end

	return Roact.createElement(RefreshScrollingFrameWithLoadMore, {
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0),
		CanvasSize = UDim2.new(1, 0, 0, 0),
		BackgroundColor3 = BackgroundColor,
		BackgroundTransparency = PageBackgroundTransparency,
		BorderSizePixel = 0,
		ScrollBarThickness = if not t2.scrollBarThickness then v91 else t2.scrollBarThickness,
		onLoadMore = function() -- line: 420
			-- upvalues: u107 (ref), Promise (copy), t2 (copy)
			if u107() then
				return Promise.reject()
			end

			local loadNext = t2.loadNext

			if loadNext then
				return loadNext()
			end

			return Promise.resolve()
		end,
		refresh = if not FFlagLuaAppGameCarouselAmpUpsellAction then v101 else v102,
		parentAppPage = pageContext,
		onAbsoluteSizeChangedCallback = t2.onAbsoluteSizeChanged,
		onCanvasSizeChangedCallback = v106,
		onCanvasPositionChangedCallback = v106,
		useAutomaticSizeContentFrame = true,
		[Roact.Ref] = if not FFlagLuaAppLayoutParamsInContext then u75 else v78,
		createEndOfScrollElement = t2.createEndOfScrollElement,
		onScrollDirectionChanged = t2.onScrollDirectionChanged,
		ScrollingEnabled = v76,
		onAbsoluteContentSizeChanged = if not FFlagSearchOmniAutocompletePage then nil else t2.onAbsoluteContentSizeChanged,
		loadMoreButtonText = if not t2.loadMoreButtonText or (not t2.hasNextPage or t2.loadNext == nil) then nil else t2.loadMoreButtonText,
		canvasTopPadding = if not FFlagAppIaScrollAway then nil else t2.canvasTopPadding,
		shouldExtendIntoSafeArea = if not FFlagExtendScrollingFramesBySafeInsets then nil else {
			left = false,
			top = false,
			right = true,
			bottom = true
		}
	}, {
		OmniFeed = React.createElement(OmniFeedItemsContainer, {
			omniFeedItems = omniFeedItems,
			pageContext = pageContext,
			sduiContext = sduiContext,
			impressionsTag = impressionsTag,
			numberOfItemsToBeRendered = v83,
			topMargin = v96,
			bottomMargin = v98,
			layoutPadding = v95.layoutPadding,
			onItemsUpdatedSignalRef = v71,
			refreshSignalRef = v72,
			scrollingFrameRef = u75,
			defaultContainerSize = t2.defaultContainerSize,
			sortsData = v104,
			hasNextPage = t2.hasNextPage,
			omniFeedPageSection = t2.omniFeedPageSection,
			enableRelativeGui = t2.enableRelativeGui,
			appCompositionEnabled = not not FFlagLuaAppCompositionAlways or t2.appCompositionEnabled,
			contentTag = t2.contentTag,
			onTileImageLoaded = if not FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone then nil else t2.onTileImageLoaded,
			videoPlaybackContext = if not FFlagLuaAppHomeTouchAutoplay then nil else t2.videoPlaybackContext,
			refreshFeed = if not FFlagLuaAppGameCarouselAmpUpsellAction or pageContext ~= AppPage.Home then nil else v102,
			defaultFocusRef = if not FFlagLuaAppsDefaultSelection then nil else t2.defaultFocusRef
		}),
		OmniFeedImpressionsDetector = React.createElement(OmniFeedImpressionsDetector, {
			onItemsUpdatedSignal = v71.current,
			impressionsTag = impressionsTag,
			omniFeedItems = omniFeedItems,
			eventContext = t2.analyticsContext
		}),
		ViewportVideoAutoplaySync = if not FFlagLuaAppHomeTouchAutoplay or (not t2.videoPlaybackContext or not t2.videoPlaybackContext.viewportVideoAutoplayController) then nil else React.createElement(ViewportVideoAutoplaySync, {
			viewportAutoplayController = t2.videoPlaybackContext.viewportVideoAutoplayController,
			scrollingFrameRef = u75
		}),
		ScrollDetector = if not t2.sendScrollEvent and (not FFlagLuaAppHomeTouchAutoplay or not t2.onScrollStart and not t2.onScrollSettled) then nil else React.createElement(ScrollDetector, {
			scrollingFrameRef = u75,
			sendScrollEvent = t2.sendScrollEvent,
			onScrollStart = if not FFlagLuaAppHomeTouchAutoplay then nil else t2.onScrollStart,
			onScrollSettled = if not FFlagLuaAppHomeTouchAutoplay then nil else t2.onScrollSettled
		})
	})
end
