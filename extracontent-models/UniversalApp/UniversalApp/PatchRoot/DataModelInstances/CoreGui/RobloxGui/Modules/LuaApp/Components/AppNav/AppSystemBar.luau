local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local t = require(CorePackages.Packages.t)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local withFoundationOrUIBloxStyle = require(CorePackages.Workspace.Packages.CoreGuiCommon).withFoundationOrUIBloxStyle
local Constants = require(Modules.LuaApp.Constants)
local VrCompatibility = require(CorePackages.Workspace.Packages.VrCompatibility)
local VRReadyWrapper = VrCompatibility.VRReadyWrapper
local VRConstants = VrCompatibility.VRConstants
local VRPanelWidthIXP = VrCompatibility.VRPanelWidthIXP
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local FocusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local IntervalPerformanceTracker = require(CorePackages.Workspace.Packages.IntervalPerformanceTracker).IntervalPerformanceTracker
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors
local GetFFlagEnableNavigationPerformanceIntervals = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableNavigationPerformanceIntervals
local AppNavBar = require(CorePackages.Workspace.Packages.AppNavBar)
local useNavBarPlacement = AppNavBar.useNavBarPlacement
local useNavBarSize = AppNavBar.useNavBarSize
local SystemBarLabelTextSizeBinding = require(Modules.LuaApp.Util.SystemBarLabelTextSizeBinding)
local buildCreatorWebNavUrl = require(Modules.LuaApp.buildCreatorWebNavUrl)
local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local useIsSpatial = Responsive.useIsSpatial
local AppPage = require(Modules.LuaApp.AppPage)
local AppPageProperties = require(Modules.LuaApp.AppPageProperties)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local BumperHint = require(CorePackages.Workspace.Packages.BumperNavigation).BumperHint
local GetFFlagVRPanelWidthIXPEnabled = SharedFlags.GetFFlagVRPanelWidthIXPEnabled
local GetFFlagLuaAppEnableTopBanner = SharedFlags.GetFFlagLuaAppEnableTopBanner
local v36 = game:DefineFastFlag("AXAppSystemBarEnableTelemtryForFPS", false)
local v37 = game:DefineFastFlag("AXAppSystemBarEnableTelemtryForFPSForAll", false)
local EngineFeature = game:GetEngineFeature("WebViewRedesignEnabled")
local GetFFlagLuaAppFixStudioNotchSupport = require(Modules.LuaApp.Flags.GetFFlagLuaAppFixStudioNotchSupport)
local FFlagLuaAppUseDeviceSafeInsetsForAppContainer = SharedFlags.FFlagLuaAppUseDeviceSafeInsetsForAppContainer
local FFlagShrinkAppNavBar = SharedFlags.FFlagShrinkAppNavBar
local v42 = FFlagLuaAppUseDeviceSafeInsetsForAppContainer and GetFFlagLuaAppFixStudioNotchSupport()
local FFlagLuaAppForceVrAppPanelWidthRollout = SharedFlags.FFlagLuaAppForceVrAppPanelWidthRollout
local FFlagAddGamepadBumperNavigation = SharedFlags.FFlagAddGamepadBumperNavigation
local FFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local FFlagSignalsNavP3bTopBar = SharedFlags.FFlagSignalsNavP3bTopBar
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local v48 = if not FFlagSignalsNavP3bTopBar then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore
local u49 = Roact.PureComponent:extend("AppSystemBar")

