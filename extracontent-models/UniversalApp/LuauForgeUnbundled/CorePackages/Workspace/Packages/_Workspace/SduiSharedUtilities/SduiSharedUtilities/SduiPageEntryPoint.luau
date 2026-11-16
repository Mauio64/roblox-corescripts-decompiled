local CoreGui = game:GetService("CoreGui")

local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/ReactRoblox")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/Foundation")
local loading = Foundation.Loading
local useTokens = Foundation.Hooks.useTokens
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/ReactFocusNavigation")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/RoactUtils").Hooks.RoactRodux.useDispatch
local navigateBack = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/NavigationRodux").Thunks.NavigateBack
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/RobloxAppNavigation").NavigationCommands else nil

local useCloseWithBackButton = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/AppBlox").useCloseWithBackButton
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SignalsReact")
local getSduiComponentWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiCoreSystem").getSduiComponentWrapper
local compositionTags = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/AppComposition").CompositionTags

local getSduiApiStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/getSduiApiStore")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiLoadTimer")
local SduiPageNavigationHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiPageNavigationHeader")
local useCreateClientBindingSduiContext = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/useCreateClientBindingSduiContext")
local navButtonType = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiIntegrationTypes").NavButtonType
local SduiPageErrorState = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiPageErrorState")
local usePageEntrySnackbar = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/usePageEntrySnackbar")
local useComponentLifecycleTiming = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/hooks/useComponentLifecycleTiming")
local useLocalAnalyticsData = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/hooks/useLocalAnalyticsData")
local useStatefulRef = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/hooks/useStatefulRef")
local useComponentConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/hooks/useComponentConfig")
local useUiStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/hooks/useUiStatus")
local useDataUpdatedTimestamp = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/hooks/useDataUpdatedTimestamp")
local uiStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiIntegrationTypes").UiStatus
local snackbar = Foundation.Snackbar
local fFlagLuaAppSduiPageEntryPointSnackbar = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagLuaAppSduiPageEntryPointSnackbar
local fFlagSduiPageEntryUseSharedHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagSduiPageEntryUseSharedHooks
local fFlagLuaAppMediaGalleryGamepadSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagLuaAppMediaGalleryGamepadSupport
local fFlagSduiPageEntryPointResolvedSlot = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagSduiPageEntryPointResolvedSlot
local fFlagSduiSrpScrollAway = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagSduiSrpScrollAway
local fFlagAppThemeHalloween2026HomeBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagAppThemeHalloween2026HomeBackground
local fFlagSduiVerticalFeedScrollTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagSduiVerticalFeedScrollTelemetry
local fFlagLuaAppSduiVideoThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagLuaAppSduiVideoThumbnail
local fFlagLuaAppOneByTwoHoverIdleAutoplay = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagLuaAppOneByTwoHoverIdleAutoplay

