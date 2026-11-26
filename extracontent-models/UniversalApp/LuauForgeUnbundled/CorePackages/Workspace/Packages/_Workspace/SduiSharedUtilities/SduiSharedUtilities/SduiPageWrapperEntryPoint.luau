local CoreGui = game:GetService("CoreGui")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/React")
local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/ReactRoblox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/Foundation")
local loading = Foundation.Loading
local snackbar = Foundation.Snackbar
local useTokens = Foundation.Hooks.useTokens
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/ReactFocusNavigation")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/RoactUtils").Hooks.RoactRodux.useDispatch
local navigateBack = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/NavigationRodux").Thunks.NavigateBack
local visibilityControl = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/AppNavBar").VisibilityControl
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/RobloxAppNavigation").NavigationCommands else nil

local useCloseWithBackButton = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/AppBlox").useCloseWithBackButton
local getSduiComponentWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiCoreSystem").getSduiComponentWrapper
local page = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/AppPageShell").Page
local signal = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/AppCommonLib").Signal

local useCreateClientBindingSduiContext = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/useCreateClientBindingSduiContext")
local uiStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiIntegrationTypes").UiStatus
local SduiPageErrorState = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiPageErrorState")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiLoadTimer")
local useLocalAnalyticsData = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/hooks/useLocalAnalyticsData")
local useStatefulRef = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/hooks/useStatefulRef")
local useComponentConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/hooks/useComponentConfig")
local useUiStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/hooks/useUiStatus")
local useDataUpdatedTimestamp = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/hooks/useDataUpdatedTimestamp")
local useSduiPageContent = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/hooks/useSduiPageContent")
local usePageEntrySnackbar = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/usePageEntrySnackbar")

local fFlagAppPageShellScrollToTopFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagAppPageShellScrollToTopFocus
local fFlagAppPageShellScrollTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagAppPageShellScrollTelemetry
local fFlagAppThemeHalloween2026HomeBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagAppThemeHalloween2026HomeBackground

