local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local Signals = require(CorePackages.Packages.Signals)

local t = require(CorePackages.Packages.t)
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local withFoundationOrUIBloxStyle = require("@luauforge/bundled/ian").withFoundationOrUIBloxStyle
local Style = require("@game/CorePackages/Workspace/Packages/Style")
local module3 = require("@luauforge/bundled/dzD")

local module4 = require("@luauforge/bundled/fFV")
local vrReadyWrapper = module4.VRReadyWrapper
local vrConstants = module4.VRConstants

local module5 = require("@luauforge/bundled/ehL")
local focusNavigableSurfaceWrapper = module5.FocusNavigableSurfaceWrapper
local focusNavigableSurfaceIdentifierEnum = module5.FocusNavigableSurfaceIdentifierEnum

local intervalPerformanceTracker = require("@luauforge/bundled/fDl").IntervalPerformanceTracker

local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors

local getFFlagEnableNavigationPerformanceIntervals = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableNavigationPerformanceIntervals

local module6 = require("@luauforge/bundled/dKz")
local useNavBarPlacement = module6.useNavBarPlacement
local useNavBarSize = module6.useNavBarSize
local module7 = require("@luauforge/bundled/iao")
local module8 = require("@luauforge/bundled/fFR")
local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local useIsSpatial = Responsive.useIsSpatial
local useDeviceInsets = Responsive.useDeviceInsets
local module10 = require("@luauforge/bundled/dFu")
local module11 = require("@luauforge/bundled/dGJ")
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local bumperHint = require("@luauforge/bundled/iap").BumperHint

local getFFlagLuaAppEnableTopBanner = SharedFlags.GetFFlagLuaAppEnableTopBanner
local defineFastFlag = game:DefineFastFlag("AXAppSystemBarEnableTelemtryForFPS", false)

local defineFastFlag2 = game:DefineFastFlag("AXAppSystemBarEnableTelemtryForFPSForAll", false)
local defineFastFlag3 = game:DefineFastFlag("LuaAppBottomBarInsetSurfaceBackground", false)
local engineFeature = game:GetEngineFeature("WebViewRedesignEnabled")
local module12 = require("@luauforge/bundled/iaJ")
local fFlagShrinkAppNavBar = SharedFlags.FFlagShrinkAppNavBar
local fFlagFixNavRailForDeviceSafeInsets = SharedFlags.FFlagFixNavRailForDeviceSafeInsets
local shouldUseDeviceSafeInsets = require("@luauforge/bundled/dXA").shouldUseDeviceSafeInsets
local fFlagAddGamepadBumperNavigation = SharedFlags.FFlagAddGamepadBumperNavigation
local fFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local fFlagSignalsNavP3bTopBar = SharedFlags.FFlagSignalsNavP3bTopBar
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local getLegacyNavigationStore = if fFlagSignalsNavP3bTopBar then require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore else nil

local fFlagEnableFlyoutOnNavRail = SharedFlags.FFlagEnableFlyoutOnNavRail
local fFlagFlyoutUseOpenHook = SharedFlags.FFlagFlyoutUseOpenHook
local fFlagEnableSplitPane = SharedFlags.FFlagEnableSplitPane
local fFlagAppNavBarPerItemThemeOverride = SharedFlags.FFlagAppNavBarPerItemThemeOverride
local fFlagAmpV2WizardParentModeNavTheme = SharedFlags.FFlagAmpV2WizardParentModeNavTheme
local getParentModeChromeThemeStore, default

if fFlagAmpV2WizardParentModeNavTheme then
	getParentModeChromeThemeStore = require("@luauforge/bundled/fIc").getParentModeChromeThemeStore
	local Foundation = require(CorePackages.Packages.Foundation)
	default = Foundation.Enums.ThemeName.Default
else
	getParentModeChromeThemeStore = nil
	default = nil
end

local useSetDrawerVisible, flyoutSidePanelIXP, flyoutHamburgerButton, useOpenFlyoutSidePanel

if fFlagEnableFlyoutOnNavRail then
	useSetDrawerVisible = require("@luauforge/bundled/iaK").Hooks.useSetDrawerVisible

	local module13 = require("@luauforge/bundled/fAm")
	flyoutSidePanelIXP = require("@luauforge/bundled/dKM").FlyoutSidePanelIXP
	flyoutHamburgerButton = module13.Components.FlyoutHamburgerButton
	useOpenFlyoutSidePanel = module13.Hooks.useOpenFlyoutSidePanel
