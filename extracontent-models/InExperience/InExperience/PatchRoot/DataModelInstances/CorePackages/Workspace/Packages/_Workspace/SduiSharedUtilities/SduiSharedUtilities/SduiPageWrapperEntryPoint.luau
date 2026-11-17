local CoreGui = game:GetService("CoreGui")
local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local parent = SduiSharedUtilities.Parent
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local Foundation = require(parent.Foundation)
local Loading = Foundation.Loading
local Snackbar = Foundation.Snackbar
local useTokens = Foundation.Hooks.useTokens
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local NavigationRodux = require(parent.NavigationRodux)
local NavigateBack = NavigationRodux.Thunks.NavigateBack
local AppNavBar = require(parent.AppNavBar)
local VisibilityControl = AppNavBar.VisibilityControl
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
local SduiCoreSystem = require(parent.SduiCoreSystem)
local getSduiComponentWrapper = SduiCoreSystem.getSduiComponentWrapper
local AppPageShell = require(parent.AppPageShell)
local Page = AppPageShell.Page
local AppCommonLib = require(parent.AppCommonLib)
local Signal = AppCommonLib.Signal

local useCreateClientBindingSduiContext = require(SduiSharedUtilities.useCreateClientBindingSduiContext)
local SduiIntegrationTypes = require(SduiSharedUtilities.SduiIntegrationTypes)
local UiStatus = SduiIntegrationTypes.UiStatus
local SduiPageErrorState = require(SduiSharedUtilities.SduiPageErrorState)
require(SduiSharedUtilities.SduiLoadTimer)
local useLocalAnalyticsData = require(SduiSharedUtilities.hooks.useLocalAnalyticsData)
local useStatefulRef = require(SduiSharedUtilities.hooks.useStatefulRef)
local useComponentConfig = require(SduiSharedUtilities.hooks.useComponentConfig)
local useUiStatus = require(SduiSharedUtilities.hooks.useUiStatus)
local useDataUpdatedTimestamp = require(SduiSharedUtilities.hooks.useDataUpdatedTimestamp)
local useSduiPageContent = require(SduiSharedUtilities.hooks.useSduiPageContent)
local usePageEntrySnackbar = require(SduiSharedUtilities.usePageEntrySnackbar)

local SharedFlags2 = require(parent.SharedFlags)
local FFlagAppPageShellScrollToTopFocus = SharedFlags2.FFlagAppPageShellScrollToTopFocus
local SharedFlags3 = require(parent.SharedFlags)
local FFlagAppPageShellScrollTelemetry = SharedFlags3.FFlagAppPageShellScrollTelemetry
local SharedFlags4 = require(parent.SharedFlags)
local FFlagAppThemeHalloween2026HomeBackground = SharedFlags4.FFlagAppThemeHalloween2026HomeBackground

