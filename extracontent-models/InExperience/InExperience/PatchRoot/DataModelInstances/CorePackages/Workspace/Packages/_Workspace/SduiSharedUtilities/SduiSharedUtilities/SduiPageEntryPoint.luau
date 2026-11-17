local CoreGui = game:GetService("CoreGui")
local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local parent = SduiSharedUtilities.Parent
local ReactRoblox = require(parent.ReactRoblox)
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Loading = Foundation.Loading
local useTokens = Foundation.Hooks.useTokens
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local NavigationRodux = require(parent.NavigationRodux)
local NavigateBack = NavigationRodux.Thunks.NavigateBack
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local AppBlox = require(parent.AppBlox)
local useCloseWithBackButton = AppBlox.useCloseWithBackButton
local SignalsReact = require(parent.SignalsReact)
local SduiCoreSystem = require(parent.SduiCoreSystem)
local getSduiComponentWrapper = SduiCoreSystem.getSduiComponentWrapper
local AppComposition = require(parent.AppComposition)
local CompositionTags = AppComposition.CompositionTags

local getSduiApiStore = require(SduiSharedUtilities.getSduiApiStore)
require(SduiSharedUtilities.SduiLoadTimer)
local SduiPageNavigationHeader = require(SduiSharedUtilities.SduiPageNavigationHeader)
local useCreateClientBindingSduiContext = require(SduiSharedUtilities.useCreateClientBindingSduiContext)
local SduiIntegrationTypes = require(SduiSharedUtilities.SduiIntegrationTypes)
local NavButtonType = SduiIntegrationTypes.NavButtonType
local SduiPageErrorState = require(SduiSharedUtilities.SduiPageErrorState)
local usePageEntrySnackbar = require(SduiSharedUtilities.usePageEntrySnackbar)
local useComponentLifecycleTiming = require(SduiSharedUtilities.hooks.useComponentLifecycleTiming)
local useLocalAnalyticsData = require(SduiSharedUtilities.hooks.useLocalAnalyticsData)
local useStatefulRef = require(SduiSharedUtilities.hooks.useStatefulRef)
local useComponentConfig = require(SduiSharedUtilities.hooks.useComponentConfig)
local useUiStatus = require(SduiSharedUtilities.hooks.useUiStatus)
local useDataUpdatedTimestamp = require(SduiSharedUtilities.hooks.useDataUpdatedTimestamp)
local SduiIntegrationTypes2 = require(SduiSharedUtilities.SduiIntegrationTypes)
local UiStatus = SduiIntegrationTypes2.UiStatus
local Snackbar = Foundation.Snackbar
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppSduiPageEntryPointSnackbar = SharedFlags2.FFlagLuaAppSduiPageEntryPointSnackbar
local SharedFlags3 = require(parent.SharedFlags)
local FFlagSduiPageEntryUseSharedHooks = SharedFlags3.FFlagSduiPageEntryUseSharedHooks
local SharedFlags4 = require(parent.SharedFlags)
local FFlagLuaAppMediaGalleryGamepadSupport = SharedFlags4.FFlagLuaAppMediaGalleryGamepadSupport
local SharedFlags5 = require(parent.SharedFlags)
local FFlagSduiPageEntryPointResolvedSlot = SharedFlags5.FFlagSduiPageEntryPointResolvedSlot
local SharedFlags6 = require(parent.SharedFlags)
local FFlagAppThemeHalloween2026HomeBackground = SharedFlags6.FFlagAppThemeHalloween2026HomeBackground
local SharedFlags7 = require(parent.SharedFlags)
local FFlagSduiVerticalFeedScrollTelemetry = SharedFlags7.FFlagSduiVerticalFeedScrollTelemetry
local SharedFlags8 = require(parent.SharedFlags)
local FFlagLuaAppSduiVideoThumbnail = SharedFlags8.FFlagLuaAppSduiVideoThumbnail
local SharedFlags9 = require(parent.SharedFlags)
local FFlagLuaAppOneByTwoHoverIdleAutoplay = SharedFlags9.FFlagLuaAppOneByTwoHoverIdleAutoplay