local function SduiPageWrapperEntryPoint(props, p2)
	local appPage = props.appPage
	local configKey = props.configKey or appPage
	local formatted = `SduiPageWrapperEntryPoint-{configKey}`
	local v5 = useTokens()
	local v6 = useDispatch()

	local v7 = useComponentConfig(configKey, props.stickyIdentifier)

	local v8 = useUiStatus(configKey)
	local v9 = v8 == uiStatus.Loading
	local v10 = v8 == uiStatus.Error

	local v11 = useLocalAnalyticsData(configKey, appPage, props.additionalAnalyticsData)
	local v12 = React.useMemo(function()
		return signal.new()
	end, {})
	local refresh = props.refresh
	local v13 = React.useCallback(function()
		v12:fire()

		if refresh then
			return refresh()
		end

		return nil
	end, { v12, refresh })

	local v14, v15 = useStatefulRef(p2)

	local v16 = React.useCallback(function()
		if props.onCloseActivated then
			props.onCloseActivated()
		elseif fFlagSignalsNavP3Dispatch then
			navigationCommands.back()
		else
			v6(navigateBack())
		end
	end, { v6, props.onCloseActivated })

	local v17, v18 = ReactFocusNavigation.useMostRecentOrDefaultFocusBehavior(v15)

	if fFlagAppPageShellScrollToTopFocus and props.handleBackButton == false then
		v16 = nil
	end

	local v20 = useCloseWithBackButton(v18, v16)

	local v21 = usePageEntrySnackbar(configKey)

	local state, setState = React.useState(nil)
	local v23 = useCreateClientBindingSduiContext(
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

	local v25 = {
		configKey = configKey,
		contentIdentifier = props.contentIdentifier,
		contentMode = props.contentMode,
		sduiContext = v23,
		localAnalyticsData = v11,
		debugName = formatted,
		pageTimer = props.pageTimer,
		refreshSignal = v12,
		defaultFocusRef = 0
	}

	local v26 = if fFlagAppPageShellScrollToTopFocus then props.defaultFocusRef else nil
	v25.defaultFocusRef = v26
	local v27 = useSduiPageContent(v25)

	local localStickyHeaderSlot = props.localStickyHeaderSlot
	local v28 = React.useMemo(function()
		local v29

		if not (props.stickyIdentifier == nil or v7 == nil) then
			local sduiComponentWrapper = getSduiComponentWrapper(v7)
			v29 = React.createElement(sduiComponentWrapper, {
				debugName = `{formatted}-sticky`,
				componentConfig = v7,
				sduiContext = v23,
				localAnalyticsData = v11
			})
		end

		if localStickyHeaderSlot == nil and v29 == nil then
			return nil
		end

		local result = {}

		if localStickyHeaderSlot ~= nil then
			for k, v30 in localStickyHeaderSlot do
				table.insert(result, v30)
			end
		end

		if v29 ~= nil then
			table.insert(result, v29)
		end

		return result
	end, { props.stickyIdentifier, v7, v23, v11, formatted, localStickyHeaderSlot })

	local v29 = nil

	if v9 then
		v29 = props.loadingSlot
			or React.createElement(
				Foundation.View,
				{ tag = "size-full", ZIndex = 2 },
				React.createElement(loading, {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5)
				})
			)
	elseif v10 then
		v29 = props.errorSlot or React.createElement(SduiPageErrorState, {
			refresh = props.refresh
		})
	end

	local v30 = not (v28 == nil) and next(v28) ~= nil
	local v31 = props.feedTopMargin
	local stickyTopPadding = if v30 then props.stickyTopPadding or v31 else nil

	if v30 then
		v31 = props.stickyBottomPadding
	end

	local scrollAway = props.scrollAway
	local pageTopPadding = props.pageTopPadding
	local v32 = React.useMemo(function()
		local v33 = pageTopPadding or 0

		if v33 <= 0 then
			return nil
		end

		local v34 = if scrollAway then scrollAway.headerHeightBinding else nil

		if v34 == nil and scrollAway and scrollAway.scrollAwayHeight then
			local scrollAwayHeight = scrollAway.scrollAwayHeight
			v34 = visibilityControl.getHeaderBinding():map(function(p3)
				return p3 * scrollAwayHeight
			end)
		end

		local v36 = if scrollAway then scrollAway.scrollAwayHeight else nil
		return { height = v33, scrollAwayHeight = v36, liveHeightBinding = v34 }
	end, { pageTopPadding, scrollAway })

	local createElement = React.createElement
	local v34 = {
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		ref = setState
	}

	local v35 = {
		UIFlexItem = React.createElement("UIFlexItem", {
			FlexMode = Enum.UIFlexMode.Fill
		}),
		Content = 0,
		StateOverlay = 0
	}

	local createElement2 = React.createElement
	local v37 = {
		contentConfig = v27,
		stickyHeaderSlot = v28,
		composition = props.composition,
		chrome = v32,
		stickyBackgroundStyle = 0,
		onScrollToEnd = 0,
		onScrollToEndThreshold = 0,
		onRefresh = 0,
		appEventName = 0,
		contentTopPadding = 0,
		stickyTopPadding = 0,
		scrollPerformanceIntervalName = 0
	}

	local v38 = if fFlagAppThemeHalloween2026HomeBackground then props.stickyBackgroundStyle or props.backgroundStyle else props.backgroundStyle
	v37.stickyBackgroundStyle = v38

	v37.onScrollToEnd = props.onScrollToEnd
	v37.onScrollToEndThreshold = props.onScrollToEndThreshold

	if not refresh then
		v13 = nil
	end

	v37.onRefresh = v13
	v37.appEventName = appPage
	v37.contentTopPadding = v31
	v37.stickyTopPadding = stickyTopPadding

	local v39 = if fFlagAppPageShellScrollTelemetry then props.scrollPerformanceIntervalName else nil
	v37.scrollPerformanceIntervalName = v39
	v35.Content = createElement2(page, v37)

	v35.StateOverlay = v29
	local element = createElement("Frame", v34, v35)

	local createElement3 = React.createElement
	local v41 = {
		Size = UDim2.new(1, 0, 1, 0),
		BorderSizePixel = 0,
		BackgroundTransparency = not props.backgroundStyle and 0 or props.backgroundStyle.Transparency,
		BackgroundColor3 = 0,
		ref = 0,
		ClipsDescendants = true
	}
	local v42 = if props.backgroundStyle then props.backgroundStyle.Color3 else v5.Color.Surface.Surface_0.Color3
	v41.BackgroundColor3 = v42

	v41.ref = v20

	local v43 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		}),
		PageBody = element,
		SnackbarPortal = 0
	}

	local v44 = if v21 and v21.snackbarConfig then ReactRoblox.createPortal({
		SduiSnackbarScreenGui = React.createElement(
			"ScreenGui",
			{
				DisplayOrder = props.snackbarPortalLayoutOrder,
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
				IgnoreGuiInset = true
			},
			{
				Snackbar = React.createElement(snackbar, {
					title = v21.snackbarConfig.title,
					icon = v21.snackbarConfig.icon,
					Position = UDim2.new(0.5, 0, 1, -v5.Padding.XLarge),
					AnchorPoint = Vector2.new(0.5, 1),
					AutomaticSize = Enum.AutomaticSize.XY,
					onClose = v21.onDismiss
				})
			}
		)
	}, CoreGui) else nil
	v43.SnackbarPortal = v44
	return createElement3("Frame", v41, v43)
end

return React.memo(React.forwardRef(SduiPageWrapperEntryPoint))