local function SduiPageEntryPoint(props, p2)
	local appPage = props.appPage
	local configKey = props.configKey or appPage
	local formatted = `SduiPageEntryPoint-{configKey}`
	local pageTimer = props.pageTimer

	local v5 = useTokens()
	local v6 = useDispatch()
	local v7

	if fFlagSduiPageEntryUseSharedHooks then
		v7 = useComponentConfig(configKey, props.identifier)
	else
		local v8 = React.useCallback(function(p3)
			return getSduiApiStore().getRootConfig(configKey, p3, props.identifier)
		end, { configKey, props.identifier })
		v7 = SignalsReact.useSignalState(v8)
	end

	local v8 = React.useCallback(function(p3)
		return getSduiApiStore().getTitle(configKey, p3)
	end, { configKey })
	local v9 = SignalsReact.useSignalState(v8) or props.pageTitle

	local v10 = useUiStatus(configKey)
	local v11 = v10 == uiStatus.Loading
	local v12 = v10 == uiStatus.Error

	local v13 = fFlagSduiPageEntryPointResolvedSlot

	if v13 then
		v13 = not (props.resolvedSlot == nil) and not (v11 or v12)
	end

	if fFlagSduiPageEntryUseSharedHooks then
		useComponentLifecycleTiming(pageTimer, typeof(v7) == "table" or fFlagSduiPageEntryPointResolvedSlot and v13)
	else
		React.useEffect(function()
			if pageTimer then
				pageTimer.logComponentMounted()
			end
		end, { pageTimer })

		local function fn()
			if pageTimer and (v7 or fFlagSduiPageEntryPointResolvedSlot and v13) then
				pageTimer.logComponentReady()
			end
		end

		React.useEffect(fn, { pageTimer, v7, if fFlagSduiPageEntryPointResolvedSlot then v13 else nil })
	end

	local v14

	if fFlagSduiPageEntryUseSharedHooks then
		v14 = useLocalAnalyticsData(configKey, appPage, props.additionalAnalyticsData)
	else
		v14 = React.useMemo(function()
			return { configKey = configKey, appPage = appPage }
		end, { configKey, appPage })
	end

	local state, setState

	if fFlagSduiPageEntryUseSharedHooks then
		state, setState = useStatefulRef(p2)
	else
		state, setState = React.useState(nil)
		local useRef = React.useRef(state)
		useRef.current = state
	end

	local v15 = React.useCallback(function()
		if props.onCloseActivated then
			props.onCloseActivated()
		elseif fFlagSignalsNavP3Dispatch then
			navigationCommands.back()
		else
			v6(navigateBack())
		end
	end, { v6, props.onCloseActivated })

	local v16, v17 = ReactFocusNavigation.useMostRecentOrDefaultFocusBehavior(setState)
	local v18 = useCloseWithBackButton(v17, v15)

	local v19 = if fFlagLuaAppSduiPageEntryPointSnackbar then usePageEntrySnackbar(configKey) else nil

	local v20 = useDataUpdatedTimestamp(configKey, props.identifier)

	local state2, setState2 = React.useState(nil)

	local routeName = props.routeName
	local scrollAway = props.scrollAway
	local v24

	if fFlagLuaAppSduiVideoThumbnail or fFlagLuaAppOneByTwoHoverIdleAutoplay then
		v24 = props.videoPlaybackContext
	end

	local v25 = useCreateClientBindingSduiContext(appPage, state2, nil, v20, configKey, nil, routeName, scrollAway, v24)
	local v26 = state == nil
	local useMemo = React.useMemo
	local function fn()
		if v7 == nil then
			return nil
		end

		local sduiComponentWrapper = getSduiComponentWrapper(v7)
		local createElement = React.createElement
		local v27 = {
			debugName = formatted,
			componentConfig = v7,
			sduiContext = v25,
			localAnalyticsData = v14,
			extraLocalProps = 0
		}

		local v28 = {
			pageBottomPadding = props.pageBottomPadding,
			feedTopMargin = props.feedTopMargin,
			scrollingFrameRef = props.scrollingFrameRef,
			scrollToSelectionRevealOnly = 0,
			onScrollDirectionChanged = 0,
			defaultContentTag = 0,
			defaultStickyContentTag = 0,
			scrollPerformanceIntervalName = 0,
			backgroundStyle = 0
		}

		local v29 = if fFlagLuaAppMediaGalleryGamepadSupport then props.scrollToSelectionRevealOnly else nil
		v28.scrollToSelectionRevealOnly = v29

		local v30 = if fFlagSduiSrpScrollAway then props.onScrollDirectionChanged else nil
		v28.onScrollDirectionChanged = v30
		v28.defaultContentTag = props.contentTag
		v28.defaultStickyContentTag = props.stickyContentTag

		local v31 = if fFlagSduiVerticalFeedScrollTelemetry then props.scrollPerformanceIntervalName else nil
		v28.scrollPerformanceIntervalName = v31

		local v32 = if fFlagAppThemeHalloween2026HomeBackground then props.feedBackgroundStyle else nil
		v28.backgroundStyle = v32
		v27.extraLocalProps = v28
		return createElement(sduiComponentWrapper, v27)
	end

	local contentTag = props.contentTag
	local stickyContentTag = props.stickyContentTag
	local pageBottomPadding = props.pageBottomPadding
	local feedTopMargin = props.feedTopMargin
	local scrollingFrameRef = props.scrollingFrameRef
	local scrollToSelectionRevealOnly = if fFlagLuaAppMediaGalleryGamepadSupport then props.scrollToSelectionRevealOnly else nil
	local onScrollDirectionChanged = if fFlagSduiSrpScrollAway then props.onScrollDirectionChanged else nil
	local scrollPerformanceIntervalName = if fFlagSduiVerticalFeedScrollTelemetry then props.scrollPerformanceIntervalName else nil
	local v29 = if fFlagAppThemeHalloween2026HomeBackground then props.feedBackgroundStyle else nil
	local v30 = useMemo(fn, {
		v7,
		formatted,
		v25,
		v14,
		contentTag,
		stickyContentTag,
		pageBottomPadding,
		feedTopMargin,
		scrollingFrameRef,
		scrollToSelectionRevealOnly,
		onScrollDirectionChanged,
		scrollPerformanceIntervalName,
		v29
	})

	local v31 = props.scrollingFrameRef ~= nil

	local createElement = React.createElement
	local layoutTagsByTag = {
		[React.Tag] = props.layoutTag,
		Size = UDim2.new(1, 0, v31 and 0 or 1, 0)
	}
	local v33 = if v31 then Enum.AutomaticSize.Y else nil
	layoutTagsByTag.AutomaticSize = v33
	layoutTagsByTag.BorderSizePixel = 0
	layoutTagsByTag.BackgroundTransparency = not props.backgroundStyle and 0
		or props.backgroundStyle.Transparency
	local v34 = if props.backgroundStyle then props.backgroundStyle.Color3 else v5.Color.Surface.Surface_0.Color3
	layoutTagsByTag.BackgroundColor3 = v34

	layoutTagsByTag.ref = v18
	layoutTagsByTag.ClipsDescendants = props.clipsDescendantsOverride == nil
		or props.clipsDescendantsOverride
	local v35 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		}),
		PageTopPadding = 0,
		PageHeader = 0,
		PageBody = 0,
		SnackbarPortal = 0
	}

	local v36 = if props.pageTopPadding and props.pageTopPadding > 0 then React.createElement("UIPadding", {
		PaddingTop = UDim.new(0, props.pageTopPadding)
	}) else nil
	v35.PageTopPadding = v36

	local v37 = if not (v26 or not props.includeNavigationHeaderBar) then React.createElement(SduiPageNavigationHeader, {
		title = v9,
		contentTag = props.headerContentTag or compositionTags.ContentRegion.Header,
		layoutOrder = 1,
		renderUtilities = props.renderUtilities,
		navButtonType = props.navButtonType or navButtonType.back,
		closeCallback = v15,
		scrollAwayHeader = props.scrollAway ~= nil
	}) else nil
	v35.PageHeader = v37
	local v38

	if v11 then
		if props.loadingSlot then
			v38 = props.loadingSlot
		else
			v38 = React.createElement(
				Foundation.View,
				{ Size = UDim2.new(1, 0, 1, 0) },
				React.createElement(loading, {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5)
				})
			)
		end
	elseif v12 then
		if props.errorSlot then
			v38 = props.errorSlot
		else
			v38 = React.createElement(SduiPageErrorState, { refresh = props.refresh })
		end
	else
		local createElement2 = React.createElement
		local v40 = {
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, v31 and 0 or 1, 0),
			AutomaticSize = 0,
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			ref = 0
		}
		local v41 = if v31 then Enum.AutomaticSize.Y else nil
		v40.AutomaticSize = v41

		v40.ref = setState2

		local v43 = if not v31 then React.createElement("UIFlexItem", {
			FlexMode = Enum.UIFlexMode.Fill
		}) else nil

		if v26 then
			v30 = nil
		elseif fFlagSduiPageEntryPointResolvedSlot and props.resolvedSlot then
			v30 = props.resolvedSlot
		end

		v38 = createElement2("Frame", v40, { UIFlexItem = v43, Content = v30 })
	end

	v35.PageBody = v38

	local v39 = if v19 and v19.snackbarConfig then ReactRoblox.createPortal({
		SduiSnackbarScreenGui = React.createElement(
			"ScreenGui",
			{
				DisplayOrder = props.snackbarPortalLayoutOrder,
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
				IgnoreGuiInset = true
			},
			{
				Snackbar = React.createElement(snackbar, {
					title = v19.snackbarConfig.title,
					icon = v19.snackbarConfig.icon,
					Position = UDim2.new(0.5, 0, 1, -v5.Padding.XLarge),
					AnchorPoint = Vector2.new(0.5, 1),
					AutomaticSize = Enum.AutomaticSize.XY,
					onClose = v19.onDismiss
				})
			}
		)
	}, CoreGui) else nil
	v35.SnackbarPortal = v39
	return createElement("Frame", layoutTagsByTag, v35)
end

if fFlagSduiPageEntryUseSharedHooks then
	return React.memo(React.forwardRef(SduiPageEntryPoint))
end

return React.memo(SduiPageEntryPoint)