local function isTopPageWebView(p1) -- line: 75
	-- upvalues: FFlagUseNavigationSelectors (copy), Selectors (copy), AppPageProperties (copy)
	local v53 = if not FFlagUseNavigationSelectors then p1.Navigation.history[#p1.Navigation.history] else Selectors.selectCurrentLegacyRoute(p1)
	local v54 = AppPageProperties[v53[#v53].name]

	return v54 and v54.webView == true
end

u49.validateProps = t.strictInterface({
	isVisible = t.boolean,
	displayOrder = t.optional(t.number),
	layoutInfo = t.optional(t.table),
	selectedIndex = t.optional(t.number),
	items = t.array(t.any),
	onActivated = t.callback,
	vrPanelWidthMultiplier = if not FFlagLuaAppForceVrAppPanelWidthRollout then t.optional(t.number) else nil,
	vrPanelCurvature = if not FFlagLuaAppForceVrAppPanelWidthRollout then t.optional(t.number) else nil,
	xOffset = if not FFlagLuaAppForceVrAppPanelWidthRollout then t.optional(t.number) else nil,
	yOffset = if not FFlagLuaAppForceVrAppPanelWidthRollout then t.optional(t.number) else nil,
	zOffset = if not FFlagLuaAppForceVrAppPanelWidthRollout then t.optional(t.number) else nil,
	heightModifier = if not FFlagLuaAppForceVrAppPanelWidthRollout then t.optional(t.number) else nil,
	globalGuiInset = t.optional(t.table),
	isSpatial = t.boolean,
	navBarPlacement = t.valueOf(AppNavBar.Placement),
	navBarSize = t.number,
	showTooltip = if not EngineFeature then nil else t.optional(t.boolean),
	statusBarHeight = t.number,
	customEventMap = if not FFlagAddGamepadBumperNavigation then nil else t.optional(t.table),
	customEventHandlers = if not FFlagAddGamepadBumperNavigation then nil else t.optional(t.table),
	isBumperNavigationEnabled = if not FFlagAddGamepadBumperNavigation then nil else t.optional(t.boolean),
	leadingComponent = if not FFlagAddGamepadBumperNavigation then nil else t.optional(t.table),
	trailingComponent = if not FFlagAddGamepadBumperNavigation then nil else t.optional(t.table)
})
u49.defaultProps = {
	displayOrder = 0,
	selectedIndex = 1
}

if GetFFlagEnableNavigationPerformanceIntervals() then
	function u49.init(p2) -- line: 116
		p2.alreadyTrackedPerformanceIntervals = {}
	end
	function u49.getPerformanceTrackerIntervalName(p3, p4) -- line: 120
		if p3.alreadyTrackedPerformanceIntervals[p4] ~= nil then
			return "go_to_" .. tostring(p4) .. "_" .. "warm"
		end

		p3.alreadyTrackedPerformanceIntervals[p4] = true

		return "go_to_" .. tostring(p4) .. "_" .. "cold"
	end
end

function u49.getAppNavBarProps(p5) -- line: 130
	-- upvalues: AppNavBar (copy), Constants (copy), FFlagShrinkAppNavBar (copy), v42 (copy), GetFFlagLuaAppEnableTopBanner (copy), memoize (copy), Cryo (copy), GetFFlagEnableNavigationPerformanceIntervals (copy), v36 (copy), AppPage (copy), IntervalPerformanceTracker (copy), v37 (copy), SystemBarLabelTextSizeBinding (copy), buildCreatorWebNavUrl (copy), FFlagAddGamepadBumperNavigation (copy)
	local isSpatial = p5.props.isSpatial
	local navBarPlacement = p5.props.navBarPlacement
	local uDim2 = nil
	local uDim2_2 = nil
	local navBarSize = p5.props.navBarSize

	if isSpatial then
		uDim2 = UDim2.fromOffset(0, 0)
		uDim2_2 = UDim2.new(0, navBarSize, 1, 0)
	elseif navBarPlacement == AppNavBar.Placement.Bottom then
		uDim2 = UDim2.new(0, 0, 1, -Constants.BOTTOM_BAR_SIZE)

		local v64 = Constants.BOTTOM_BAR_SIZE + (not FFlagShrinkAppNavBar and 0 or Constants.BOTTOM_BAR_PADDING_BOTTOM)

		uDim2_2 = UDim2.new(1, 0, 0, v64)
	elseif navBarPlacement == AppNavBar.Placement.Left then
		if v42 then
			uDim2 = UDim2.new(0, 0, 0, (not GetFFlagLuaAppEnableTopBanner() and 0 or -p5.props.globalGuiInset.top) + p5.props.statusBarHeight)
			uDim2_2 = UDim2.new(0, navBarSize, 1, not GetFFlagLuaAppEnableTopBanner() and 0 or p5.props.globalGuiInset.top)
		else
			uDim2 = UDim2.new(0, -navBarSize, 0, (not GetFFlagLuaAppEnableTopBanner() and 0 or -p5.props.globalGuiInset.top) + p5.props.statusBarHeight)
			uDim2_2 = UDim2.new(0, navBarSize, 1, (not GetFFlagLuaAppEnableTopBanner() and 0 or p5.props.globalGuiInset.top) - p5.props.statusBarHeight)
		end
	else
		error(`unexpected navBarPlacement value: { navBarPlacement }`)
	end

	p5.getAppNavBarItems = p5.getAppNavBarItems or memoize(function(p6) -- line: 179
		-- upvalues: Cryo (copy), GetFFlagEnableNavigationPerformanceIntervals (copy), v36 (copy), AppPage (copy), IntervalPerformanceTracker (copy), p5 (copy), v37 (copy)
		return Cryo.List.map(p6, function(p7) -- line: 181
			-- upvalues: Cryo (copy), GetFFlagEnableNavigationPerformanceIntervals (copy), v36 (copy), AppPage (copy), IntervalPerformanceTracker (copy), p5 (copy), v37 (copy)
			return Cryo.Dictionary.join(p7, {
				badgeValue = if p7.badgeCount == nil or p7.badgeCount == 0 then nil else p7.badgeCount,
				onActivated = function() -- line: 184
					-- upvalues: GetFFlagEnableNavigationPerformanceIntervals (copy), p7 (copy), v36 (copy), AppPage (copy), IntervalPerformanceTracker (copy), p5 (copy), v37 (copy)
					if GetFFlagEnableNavigationPerformanceIntervals() and p7.page ~= nil then
						local v100 = v36 and p7.page == AppPage.AvatarExperienceRoot or nil

						IntervalPerformanceTracker:startTracking(p5:getPerformanceTrackerIntervalName(p7.page), 2, nil, v37 or v100, v37 or v100)
					end

					return p5.props.onActivated(p7.page, p7.actionType)
				end
			})
		end)
	end)

	return {
		items = p5.getAppNavBarItems(p5.props.items),
		placement = navBarPlacement,
		position = uDim2,
		size = uDim2_2,
		systemBarLabelTextSizeBinding = if not FFlagShrinkAppNavBar then SystemBarLabelTextSizeBinding else nil,
		buildCreatorWebNavUrl = buildCreatorWebNavUrl,
		selectedIndex = p5.props.selectedIndex,
		isVisible = p5.props.isVisible,
		clipsDescendants = not isSpatial and nil,
		showTooltip = p5.props.showTooltip,
		leadingComponent = if not FFlagAddGamepadBumperNavigation then nil else p5.props.leadingComponent,
		trailingComponent = if not FFlagAddGamepadBumperNavigation then nil else p5.props.trailingComponent
	}
end
function u49.render(p8) -- line: 223
	-- upvalues: withFoundationOrUIBloxStyle (copy), FFlagLuaAppForceVrAppPanelWidthRollout (copy), GetFFlagVRPanelWidthIXPEnabled (copy), VRConstants (copy), Roact (copy), VRReadyWrapper (copy), FocusNavigableSurfaceWrapper (copy), FocusNavigableSurfaceIdentifierEnum (copy), FFlagAddGamepadBumperNavigation (copy), AppNavBar (copy), GetFFlagLuaAppEnableTopBanner (copy)
	local layoutInfo = p8.props.layoutInfo
	local navBarSize = p8.props.navBarSize
	local v68 = layoutInfo and layoutInfo.Background or {}

	return withFoundationOrUIBloxStyle(function(p9) -- line: 227
		return {
			Theme = {
				NavigationBar = {
					Color = p9.Color.Common.NavigationBar.Color3,
					Transparency = p9.Color.Common.NavigationBar.Transparency
				}
			}
		}
	end, function(p10) -- line: 236
		-- upvalues: FFlagLuaAppForceVrAppPanelWidthRollout (copy), p8 (copy), GetFFlagVRPanelWidthIXPEnabled (copy), VRConstants (copy), Roact (copy), VRReadyWrapper (copy), FocusNavigableSurfaceWrapper (copy), FocusNavigableSurfaceIdentifierEnum (copy), FFlagAddGamepadBumperNavigation (copy), AppNavBar (copy), v68 (copy), navBarSize (copy), GetFFlagLuaAppEnableTopBanner (copy)
		local v92 = (FFlagLuaAppForceVrAppPanelWidthRollout or not p8.props.xOffset) and 0 or p8.props.xOffset
		local v93 = (FFlagLuaAppForceVrAppPanelWidthRollout or not p8.props.yOffset) and 0 or p8.props.yOffset
		local v94 = (FFlagLuaAppForceVrAppPanelWidthRollout or not p8.props.zOffset) and 0 or p8.props.zOffset
		local v95 = if FFlagLuaAppForceVrAppPanelWidthRollout or (not GetFFlagVRPanelWidthIXPEnabled() or not p8.props.vrPanelWidthMultiplier) then VRConstants.AppSystemBarPosition else Vector3.new(VRConstants.AppSystemBarPosition.X * p8.props.vrPanelWidthMultiplier + v92, VRConstants.AppSystemBarPosition.Y + v93, VRConstants.AppSystemBarPosition.Z + v94)
		local v96 = if FFlagLuaAppForceVrAppPanelWidthRollout or not p8.props.heightModifier then VRConstants.AppSystemBarResolution else Vector2.new(VRConstants.AppSystemBarResolution.X, VRConstants.AppSystemBarResolution.Y * p8.props.heightModifier)
		local v97 = if FFlagLuaAppForceVrAppPanelWidthRollout or not p8.props.heightModifier then VRConstants.AppSystemBarSize else Vector2.new(VRConstants.AppSystemBarSize.X, VRConstants.AppSystemBarSize.Y * p8.props.heightModifier)

		return Roact.createElement(VRReadyWrapper, {
			component = "Frame",
			props = {
				BackgroundTransparency = 1,
				ZIndex = 2,
				Size = UDim2.fromScale(1, 1)
			},
			vrProps = {
				panelName = "AppSystemBar",
				partSize = v97,
				offset = if not FFlagLuaAppForceVrAppPanelWidthRollout and (not GetFFlagVRPanelWidthIXPEnabled() or p8.props.vrPanelCurvature ~= 0) then CFrame.lookAt(v95, VRConstants.DefaultCameraPosition, (Vector3.new(0, 1, 0))) else CFrame.new(v95) * CFrame.fromEulerAnglesXYZ(0, -3.141592653589793, 0),
				virtualScreenSize = v96,
				roundedCornersFrameColor = p10.Theme.NavigationBar.Color,
				hidden = not p8.props.isVisible
			}
		}, Roact.createElement(FocusNavigableSurfaceWrapper, {
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.NavBar,
			customEventMap = if not FFlagAddGamepadBumperNavigation then nil else p8.props.customEventMap,
			customEventHandlers = if not FFlagAddGamepadBumperNavigation then nil else p8.props.customEventHandlers
		}, {
			Background = if p8.props.navBarPlacement ~= AppNavBar.Placement.Bottom then nil else Roact.createElement("Frame", {
				BorderSizePixel = 0,
				Active = true,
				ZIndex = 0,
				AnchorPoint = v68.AnchorPoint,
				Position = v68.Position,
				Size = v68.Size,
				BackgroundTransparency = p10.Theme.NavigationBar.Transparency,
				BackgroundColor3 = p10.Theme.NavigationBar.Color
			}),
			StatusBarBackground = if p8.props.navBarPlacement ~= AppNavBar.Placement.Left then nil else Roact.createElement("Frame", {
				BorderSizePixel = 0,
				Position = UDim2.fromOffset(-navBarSize, not GetFFlagLuaAppEnableTopBanner() and 0 or -p8.props.globalGuiInset.top),
				Size = UDim2.fromOffset(navBarSize, p8.props.statusBarHeight),
				BackgroundTransparency = p10.Theme.NavigationBar.Transparency,
				BackgroundColor3 = p10.Theme.NavigationBar.Color
			}),
			RealSystemBar = Roact.createElement(AppNavBar.AppNavBar, p8:getAppNavBarProps())
		}))
	end)
end

if EngineFeature then
	if FFlagSignalsNavP3bTopBar then
		local v51 = u49

		function u49(p11) -- line: 333
			-- upvalues: v48 (copy), useSignalState (copy), AppPageProperties (copy), React (copy), v51 (copy), Cryo (copy)
			local v70 = v48(false)
			local v71 = AppPageProperties[useSignalState(v70.getCurrentPage).name]
			local v72 = v71 and v71.webView == true

			return React.createElement(v51, Cryo.Dictionary.union(p11, {
				showTooltip = not v72
			}))
		end
	else
		u49 = RoactRodux.connect(function(p12, _) -- line: 346
			-- upvalues: FFlagUseNavigationSelectors (copy), Selectors (copy), AppPageProperties (copy)
			local t1 = {}
			local v76 = if not FFlagUseNavigationSelectors then p12.Navigation.history[#p12.Navigation.history] else Selectors.selectCurrentLegacyRoute(p12)
			local v77 = AppPageProperties[v76[#v76].name]

			t1.showTooltip = not (v77 and v77.webView == true)

			return t1
		end)(u49)
	end
end

if not FFlagLuaAppForceVrAppPanelWidthRollout and GetFFlagVRPanelWidthIXPEnabled() then
	u49 = IxpUtils.connectTestVariables({
		vrPanelWidthMultiplier = VRPanelWidthIXP.VrAppPanelWidthMultiplier,
		vrPanelCurvature = VRPanelWidthIXP.VrAppPanelCurvature,
		xOffset = VRPanelWidthIXP.VrSystemBarXOffSet,
		yOffset = VRPanelWidthIXP.VrSystemBarYOffSet,
		zOffset = VRPanelWidthIXP.VrSystemBarZOffSet,
		heightModifier = VRPanelWidthIXP.SystemBarHeightMultiplier
	})(u49)
end

if GetFFlagLuaAppEnableTopBanner() then
	u49 = RoactRodux.connect(function(p14, _) -- line: 366
		return {
			globalGuiInset = p14.GlobalGuiInset
		}
	end, function(_) -- line: 370
		return {}
	end)(u49)
end

return function(p17) -- line: 375
	-- upvalues: useIsSpatial (copy), useNavBarPlacement (copy), useNavBarSize (copy), useSelector (copy), FFlagAddGamepadBumperNavigation (copy), Responsive (copy), React (copy), BumperHint (copy), Cryo (copy), Roact (copy), u49 (ref)
	local v82 = useIsSpatial()
	local v83 = useNavBarPlacement()
	local v84 = useNavBarSize()
	local v85 = useSelector(function(p18) -- line: 379
		return p18.TopBar.statusBarHeight
	end)
	local v86 = nil
	local v87 = nil

	if FFlagAddGamepadBumperNavigation and (Responsive.useBreakpointYOrLarger(Responsive.Keys.Medium) and p17.isBumperNavigationEnabled) then
		v86 = React.createElement(BumperHint, {
			isLeftBumper = true,
			squareSize = v84
		})
		v87 = React.createElement(BumperHint, {
			isRightBumper = true,
			squareSize = v84
		})
	end

	local v88 = Cryo.Dictionary.join(p17, {
		isSpatial = v82,
		navBarPlacement = v83,
		navBarSize = v84,
		statusBarHeight = v85,
		leadingComponent = if not FFlagAddGamepadBumperNavigation then nil else v86,
		trailingComponent = if not FFlagAddGamepadBumperNavigation then nil else v87
	})

	return Roact.createElement(u49, v88)
end