local function SduiPageWrapperEntryPoint(props, p)
	local appPage = props.appPage
	local configKey = props.configKey or appPage
	local formatted = `SduiPageWrapperEntryPoint-{configKey}`
	local v = useTokens()
	local v2 = useDispatch()

	local componentConfig = useComponentConfig(configKey, props.stickyIdentifier)

	local v3 = useUiStatus(configKey)
	local v4 = v3 == UiStatus.Loading
	local v5 = v3 == UiStatus.Error

	local localAnalyticsData = useLocalAnalyticsData(configKey, appPage, props.additionalAnalyticsData)
	local refreshSignal = React.useMemo(function()
		return Signal.new()
	end, {})
	local refresh = props.refresh
	local onRefresh = React.useCallback(function()
		refreshSignal:fire()

		if refresh then
			return refresh()
		end

		return nil
	end, { refreshSignal, refresh })

	local _, v6 = useStatefulRef(p)

	local v7 = React.useCallback(function()
		if props.onCloseActivated then
			props.onCloseActivated()
		elseif FFlagSignalsNavP3Dispatch then
			navigationCommands.back()
		else
			v2(NavigateBack())
		end
	end, { v2, props.onCloseActivated })

	local _, v8 = ReactFocusNavigation.useMostRecentOrDefaultFocusBehavior(v6)

	if FFlagAppPageShellScrollToTopFocus and props.handleBackButton == false then
		v7 = nil
	end

	local ref = useCloseWithBackButton(v8, v7)

	local v9 = usePageEntrySnackbar(configKey)

	local state, setState = React.useState(nil)
	local sduiContext = useCreateClientBindingSduiContext(
		appPage,
		state,
		nil,
		useDataUpdatedTimestamp(configKey, props.contentIdentifier),
		configKey,
		nil,
		props.routeName,
		props.scrollAway,
		props.videoPlaybackContext
	)

	local v10 = {
		configKey = configKey,
		contentIdentifier = props.contentIdentifier,
		contentMode = props.contentMode,
		sduiContext = sduiContext,
		localAnalyticsData = localAnalyticsData,
		debugName = formatted,
		pageTimer = props.pageTimer,
		refreshSignal = refreshSignal,
		defaultFocusRef = 0
	}
	local defaultFocusRef

	if FFlagAppPageShellScrollToTopFocus then
		defaultFocusRef = props.defaultFocusRef
	end

	v10.defaultFocusRef = defaultFocusRef
	local contentConfig = useSduiPageContent(v10)

	local localStickyHeaderSlot = props.localStickyHeaderSlot
	local stickyHeaderSlot = React.useMemo(function()
		local v11

		if not (props.stickyIdentifier == nil or componentConfig == nil) then
			local sduiComponentWrapper = getSduiComponentWrapper(componentConfig)
			v11 = React.createElement(sduiComponentWrapper, {
				debugName = `{formatted}-sticky`,
				componentConfig = componentConfig,
				sduiContext = sduiContext,
				localAnalyticsData = localAnalyticsData
			})
		end

		if localStickyHeaderSlot == nil and v11 == nil then
			return nil
		end

		local result = {}

		if localStickyHeaderSlot ~= nil then
			for _, v12 in localStickyHeaderSlot do
				table.insert(result, v12)
			end
		end

		if v11 ~= nil then
			table.insert(result, v11)
		end

		return result
	end, {
		props.stickyIdentifier,
		componentConfig,
		sduiContext,
		localAnalyticsData,
		formatted,
		localStickyHeaderSlot
	})

	local stateOverlay = nil

	if v4 then
		stateOverlay = props.loadingSlot
			or React.createElement(
				Foundation.View,
				{ tag = "size-full", ZIndex = 2 },
				React.createElement(Loading, {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5)
				})
			)
	elseif v5 then
		stateOverlay = props.errorSlot or React.createElement(SduiPageErrorState, {
			refresh = props.refresh
		})
	end

	local v11

	if stickyHeaderSlot == nil then
		v11 = false
	else
		v11 = next(stickyHeaderSlot) ~= nil
	end

	local contentTopPadding = props.feedTopMargin
	local stickyTopPadding

	if v11 then
		stickyTopPadding = props.stickyTopPadding or contentTopPadding
	end

	if v11 then
		contentTopPadding = props.stickyBottomPadding
	end

	local scrollAway = props.scrollAway
	local pageTopPadding = props.pageTopPadding
	local chrome = React.useMemo(function()
		local height = pageTopPadding or 0

		if height <= 0 then
			return nil
		end

		local liveHeightBinding

		if scrollAway then
			liveHeightBinding = scrollAway.headerHeightBinding
		end

		if liveHeightBinding == nil and scrollAway and scrollAway.scrollAwayHeight then
			local scrollAwayHeight = scrollAway.scrollAwayHeight
			liveHeightBinding = VisibilityControl.getHeaderBinding():map(function(p2: number)
				return p2 * scrollAwayHeight
			end)
		end

		local scrollAwayHeight

		if scrollAway then
			scrollAwayHeight = scrollAway.scrollAwayHeight
		end

		return {
			height = height,
			scrollAwayHeight = scrollAwayHeight,
			liveHeightBinding = liveHeightBinding
		}
	end, { pageTopPadding, scrollAway })

	local createElement = React.createElement
	local v12 = {
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		ref = setState
	}

	local v13 = {
		UIFlexItem = React.createElement("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill }),
		Content = 0,
		StateOverlay = 0
	}

	local createElement2 = React.createElement
	local v14 = {
		contentConfig = contentConfig,
		stickyHeaderSlot = stickyHeaderSlot,
		composition = props.composition,
		chrome = chrome,
		stickyBackgroundStyle = 0,
		onScrollToEnd = 0,
		onScrollToEndThreshold = 0,
		onRefresh = 0,
		appEventName = 0,
		contentTopPadding = 0,
		stickyTopPadding = 0,
		scrollPerformanceIntervalName = 0
	}
	local stickyBackgroundStyle

	if FFlagAppThemeHalloween2026HomeBackground then
		stickyBackgroundStyle = props.stickyBackgroundStyle or props.backgroundStyle
	else
		stickyBackgroundStyle = props.backgroundStyle
	end

	v14.stickyBackgroundStyle = stickyBackgroundStyle

	v14.onScrollToEnd = props.onScrollToEnd
	v14.onScrollToEndThreshold = props.onScrollToEndThreshold

	if not refresh then
		onRefresh = nil
	end

	v14.onRefresh = onRefresh
	v14.appEventName = appPage
	v14.contentTopPadding = contentTopPadding
	v14.stickyTopPadding = stickyTopPadding
	local scrollPerformanceIntervalName

	if FFlagAppPageShellScrollTelemetry then
		scrollPerformanceIntervalName = props.scrollPerformanceIntervalName
	end

	v14.scrollPerformanceIntervalName = scrollPerformanceIntervalName
	v13.Content = createElement2(Page, v14)

	v13.StateOverlay = stateOverlay
	local element = createElement("Frame", v12, v13)

	local createElement3 = React.createElement
	local v15 = {
		Size = UDim2.new(1, 0, 1, 0),
		BorderSizePixel = 0,
		BackgroundTransparency = not props.backgroundStyle and 0 or props.backgroundStyle.Transparency,
		BackgroundColor3 = 0,
		ref = 0,
		ClipsDescendants = true
	}
	local backgroundColor

	if props.backgroundStyle then
		backgroundColor = props.backgroundStyle.Color3
	else
		backgroundColor = v.Color.Surface.Surface_0.Color3
	end

	v15.BackgroundColor3 = backgroundColor

	v15.ref = ref

	local v16 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		}),
		PageBody = element,
		SnackbarPortal = 0
	}
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

	v16.SnackbarPortal = snackbarPortal
	return createElement3("Frame", v15, v16)
end

return React.memo(React.forwardRef(SduiPageWrapperEntryPoint))
