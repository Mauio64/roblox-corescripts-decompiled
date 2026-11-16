local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local signal = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Signal
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local Promise = require(CorePackages.Packages.Promise)
local useUiModeInfo = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useUiModeInfo
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums")
local uiMode = RobloxAppEnums.UiMode
local appPage = RobloxAppEnums.AppPage
local useLastInputMode = require("@luauforge/bundled/eeo").useLastInputMode
local module2 = require("@luauforge/bundled/cyO")
local omniFeedTypes = module2.OmniFeedTypes
local omniFeedConstants = module2.OmniFeedConstants
local viewportVideoAutoplaySync = require("@luauforge/bundled/fZd").ViewportVideoAutoplaySync
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useAnimateScrollViewToSelection = require("@game/CorePackages/Workspace/Packages/AppBlox").useAnimateScrollViewToSelection
local scrollDetector = require("@luauforge/bundled/hEV").ScrollDetector

local createScrollIntervalPerformanceTracker = require("@luauforge/bundled/fvL").createScrollIntervalPerformanceTracker
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").useAppPolicy
local discoveryAppLaunchTracker = require("@luauforge/bundled/hEX").DiscoveryAppLaunchTracker
local isSduiGameOmniFeedItem = require("@luauforge/bundled/dAU").isSduiGameOmniFeedItem

local omniFeedImpressionsDetector = require("@luauforge/bundled/dpZ").Modules.Personalization.OmniFeed.OmniFeedImpressionsDetector

local fFlagAppThemeHalloween2026HomeBackground = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAppThemeHalloween2026HomeBackground
local module3 = require("@luauforge/bundled/fzH")

local module4 = require("@luauforge/bundled/hEE")
local useThemeBackground = require("@luauforge/bundled/eeu").useThemeBackground
local module5 = require("@luauforge/bundled/edf")
local module6 = require("@luauforge/bundled/hEY")
local module7 = require("@luauforge/bundled/dwA")

local module8 = require("@luauforge/bundled/hEZ")

local module9 = require("@luauforge/bundled/hFc")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")

local fFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local fFlagLuaAppLayoutParamsInContext = SharedFlags.FFlagLuaAppLayoutParamsInContext
local fFlagLuaAppScrollTelemetryIntegration = SharedFlags.FFlagLuaAppScrollTelemetryIntegration
local fFlagExtendScrollingFramesBySafeInsets = SharedFlags.FFlagExtendScrollingFramesBySafeInsets
local fFlagLuaAppCompositionAlways = SharedFlags.FFlagLuaAppCompositionAlways
local fFlagEnableSplitPane = SharedFlags.FFlagEnableSplitPane

local splitPaneStore = if fFlagEnableSplitPane then require("@luauforge/bundled/dFR").SplitPaneStore else nil

local defineFastInt = game:DefineFastInt("LuaAppOmniFeedInitialNumRows", 6)
local defineFastInt2 = game:DefineFastInt("LuaAppOmniFeedLoadNumRows", 3)

local fStringLuaAppSortsWithDividers = SharedFlags.FStringLuaAppSortsWithDividers

local v5 = {}

if SharedFlags.FFlagLuaAppUseSortsWithDividersFString then
	for k in fStringLuaAppSortsWithDividers:gmatch("(%w+)") do
		v5[k] = true
	end
end

local v6 = game:DefineFastInt("LuaAppOmniFeedScrollAnimDurationMs", 400) / 1000

local v7 = {}

local function isGameTreatmentType(p2, p3)
	return p2 == omniFeedTypes.HomeGameGrid
		or (p2 == omniFeedTypes.Carousel or (p2 == omniFeedTypes.SearchGameGrid or isSduiGameOmniFeedItem(p2, p3)))
end