else
	flyoutSidePanelIXP = nil
	flyoutHamburgerButton = nil
	useOpenFlyoutSidePanel = nil
	useSetDrawerVisible = nil
end

local v5 = Roact.PureComponent:extend("AppSystemBar")

local function isTopPageWebView(p2)
	local v6

	if fFlagUseNavigationSelectors then
		v6 = selectors.selectCurrentLegacyRoute(p2)
	else
		v6 = p2.Navigation.history[#p2.Navigation.history]
	end

	local v8 = module11[v6[#v6].name]
	return v8 and v8.webView == true
end

local strictInterface = t.strictInterface
local v6 = {
	isVisible = t.boolean,
	displayOrder = t.optional(t.number),
	layoutInfo = t.optional(t.table),
	selectedIndex = t.optional(t.number),
	items = t.array(t.any),
	onActivated = t.callback,
	globalGuiInset = t.optional(t.table),
	isSpatial = t.boolean,
	navBarPlacement = t.valueOf(module6.Placement),
	navBarSize = t.number,
	showTooltip = 0,
	statusBarHeight = 0,
	topDeviceSafeInset = 0,
	customEventMap = 0,
	customEventHandlers = 0,
	isBumperNavigationEnabled = 0,
	leadingComponent = 0,
	trailingComponent = 0,
	menuItem = 0
}
local v7 = if engineFeature then t.optional(t.boolean) else nil
v6.showTooltip = v7
v6.statusBarHeight = t.number
local v8 = if fFlagFixNavRailForDeviceSafeInsets then t.optional(t.number) else nil
v6.topDeviceSafeInset = v8
local v9 = if fFlagAddGamepadBumperNavigation or fFlagEnableSplitPane then t.optional(t.table) else nil
v6.customEventMap = v9
local v10 = if fFlagAddGamepadBumperNavigation or fFlagEnableSplitPane then t.optional(t.table) else nil
v6.customEventHandlers = v10
local v11 = if fFlagAddGamepadBumperNavigation then t.optional(t.boolean) else nil
v6.isBumperNavigationEnabled = v11
local v12 = if fFlagAddGamepadBumperNavigation then t.optional(t.table) else nil
v6.leadingComponent = v12
local v13 = if fFlagAddGamepadBumperNavigation then t.optional(t.table) else nil
v6.trailingComponent = v13
local v14 = if fFlagEnableFlyoutOnNavRail then t.optional(t.table) else nil
v6.menuItem = v14
v5.validateProps = strictInterface(v6)

v5.defaultProps = { displayOrder = 0, selectedIndex = 1 }

if getFFlagEnableNavigationPerformanceIntervals() then
	function v5:init()
		self.alreadyTrackedPerformanceIntervals = {}
	end

	function v5:getPerformanceTrackerIntervalName(p3)
		if self.alreadyTrackedPerformanceIntervals[p3] ~= nil then
			return "go_to_" .. tostring(p3) .. "_warm"
		end

		self.alreadyTrackedPerformanceIntervals[p3] = true
		return "go_to_" .. tostring(p3) .. "_cold"
	end
end

function v5:getAppNavBarProps()
	local isSpatial = self.props.isSpatial
	local navBarPlacement = self.props.navBarPlacement
	local udim = nil
	local udim2 = nil
	local navBarSize = self.props.navBarSize

	if isSpatial then
		udim = UDim2.fromOffset(0, 0)
		udim2 = UDim2.new(0, navBarSize, 1, 0)
	elseif navBarPlacement == module6.Placement.Bottom then
		udim = UDim2.new(0, 0, 1, -module3.BOTTOM_BAR_SIZE)
		local v15 = module3.BOTTOM_BAR_SIZE + (not fFlagShrinkAppNavBar and 0 or module3.BOTTOM_BAR_PADDING_BOTTOM)
		udim2 = UDim2.new(1, 0, 0, v15)
	elseif navBarPlacement == module6.Placement.Left then
		if shouldUseDeviceSafeInsets then
			udim = UDim2.new(
				0,
				0,
				0,
				(not getFFlagLuaAppEnableTopBanner() and 0 or -self.props.globalGuiInset.top) + self.props.statusBarHeight
			)

			udim2 = UDim2.new(
				0,
				navBarSize,
				1,
				not getFFlagLuaAppEnableTopBanner() and 0 or self.props.globalGuiInset.top
			)
		else
			udim = UDim2.new(
				0,
				-navBarSize,
				0,
				(not getFFlagLuaAppEnableTopBanner() and 0 or -self.props.globalGuiInset.top) + self.props.statusBarHeight
			)

			udim2 = UDim2.new(
				0,
				navBarSize,
				1,
				(not getFFlagLuaAppEnableTopBanner() and 0 or self.props.globalGuiInset.top) - self.props.statusBarHeight
			)
		end
	else
		error(`unexpected navBarPlacement value: {navBarPlacement}`)
	end

	self.getAppNavBarItems = self.getAppNavBarItems or memoize(function(p2)
		return Cryo.List.map(p2, function(data)
			local join = Cryo.Dictionary.join
			local v16 = if data.badgeCount ~= nil and data.badgeCount ~= 0 then data.badgeCount else nil
			return join(data, {
				badgeValue = v16,
				onActivated = function()
					if getFFlagEnableNavigationPerformanceIntervals() and data.page ~= nil then
						local v17 = defineFastFlag
							and data.page == module10.AvatarExperienceRoot
							and true
							or nil

						intervalPerformanceTracker:startTracking(
							self:getPerformanceTrackerIntervalName(data.page),
							2,
							nil,
							defineFastFlag2 or v17,
							defineFastFlag2 or v17
						)
					end

					return self.props.onActivated(data.page, data.actionType)
				end
			})
		end)
	end)

	local appNavBarProps = {
		items = self.getAppNavBarItems(self.props.items),
		placement = navBarPlacement,
		position = udim,
		size = udim2,
		systemBarLabelTextSizeBinding = if not fFlagShrinkAppNavBar then module7 else nil,
		buildCreatorWebNavUrl = module8,
		selectedIndex = self.props.selectedIndex,
		isVisible = self.props.isVisible,
		clipsDescendants = if isSpatial then false else nil,
		showTooltip = self.props.showTooltip,
		leadingComponent = 0,
		trailingComponent = 0,
		menuItem = 0
	}
	local v17 = if fFlagAddGamepadBumperNavigation then self.props.leadingComponent else nil
	appNavBarProps.leadingComponent = v17
	local v18 = if fFlagAddGamepadBumperNavigation then self.props.trailingComponent else nil
	appNavBarProps.trailingComponent = v18

	local v19 = if fFlagEnableFlyoutOnNavRail and flyoutSidePanelIXP.isFlyoutSidePanelEnabled() and navBarPlacement == module6.Placement.Left then self.props.menuItem else nil
	appNavBarProps.menuItem = v19
	return appNavBarProps
end

function v5:render()
	local layoutInfo = self.props.layoutInfo
	local navBarSize = self.props.navBarSize
	local background = layoutInfo and layoutInfo.Background or {}
	return withFoundationOrUIBloxStyle(function(p2)
		return {
			Theme = {
				NavigationBar = {
					Color = p2.Color.Common.NavigationBar.Color3,
					Transparency = p2.Color.Common.NavigationBar.Transparency
				},
				Divider = fFlagEnableSplitPane and {
					Color = p2.Color.Stroke.Emphasis.Color3,
					Transparency = p2.Color.Stroke.Emphasis.Transparency
				} or nil
			}
		}
	end, function(p2)
		local createElement = Roact.createElement

		local v16 = {
			component = "Frame",
			props = {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				ZIndex = 2
			},
			vrProps = {
				partSize = vrConstants.AppSystemBarSize,
				offset = CFrame.new(vrConstants.AppSystemBarPosition) * CFrame.fromEulerAnglesXYZ(0, -3.141592653589793, 0),
				virtualScreenSize = vrConstants.AppSystemBarResolution,
				panelName = "AppSystemBar",
				roundedCornersFrameColor = p2.Theme.NavigationBar.Color,
				hidden = not self.props.isVisible
			}
		}

		local createElement2 = Roact.createElement
		local v18 = {
			surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.NavBar,
			customEventMap = 0,
			customEventHandlers = 0
		}

		local v19 = if fFlagAddGamepadBumperNavigation or fFlagEnableSplitPane then self.props.customEventMap else nil
		v18.customEventMap = v19

		local v20 = if fFlagAddGamepadBumperNavigation or fFlagEnableSplitPane then self.props.customEventHandlers else nil
		v18.customEventHandlers = v20
		local v22

		if self.props.navBarPlacement == module6.Placement.Bottom then
			if defineFastFlag3 then
				v22 = Roact.createElement(module6.BottomBarInsetBackground, {
					AnchorPoint = background.AnchorPoint,
					Position = background.Position,
					Size = background.Size,
					isVisible = self.props.isVisible
				})
			else
				v22 = Roact.createElement("Frame", {
					AnchorPoint = background.AnchorPoint,
					Position = background.Position,
					Size = background.Size,
					BorderSizePixel = 0,
					BackgroundTransparency = p2.Theme.NavigationBar.Transparency,
					BackgroundColor3 = p2.Theme.NavigationBar.Color,
					Active = true,
					ZIndex = 0
				})
			end
		end

		local v23

		if self.props.navBarPlacement == module6.Placement.Left then
			local createElement3 = Roact.createElement

			local v26 = if fFlagFixNavRailForDeviceSafeInsets and shouldUseDeviceSafeInsets then UDim2.fromOffset(
				0,
				(not getFFlagLuaAppEnableTopBanner() and 0 or -self.props.globalGuiInset.top) - self.props.topDeviceSafeInset
			) else UDim2.fromOffset(
				-navBarSize,
				not getFFlagLuaAppEnableTopBanner() and 0 or -self.props.globalGuiInset.top
			)

			local fromOffset = UDim2.fromOffset
			local v28

			if fFlagFixNavRailForDeviceSafeInsets and shouldUseDeviceSafeInsets then
				v28 = self.props.topDeviceSafeInset
			else
				v28 = self.props.statusBarHeight
			end

			v23 = createElement3("Frame", {
				Position = v26,
				Size = fromOffset(navBarSize, v28),
				BackgroundTransparency = p2.Theme.NavigationBar.Transparency,
				BackgroundColor3 = p2.Theme.NavigationBar.Color,
				BorderSizePixel = 0
			})
		end

		local v21 = {
			Background = v22,
			StatusBarBackground = v23,
			RealSystemBar = Roact.createElement(module6.AppNavBar, self:getAppNavBarProps()),
			NavRegionDivider = 0
		}

		local v24 = if fFlagEnableSplitPane and self.props.navBarPlacement == module6.Placement.Left then Roact.createElement("Frame", {
			Name = "NavRegionDivider",
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(
				0,
				not shouldUseDeviceSafeInsets and 0 or navBarSize,
				0,
				(not getFFlagLuaAppEnableTopBanner() and 0 or -self.props.globalGuiInset.top) + self.props.statusBarHeight
			),
			Size = UDim2.new(
				0,
				1,
				1,
				(not getFFlagLuaAppEnableTopBanner() and 0 or self.props.globalGuiInset.top) - (shouldUseDeviceSafeInsets and 0 or self.props.statusBarHeight)
			),
			BackgroundColor3 = p2.Theme.Divider.Color,
			BackgroundTransparency = p2.Theme.Divider.Transparency,
			BorderSizePixel = 0,
			Active = false,
			ZIndex = 3
		}) else nil
		v21.NavRegionDivider = v24
		return createElement(vrReadyWrapper, v16, createElement2(focusNavigableSurfaceWrapper, v18, v21))
	end)
end

if engineFeature then
	if fFlagSignalsNavP3bTopBar then
		local v15 = v5

		local function AppSystemBarWithSignals(p2)
			local legacyNavigationStore = getLegacyNavigationStore(false)
			local v17 = useSignalState((React.useMemo(function()
				return Signals.createComputed(function(p3): boolean
					local v17 = module11[legacyNavigationStore.getCurrentPageName(p3)]
					return not v17 or v17.webView ~= true
				end)
			end, { legacyNavigationStore })))
			return React.createElement(v15, Cryo.Dictionary.union(p2, {
				showTooltip = v17
			}))
		end

		v5 = React.memo(AppSystemBarWithSignals)
	else
		v5 = RoactRodux.connect(function(p2, p3)
			local v16

			if fFlagUseNavigationSelectors then
				v16 = selectors.selectCurrentLegacyRoute(p2)
			else
				v16 = p2.Navigation.history[#p2.Navigation.history]
			end

			local v18 = module11[v16[#v16].name]
			return {
				showTooltip = not v18 or v18.webView ~= true
			}
		end)(v5)
	end
end

if getFFlagLuaAppEnableTopBanner() then
	v5 = RoactRodux.connect(function(p2, p3)
		return { globalGuiInset = p2.GlobalGuiInset }
	end, function(p2)
		return {}
	end)(v5)
end

return function(props)
	local v15 = useIsSpatial()
	local v16 = useNavBarPlacement()
	local v17 = useNavBarSize()
	local v18 = useSelector(function(p2)
		return p2.TopBar.statusBarHeight
	end)
	local v19

	if fFlagFixNavRailForDeviceSafeInsets then
		local v20 = useDeviceInsets()
		v19 = not shouldUseDeviceSafeInsets and 0 or v20.top
	else
		v19 = 0
	end

	local v20, v21

	if
		fFlagAddGamepadBumperNavigation
		and Responsive.useBreakpointYOrLarger(Responsive.Keys.Medium)
		and props.isBumperNavigationEnabled
	then
		v20 = React.createElement(bumperHint, { isLeftBumper = true, squareSize = v17 })

		v21 = React.createElement(bumperHint, { isRightBumper = true, squareSize = v17 })
	end

	local v22

	if fFlagEnableFlyoutOnNavRail and flyoutSidePanelIXP.isFlyoutSidePanelEnabled() then
		local v23 = React.useCallback(function()
			return React.createElement(flyoutHamburgerButton, {
				titleText = "AppNavRail",
				isAlternateEntryPointEnabled = flyoutSidePanelIXP.isAlternateEntryPointEnabled(),
				isIconCentered = true,
				selectable = false
			})
		end, {})
		local v24

		if fFlagFlyoutUseOpenHook then
			v24 = useOpenFlyoutSidePanel("AppNavRail")
		else
			local v25 = useSetDrawerVisible()
			v24 = React.useCallback(function()
				v25(true)
			end, { v25 })
		end

		v22 = React.useMemo(function()
			return { renderIcon = v23, onActivated = v24 }
		end, { v23, v24 })
	end

	local join = Cryo.Dictionary.join

	if not fFlagFixNavRailForDeviceSafeInsets then
		v19 = nil
	end

	if not fFlagAddGamepadBumperNavigation then
		v20 = nil
	end

	if not fFlagAddGamepadBumperNavigation then
		v21 = nil
	end

	if not (fFlagEnableFlyoutOnNavRail and flyoutSidePanelIXP.isFlyoutSidePanelEnabled()) then
		v22 = nil
	end

	local v24 = join(props, {
		isSpatial = v15,
		navBarPlacement = v16,
		navBarSize = v17,
		statusBarHeight = v18,
		topDeviceSafeInset = v19,
		leadingComponent = v20,
		trailingComponent = v21,
		menuItem = v22
	})

	if not fFlagAppNavBarPerItemThemeOverride then
		return Roact.createElement(v5, v24)
	end

	local uiModeStyleProvider = Style.UiModeStyleProvider
	local v25 = React.useContext(Style.AppearanceContext)
	local v26 = React.useContext(Style.UiModeBrandThemeContext)
	local item = props.items[props.selectedIndex or 1]
	local preferredTheme = if item then item.preferredTheme else nil
	local v27

	if fFlagAmpV2WizardParentModeNavTheme then
		v27 = useSignalState(getParentModeChromeThemeStore().getIsActive)
	end

	local v28 = preferredTheme or v25.theme

	local v29 = not module12 and { themeName = v28, fontName = "gotham" } or React.useMemo(function()
		return { themeName = v28, fontName = "gotham" }
	end, { v28 })

	local createElement = React.createElement
	local v31

	if fFlagAmpV2WizardParentModeNavTheme and v27 then
		v31 = default
	elseif not preferredTheme then
		v31 = v26.foundationThemeName
	end

	return createElement(
		uiModeStyleProvider,
		{ style = v29, foundationThemeName = v31, syncThemeFromProps = true },
		{ SystemBar = Roact.createElement(v5, v24) }
	)
end