local function SduiPageEntryPoint(props, p)
	local appPage = props.appPage
	local configKey = props.configKey or appPage
	local formatted = `SduiPageEntryPoint-{configKey}`
	local pageTimer = props.pageTimer

	local v = useTokens()
	local v2 = useDispatch()
	local componentConfig

	if FFlagSduiPageEntryUseSharedHooks then
		componentConfig = useComponentConfig(configKey, props.identifier)
	else
		local v3 = React.useCallback(function(p2)
			return getSduiApiStore().getRootConfig(configKey, p2, props.identifier)
		end, { configKey, props.identifier })
		componentConfig = SignalsReact.useSignalState(v3)
	end

	local v3 = React.useCallback(function(p2)
		return getSduiApiStore().getTitle(configKey, p2)
	end, { configKey })
	local title = SignalsReact.useSignalState(v3) or props.pageTitle

	local v4 = useUiStatus(configKey)
	local v5 = v4 == UiStatus.Loading
	local v6 = v4 == UiStatus.Error

	local v7 = FFlagSduiPageEntryPointResolvedSlot

	if v7 then
		if props.resolvedSlot == nil then
			v7 = false
		else
			v7 = not (v5 or v6)
		end
	end

	if FFlagSduiPageEntryUseSharedHooks then
		useComponentLifecycleTiming(
			pageTimer,
			typeof(componentConfig) == "table" or FFlagSduiPageEntryPointResolvedSlot and v7
		)
	else
		React.useEffect(function()
			if pageTimer then
				pageTimer.logComponentMounted()
			end
		end, { pageTimer })

		local useEffect = React.useEffect
		local function fn()
			if pageTimer and (componentConfig or FFlagSduiPageEntryPointResolvedSlot and v7) then
				pageTimer.logComponentReady()
			end
		end

		local v8

		if FFlagSduiPageEntryPointResolvedSlot then
			v8 = v7
		end

		useEffect(fn, { pageTimer, componentConfig, v8 })
	end

	local localAnalyticsData

	if FFlagSduiPageEntryUseSharedHooks then
		localAnalyticsData = useLocalAnalyticsData(configKey, appPage, props.additionalAnalyticsData)
	else
		localAnalyticsData = React.useMemo(function()
			return { configKey = configKey, appPage = appPage }
		end, { configKey, appPage })
	end

	local state, setState

	if FFlagSduiPageEntryUseSharedHooks then
		state, setState = useStatefulRef(p)
	else
		state, setState = React.useState(nil)
		local useRef = React.useRef(state)
		useRef.current = state
	end

	local closeCallback = React.useCallback(function()
		if props.onCloseActivated then
			props.onCloseActivated()
		elseif FFlagSignalsNavP3Dispatch then
			navigationCommands.back()
		else
			v2(NavigateBack())
		end
	end, { v2, props.onCloseActivated })

	local _, v8 = ReactFocusNavigation.useMostRecentOrDefaultFocusBehavior(setState)
	local ref = useCloseWithBackButton(v8, closeCallback)
	local v9

	if FFlagLuaAppSduiPageEntryPointSnackbar then
		v9 = usePageEntrySnackbar(configKey)
	end

	local v10 = useDataUpdatedTimestamp(configKey, props.identifier)

	local state2, setState2 = React.useState(nil)

	local routeName = props.routeName
	local scrollAway = props.scrollAway
	local v11

	if FFlagLuaAppSduiVideoThumbnail or FFlagLuaAppOneByTwoHoverIdleAutoplay then
		v11 = props.videoPlaybackContext
	end

	local sduiContext = useCreateClientBindingSduiContext(
		appPage,
		state2,
		nil,
		v10,
		configKey,
		nil,
		routeName,
		scrollAway,
		v11
	)
	local v12 = state == nil
	local useMemo = React.useMemo
	local function fn()
		if componentConfig == nil then
			return nil
		end

		local sduiComponentWrapper = getSduiComponentWrapper(componentConfig)
		local createElement = React.createElement
		local v13 = {
			debugName = formatted,
			componentConfig = componentConfig,
			sduiContext = sduiContext,
			localAnalyticsData = localAnalyticsData,
			extraLocalProps = 0
		}

		local extraLocalProps = {
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
		local scrollToSelectionRevealOnly

		if FFlagLuaAppMediaGalleryGamepadSupport then
			scrollToSelectionRevealOnly = props.scrollToSelectionRevealOnly
		end

		extraLocalProps.scrollToSelectionRevealOnly = scrollToSelectionRevealOnly

		extraLocalProps.onScrollDirectionChanged = props.onScrollDirectionChanged
		extraLocalProps.defaultContentTag = props.contentTag
		extraLocalProps.defaultStickyContentTag = props.stickyContentTag
		local scrollPerformanceIntervalName

		if FFlagSduiVerticalFeedScrollTelemetry then
			scrollPerformanceIntervalName = props.scrollPerformanceIntervalName
		end

		extraLocalProps.scrollPerformanceIntervalName = scrollPerformanceIntervalName
		local backgroundStyle

		if FFlagAppThemeHalloween2026HomeBackground then
			backgroundStyle = props.feedBackgroundStyle
		end

		extraLocalProps.backgroundStyle = backgroundStyle
		v13.extraLocalProps = extraLocalProps
		return createElement(sduiComponentWrapper, v13)
	end

	local contentTag = props.contentTag
	local stickyContentTag = props.stickyContentTag
	local pageBottomPadding = props.pageBottomPadding
	local feedTopMargin = props.feedTopMargin
	local scrollingFrameRef = props.scrollingFrameRef
	local scrollToSelectionRevealOnly

	if FFlagLuaAppMediaGalleryGamepadSupport then
		scrollToSelectionRevealOnly = props.scrollToSelectionRevealOnly
	end

	local onScrollDirectionChanged = props.onScrollDirectionChanged
	local scrollPerformanceIntervalName

	if FFlagSduiVerticalFeedScrollTelemetry then
		scrollPerformanceIntervalName = props.scrollPerformanceIntervalName
	end

	local v13

	if FFlagAppThemeHalloween2026HomeBackground then
		v13 = props.feedBackgroundStyle
	end

	local content = useMemo(fn, {
		componentConfig,
		formatted,
		sduiContext,
		localAnalyticsData,
		contentTag,
		stickyContentTag,
		pageBottomPadding,
		feedTopMargin,
		scrollingFrameRef,
		scrollToSelectionRevealOnly,
		onScrollDirectionChanged,
		scrollPerformanceIntervalName,
		v13
	})

	local v14 = props.scrollingFrameRef ~= nil

	local createElement = React.createElement
	local layoutTagsByTag = {
		[React.Tag] = props.layoutTag,
		Size = UDim2.new(1, 0, v14 and 0 or 1, 0)
	}
	local automaticSize

	if v14 then
		automaticSize = Enum.AutomaticSize.Y
	end

	layoutTagsByTag.AutomaticSize = automaticSize
	layoutTagsByTag.BorderSizePixel = 0
	layoutTagsByTag.BackgroundTransparency = not props.backgroundStyle and 0 or props.backgroundStyle.Transparency
	local backgroundColor

	if props.backgroundStyle then
		backgroundColor = props.backgroundStyle.Color3
	else
		backgroundColor = v.Color.Surface.Surface_0.Color3
	end

	layoutTagsByTag.BackgroundColor3 = backgroundColor

	layoutTagsByTag.ref = ref
	layoutTagsByTag.ClipsDescendants = props.clipsDescendantsOverride == nil or props.clipsDescendantsOverride
	local v15 = {
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
	local pageTopPadding

	if props.pageTopPadding and props.pageTopPadding > 0 then
		pageTopPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, props.pageTopPadding)
		})
	end

	v15.PageTopPadding = pageTopPadding
	local pageHeader

	if not (v12 or not props.includeNavigationHeaderBar) then
		pageHeader = React.createElement(SduiPageNavigationHeader, {
			title = title,
			contentTag = props.headerContentTag or CompositionTags.ContentRegion.Header,
			layoutOrder = 1,
			renderUtilities = props.renderUtilities,
			navButtonType = props.navButtonType or NavButtonType.back,
			closeCallback = closeCallback,
			scrollAwayHeader = props.scrollAway ~= nil
		})
	end

	v15.PageHeader = pageHeader
	local pageBody

	if v5 then
		if props.loadingSlot then
			pageBody = props.loadingSlot
		else
			pageBody = React.createElement(
				Foundation.View,
				{ Size = UDim2.new(1, 0, 1, 0) },
				React.createElement(Loading, {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5)
				})
			)
		end
	elseif v6 then
		if props.errorSlot then
			pageBody = props.errorSlot
		else
			pageBody = React.createElement(SduiPageErrorState, { refresh = props.refresh })
		end
	else
		local createElement2 = React.createElement
		local v16 = {
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, v14 and 0 or 1, 0),
			AutomaticSize = 0,
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			ref = 0
		}
		local automaticSize2

		if v14 then
			automaticSize2 = Enum.AutomaticSize.Y
		end

		v16.AutomaticSize = automaticSize2

		v16.ref = setState2
		local uiFlexItem

		if not v14 then
			uiFlexItem = React.createElement("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill })
		end

		if v12 then
			content = nil
		elseif FFlagSduiPageEntryPointResolvedSlot and props.resolvedSlot then
			content = props.resolvedSlot
		end

		pageBody = createElement2("Frame", v16, { UIFlexItem = uiFlexItem, Content = content })
	end

	v15.PageBody = pageBody
	local snackbarPortal

	if v9 and v9.snackbarConfig then
		snackbarPortal = ReactRoblox.createPortal({
			SduiSnackbarScreenGui = React.createElement(
				"ScreenGui",
				{
					DisplayOrder = props.snackbarPortalLayoutOrder,
					ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
					IgnoreGuiInset = true
				},
				{
					Snackbar = React.createElement(Snackbar, {
						title = v9.snackbarConfig.title,
						icon = v9.snackbarConfig.icon,
						Position = UDim2.new(0.5, 0, 1, -v.Padding.XLarge),
						AnchorPoint = Vector2.new(0.5, 1),
						AutomaticSize = Enum.AutomaticSize.XY,
						onClose = v9.onDismiss
					})
				}
			)
		}, CoreGui)
	end

	v15.SnackbarPortal = snackbarPortal
	return createElement("Frame", layoutTagsByTag, v15)
end

if FFlagSduiPageEntryUseSharedHooks then
	return React.memo(React.forwardRef(SduiPageEntryPoint))
end

return React.memo(SduiPageEntryPoint)