local function getNumItemsForRows(list, p2, defineFastInt3, p3)
	local count = 0
	local total = 0

	for i = p2, #list do
		local item = list[i]

		local numberOfRows = item and item.treatmentProps and item.treatmentProps.numberOfRows or 1
		local v8 = numberOfRows == -1 and 1 or numberOfRows

		count += 1
		total += v8
		local topicId = nil

		if item then
			if item.treatmentProps and item.treatmentProps.topicId then
				topicId = item.treatmentProps.topicId
			elseif item.itemId and item.itemId.topicId then
				topicId = item.itemId.topicId
			end
		end

		if defineFastInt3 <= total then
			return count
		end

		if not p3 then
			continue
		end

		local treatmentType = item.treatmentType

		if
			treatmentType == omniFeedTypes.HomeGameGrid
			or treatmentType == omniFeedTypes.Carousel
			or treatmentType == omniFeedTypes.SearchGameGrid
			or isSduiGameOmniFeedItem(treatmentType, topicId)
		then
			break
		end
	end

	return count
end

return function(props)
	local v8 = useStyle()
	local v9 = useAppPolicy(function(p2)
		return p2.useGridPageLayout()
	end)

	local v10 = useAppPolicy(function(p2)
		return p2.getMountAllOmniFeedItems()
	end)

	local v11 = useUiModeInfo().uiMode == uiMode.TenFoot
	local v12 = v9 and not v11
	local v13

	if fFlagEnableSplitPane then
		v13 = SignalsReact.useSignalState(splitPaneStore.getStore().getIsSplitPaneCollapsedOrNotActive)
	else
		v13 = false
	end

	local ref = React.useRef(signal.new())
	local ref2 = React.useRef(signal.new())
	local ref3 = React.useRef(0)
	local ref4 = React.useRef(false)
	local v14 = if not fFlagLuaAppLayoutParamsInContext then props.scrollingFrameRef else nil
	local v15 = useLastInputMode() == "Cursor"
	local v16 = props.shouldStopAfterOneGameSort and not v10
	local v17

	if fFlagLuaAppLayoutParamsInContext then
		v14 = React.useRef(nil)

		local state, setState = React.useState(nil)

		if type(props.scrollingFrameRef) == "table" then
			v14 = props.scrollingFrameRef
		end

		v17 = React.useCallback(function(current)
			v14.current = current
			setState(current)

			if type(props.scrollingFrameRef) == "function" then
				props.scrollingFrameRef(current)
			end
		end, { props.scrollingFrameRef })
	end

	local v18 = React.useMemo(function()
		local omniFeedItems = {}

		for k, omniFeedItem in props.omniFeedItems do
			if omniFeedItem.pageSection == props.omniFeedPageSection then
				table.insert(omniFeedItems, omniFeedItem)
			end
		end

		return omniFeedItems
	end, { props.omniFeedItems, props.omniFeedPageSection })

	local state, setState = React.useState(function()
		if v10 then
			return #v18
		end

		return getNumItemsForRows(v18, 1, defineFastInt, v16)
	end)

	local pageContext = props.pageContext
	local impressionsTag = props.impressionsTag
	local omniFeedItems = props.omniFeedItems

	local theme = v8.Theme
	local color = theme.BackgroundDefault.Color
	local transparency = theme.BackgroundDefault.Transparency
	local v19 = v12 and 4 or 0
	local v20 = useDesignTokens()

	local backgroundColor = v20.LuaApps.App.Page.BackgroundColor
	local v21 = v20.LuaApps.App.Page.BackgroundTransparency

	if fFlagAppThemeHalloween2026HomeBackground then
		v21 = (if module4 then useThemeBackground() ~= nil else React.useContext(module3) ~= nil)
			and pageContext == appPage.Home
			and 1
			or v21
	end

	local v22 = React.useMemo(function()
		return v20.LuaApps.HomeOmniFeed.getLayoutSpacing(v12)
	end, { v12, v20 })

	local topPadding = props.topPadding or v22.topMargin
	local v23 = not props.loadMoreButtonText and 80 or v20.Size.Size_1200
	local bottomPadding = props.bottomPadding or v23

	local v24 = useSelector(function(p2)
		return p2.Personalization.OmniItemsGlobalLayoutData
	end)

	local v25 = v24
		and (v24[omniFeedConstants.GlobalLayoutDataKeys.JYFRefresh] == "true" or v24[omniFeedConstants.GlobalLayoutDataKeys.JYFRefresh] == true)

	local v26 = React.useCallback(function(p2)
		ref3.current = tick()
		ref2.current:fire()
		return props.refresh(p2 or omniFeedConstants.OmniRecommendationsRequestIntent.ManualRefresh)
	end)

	React.useEffect(function()
		local eventConnection

		if v25 then
			eventConnection = module6.Event:Connect(function()
				if ref4.current then
					return
				end

				local v28 = module9 - (tick() - ref3.current)

				if v28 < 0 then
					ref4.current = false

					if v14.current then
						local y = v14.current.CanvasPosition.Y
						local height = module7.JoinYourFriendsTile.Height

						if y >= 0 and y <= height then
							v26(omniFeedConstants.OmniRecommendationsRequestIntent.FriendPresenceChange)
						end
					end
				else
					ref4.current = true
					task.delay(v28, function()
						ref4.current = false

						if v14.current then
							local y = v14.current.CanvasPosition.Y
							local height = module7.JoinYourFriendsTile.Height

							if y >= 0 and y <= height then
								v26(omniFeedConstants.OmniRecommendationsRequestIntent.FriendPresenceChange)
							end
						end
					end)
				end
			end)
		else
			eventConnection = nil
		end

		return function()
			if eventConnection then
				eventConnection:Disconnect()
				eventConnection = nil
			end
		end
	end, { props.refresh })

	local v27 = useSelector(function(p2)
		return p2.OmniRecommendations[pageContext]
	end)

	local sorts = v27 and v27.sorts or v7

	local sduiContext = props.sduiContext

	useAnimateScrollViewToSelection(v14, v6)

	if fFlagLuaAppScrollTelemetryIntegration then
		React.useEffect(function()
			local scrollPerformanceIntervalName = props.scrollPerformanceIntervalName

			if scrollPerformanceIntervalName == nil then
				return
			end

			local current = if v14 then v14.current else nil

			if current == nil then
				return
			end

			local scrollIntervalPerformanceTracker = createScrollIntervalPerformanceTracker(
				scrollPerformanceIntervalName,
				current
			)
			local canvasPositionChangedConnection = current:GetPropertyChangedSignal("CanvasPosition"):Connect(scrollIntervalPerformanceTracker.onScrollTick)
			return function()
				canvasPositionChangedConnection:Disconnect()
				scrollIntervalPerformanceTracker.cleanup()
			end
		end, { props.scrollPerformanceIntervalName, v14 })
	end

	local v28 = React.useCallback(function()
		ref.current:fire()
	end)

	local function fn(): boolean
		if not (state < #v18) then
			return false
		end

		local v29 = if v10 then #v18 else state + getNumItemsForRows(v18, state + 1, defineFastInt2, v16)

		setState(v29)
		return true
	end

	React.useEffect(function()
		if not v16 then
			fn()
		end
	end, { omniFeedItems, v16 })

	if discoveryAppLaunchTracker.isEnabled() and discoveryAppLaunchTracker.default then
		discoveryAppLaunchTracker.default:trackFeedRender()
		discoveryAppLaunchTracker.default:trackNumFeedItems(state)
	end

	local createElement = Roact.createElement
	local v30 = {}
	v30.Position = UDim2.new(0, 0, 0, 0)
	v30.Size = UDim2.new(1, 0, 1, 0)
	v30.CanvasSize = UDim2.new(1, 0, 0, 0)
	v30.BackgroundColor3 = backgroundColor
	v30.BackgroundTransparency = v21
	v30.BorderSizePixel = 0

	if props.scrollBarThickness then
		v19 = props.scrollBarThickness
	end

	v30.ScrollBarThickness = v19
	function v30.onLoadMore()
		if fn() then
			return Promise.reject()
		end

		local loadNext = props.loadNext

		if loadNext then
			return loadNext()
		end

		return Promise.resolve()
	end

	v30.refresh = v26
	v30.parentAppPage = pageContext
	v30.onAbsoluteSizeChangedCallback = props.onAbsoluteSizeChanged
	v30.onCanvasSizeChangedCallback = v28
	v30.onCanvasPositionChangedCallback = v28
	v30.useAutomaticSizeContentFrame = true
	local ref5 = Roact.Ref

	if not fFlagLuaAppLayoutParamsInContext then
		v17 = v14
	end

	v30[ref5] = v17
	v30.createEndOfScrollElement = props.createEndOfScrollElement
	v30.onScrollDirectionChanged = props.onScrollDirectionChanged
	v30.ScrollingEnabled = v15
	v30.onAbsoluteContentSizeChanged = props.onAbsoluteContentSizeChanged
	local v31 = if props.loadMoreButtonText and props.hasNextPage and props.loadNext ~= nil then props.loadMoreButtonText else nil
	v30.loadMoreButtonText = v31

	local v32 = if fFlagAppIaScrollAway then props.canvasTopPadding else nil
	v30.canvasTopPadding = v32
	v30.shouldExtendIntoSafeArea = fFlagExtendScrollingFramesBySafeInsets and {
		left = false,
		top = false,
		right = not fFlagEnableSplitPane or v13,
		bottom = true
	} or nil

	local createElement2 = React.createElement
	local v34 = {
		omniFeedItems = omniFeedItems,
		pageContext = pageContext,
		sduiContext = sduiContext,
		impressionsTag = impressionsTag,
		numberOfItemsToBeRendered = state,
		topMargin = topPadding,
		bottomMargin = bottomPadding,
		layoutPadding = v22.layoutPadding,
		onItemsUpdatedSignalRef = ref,
		refreshSignalRef = ref2,
		scrollingFrameRef = v14,
		defaultContainerSize = props.defaultContainerSize,
		sortsData = sorts,
		hasNextPage = props.hasNextPage,
		omniFeedPageSection = props.omniFeedPageSection,
		enableRelativeGui = props.enableRelativeGui,
		appCompositionEnabled = fFlagLuaAppCompositionAlways and true or props.appCompositionEnabled,
		contentTag = props.contentTag,
		videoPlaybackContext = props.videoPlaybackContext,
		refreshFeed = 0,
		defaultFocusRef = 0
	}
	local v35 = if pageContext == appPage.Home then v26 else nil
	v34.refreshFeed = v35
	v34.defaultFocusRef = props.defaultFocusRef
	local children = {
		OmniFeed = createElement2(module8, v34),
		OmniFeedImpressionsDetector = React.createElement(omniFeedImpressionsDetector, {
			onItemsUpdatedSignal = ref.current,
			impressionsTag = impressionsTag,
			omniFeedItems = omniFeedItems,
			eventContext = props.analyticsContext
		}),
		ViewportVideoAutoplaySync = 0,
		ScrollDetector = 0
	}

	local v36 = if props.videoPlaybackContext and props.videoPlaybackContext.viewportVideoAutoplayController then React.createElement(viewportVideoAutoplaySync, {
		viewportAutoplayController = props.videoPlaybackContext.viewportVideoAutoplayController,
		scrollingFrameRef = v14
	}) else nil
	children.ViewportVideoAutoplaySync = v36

	local v37 = if props.sendScrollEvent or props.onScrollStart or props.onScrollSettled then React.createElement(scrollDetector, {
		scrollingFrameRef = v14,
		sendScrollEvent = props.sendScrollEvent,
		onScrollStart = props.onScrollStart,
		onScrollSettled = props.onScrollSettled
	}) else nil
	children.ScrollDetector = v37
	return createElement(module5, v30, children)
end
