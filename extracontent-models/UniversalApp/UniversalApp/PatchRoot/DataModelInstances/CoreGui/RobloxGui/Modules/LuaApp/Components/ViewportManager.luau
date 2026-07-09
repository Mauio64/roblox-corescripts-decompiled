local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Modules = CoreGui.RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Cryo = require(CorePackages.Packages.Cryo)
local Display = require(CorePackages.Workspace.Packages.Display)
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local VrCompatibility = require(CorePackages.Workspace.Packages.VrCompatibility)
local MainScreenResolution = VrCompatibility.VRConstants.MainScreenResolution
local VRPanelWidthIXP = VrCompatibility.VRPanelWidthIXP
local VrEnvironmentScene = require(CorePackages.Workspace.Packages.VrSpatialUi).VrEnvironmentScene
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local DeviceOrientationMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).DeviceOrientationMode
local getScreenBottomInset = require(Modules.LuaApp.getScreenBottomInset)
local ExternalEventConnection = require(Modules.Common.RoactUtilities.ExternalEventConnection)
local SetScreenSize = require(Modules.LuaApp.Actions.SetScreenSize)
local SetDeviceOrientation = require(Modules.LuaApp.Actions.SetDeviceOrientation)
local SetFormFactor = require(CorePackages.Workspace.Packages.FormFactor).Actions.SetFormFactor
local SetStatusBarHeight = require(Modules.LuaApp.Actions.SetStatusBarHeight)
local SetGlobalGuiInset = require(Modules.LuaApp.Actions.SetGlobalGuiInset)
local SetGlobalContextMenuInset = require(Modules.LuaApp.Actions.SetGlobalContextMenuInset)
local AppGuiService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppGuiService
local AppRunService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppRunService
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local getVirtualResolutionScale = Responsive.getVirtualResolutionScale
local HardwareSafeAreaInsets = Responsive.HardwareSafeAreaInsets
local useIsSpatial = Responsive.useIsSpatial
local AppNavBar = require(CorePackages.Workspace.Packages.AppNavBar)
local useNavBarPlacement = AppNavBar.useNavBarPlacement
local useNavBarSize = AppNavBar.useNavBarSize
local GetFFlagSetOrientationWhenRequested = require(Modules.LuaApp.Flags.GetFFlagSetOrientationWhenRequested)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagVRPanelWidthIXPEnabled = SharedFlags.GetFFlagVRPanelWidthIXPEnabled
local GetFFlagApplyResolutionScale = SharedFlags.GetFFlagApplyResolutionScale
local GetFFlagLuaAppEnableTopBanner = SharedFlags.GetFFlagLuaAppEnableTopBanner
local GetFFlagLuaAppFixStudioNotchSupport = require(Modules.LuaApp.Flags.GetFFlagLuaAppFixStudioNotchSupport)
local v42 = SharedFlags.FFlagLuaAppUseDeviceSafeInsetsForAppContainer and GetFFlagLuaAppFixStudioNotchSupport()
local FFlagLuaAppForceVrAppPanelWidthRollout = SharedFlags.FFlagLuaAppForceVrAppPanelWidthRollout
local FFlagEnableCoreContentTheme = SharedFlags.FFlagEnableCoreContentTheme
local FFlagEnableCoreContentThemeVRScene = SharedFlags.FFlagEnableCoreContentThemeVRScene
local v46 = Roact.Component:extend("ViewportManager")

function v46.init(p1) -- line: 62
	-- upvalues: DeviceOrientationMode (copy), GetFFlagSetOrientationWhenRequested (copy), FormFactor (copy), GetFFlagLuaAppFixStudioNotchSupport (copy), HardwareSafeAreaInsets (copy), Workspace (copy), FFlagLuaAppForceVrAppPanelWidthRollout (copy), MainScreenResolution (copy), GetFFlagApplyResolutionScale (copy), getVirtualResolutionScale (copy), v42 (copy), UserInputService (copy), getScreenBottomInset (copy), GetFFlagLuaAppEnableTopBanner (copy), AppNavBar (copy), Display (copy)
	function p1.updateDeviceOrientation(p2) -- line: 63
		-- upvalues: DeviceOrientationMode (copy), GetFFlagSetOrientationWhenRequested (copy), p1 (copy)
		local v69 = p2.x > p2.y and DeviceOrientationMode.Landscape or DeviceOrientationMode.Portrait

		if GetFFlagSetOrientationWhenRequested() or v69 ~= p1.props.deviceOrientation then
			p1.props.setDeviceOrientation(v69)
		end
	end
	function p1.updateDeviceFormFactor(p3) -- line: 72
		-- upvalues: p1 (copy), FormFactor (copy)
		local useWidthBasedRule = p1.props.useWidthBasedRule
		local WIDE = FormFactor.WIDE

		if useWidthBasedRule then
			if p3.X < 600 then
				WIDE = FormFactor.COMPACT
			end
		elseif p3.Y > p3.X then
			WIDE = FormFactor.COMPACT
		end

		p1.props.setFormFactor(WIDE)
	end
	function p1.updateViewport() -- line: 89
		-- upvalues: GetFFlagLuaAppFixStudioNotchSupport (copy), HardwareSafeAreaInsets (copy), Workspace (copy), p1 (copy), FFlagLuaAppForceVrAppPanelWidthRollout (copy), MainScreenResolution (copy), GetFFlagApplyResolutionScale (copy), getVirtualResolutionScale (copy)
		local v73 = if not GetFFlagLuaAppFixStudioNotchSupport() then Workspace.CurrentCamera.ViewportSize else HardwareSafeAreaInsets.fullscreenGui().AbsoluteSize

		if p1.props.use3DPanels then
			v73 = if FFlagLuaAppForceVrAppPanelWidthRollout or not p1.props.vrPanelWidthMultiplier then MainScreenResolution else Vector2.new(MainScreenResolution.X * p1.props.vrPanelWidthMultiplier, MainScreenResolution.Y)
		end

		if GetFFlagApplyResolutionScale() then
			local v74 = getVirtualResolutionScale()
			local vector2 = Vector2.new(v73.X / v74, v73.Y / v74)

			p1.props.setScreenSize(vector2)
			p1.updateDeviceOrientation(vector2)
			p1.updateDeviceFormFactor(vector2)

			return
		end

		if v73.X > 1 and v73.Y > 1 then
			p1.props.setScreenSize(v73)
			p1.updateDeviceOrientation(v73)
			p1.updateDeviceFormFactor(v73)
		end
	end
	function p1.pointCameraTo3DPanels() -- line: 124
		local CurrentCamera = workspace.CurrentCamera

		if CurrentCamera then
			CurrentCamera.CFrame = CFrame.new(0, 5, 0)
		end
	end
	function p1.updateStatusBarHeight() -- line: 131
		-- upvalues: v42 (copy), p1 (copy), UserInputService (copy)
		if v42 then
			p1.props.setStatusBarHeight(0)

			return
		end

		p1.props.setStatusBarHeight(UserInputService.StatusBarSize.Y)
	end
	function p1.updateGlobalGuiInset() -- line: 146
		-- upvalues: p1 (copy), getScreenBottomInset (copy), UserInputService (copy), GetFFlagLuaAppEnableTopBanner (copy), AppNavBar (copy), Display (copy)
		local bottomBarVisible = p1.props.bottomBarVisible
		local appTopBannerContentHeight = p1.props.appTopBannerContentHeight
		local appTopBannerVisible = p1.props.appTopBannerVisible
		local v80 = getScreenBottomInset()
		local n1 = 0
		local RightBarSizeX = UserInputService.RightBarSize.X
		local v83 = (not GetFFlagLuaAppEnableTopBanner() or not appTopBannerVisible) and 0 or appTopBannerContentHeight

		if bottomBarVisible and (not p1.props.use3DPanels and p1.props.navBarPlacement == AppNavBar.Placement.Left) then
			n1 += p1.props.navBarSize
		end

		Display.GetDisplayStore().setGuiInset({
			left = n1,
			top = v83,
			right = RightBarSizeX,
			bottom = v80
		})
		p1.props.setGlobalContextMenuInset(0, 0, RightBarSizeX, v80)
		p1.props.setGlobalGuiInset(n1, v83, RightBarSizeX, v80)
	end

	if GetFFlagLuaAppFixStudioNotchSupport() then
		p1.viewportSizeChangedConnnection = HardwareSafeAreaInsets.fullscreenGui():GetPropertyChangedSignal("AbsoluteSize"):Connect(p1.updateViewport)
	else
		p1.viewportSizeChangedConnnection = Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(p1.updateViewport)
	end

	p1.updateViewport()
end
function v46.render(p4) -- line: 186
	-- upvalues: Roact (copy), ExternalEventConnection (copy), UserInputService (copy)
	local guiService = p4.props.guiService

	return Roact.createElement("Folder", {}, {
		statusBarSizeListener = Roact.createElement(ExternalEventConnection, {
			event = UserInputService:GetPropertyChangedSignal("StatusBarSize"),
			callback = p4.updateStatusBarHeight
		}),
		bottomBarSizeListener = not _G.__TESTEZ_RUNNING_TEST__ and Roact.createElement(ExternalEventConnection, {
			event = UserInputService:GetPropertyChangedSignal("BottomBarSize"),
			callback = p4.updateGlobalGuiInset
		}),
		rightBarSizeListener = not _G.__TESTEZ_RUNNING_TEST__ and Roact.createElement(ExternalEventConnection, {
			event = UserInputService:GetPropertyChangedSignal("RightBarSize"),
			callback = p4.updateGlobalGuiInset
		}),
		safeZoneOffsetsListener = not _G.__TESTEZ_RUNNING_TEST__ and Roact.createElement(ExternalEventConnection, {
			event = guiService.SafeZoneOffsetsChanged,
			callback = p4.updateGlobalGuiInset
		})
	})
end
function v46.didMount(p5) -- line: 209
	-- upvalues: UserInputService (copy), FFlagEnableCoreContentTheme (copy), FFlagEnableCoreContentThemeVRScene (copy), VrEnvironmentScene (copy)
	UserInputService.LegacyInputEventsEnabled = false
	p5.updateStatusBarHeight()
	p5.updateGlobalGuiInset()

	if p5.props.use3DPanels then
		p5.pointCameraTo3DPanels()

		if FFlagEnableCoreContentTheme and FFlagEnableCoreContentThemeVRScene then
			VrEnvironmentScene.initialize()
		end
	end
end
function v46.willUnmount(p6) -- line: 223
	-- upvalues: FFlagEnableCoreContentTheme (copy), FFlagEnableCoreContentThemeVRScene (copy), VrEnvironmentScene (copy)
	if p6.viewportSizeChangedConnnection then
		p6.viewportSizeChangedConnnection:Disconnect()
		p6.viewportSizeChangedConnnection = nil
	end

	if FFlagEnableCoreContentTheme and FFlagEnableCoreContentThemeVRScene then
		VrEnvironmentScene.deinitialize()
	end
end
function v46.didUpdate(p7, p8) -- line: 233
	-- upvalues: GetFFlagLuaAppEnableTopBanner (copy), GetFFlagLuaAppFixStudioNotchSupport (copy), FFlagEnableCoreContentTheme (copy), FFlagEnableCoreContentThemeVRScene (copy), VrEnvironmentScene (copy)
	if p7.props.use3DPanels and (p8.vrPanelWidthMultiplier ~= p7.props.vrPanelWidthMultiplier or p8.use3DPanels ~= p7.props.use3DPanels) then
		p7.updateViewport()
	end

	if p7.props.bottomBarVisible ~= p8.bottomBarVisible then
		p7.updateGlobalGuiInset()
	end

	if GetFFlagLuaAppEnableTopBanner() and (p7.props.appTopBannerVisible ~= p8.appTopBannerVisible or p7.props.appTopBannerContentHeight ~= p8.appTopBannerContentHeight) then
		p7.updateGlobalGuiInset()
	end

	if p7.props.use3DPanels ~= p8.use3DPanels or p7.props.navBarPlacement ~= p8.navBarPlacement or p7.props.navBarSize ~= p8.navBarSize then
		p7.updateGlobalGuiInset()
	end

	if not GetFFlagLuaAppFixStudioNotchSupport() then
		local globalGuiInset = p7.props.globalGuiInset

		if globalGuiInset ~= p8.globalGuiInset then
			p7.props.guiService:SetGlobalGuiInset(globalGuiInset.left, globalGuiInset.top, globalGuiInset.right, globalGuiInset.bottom)
		end
	end

	local hasScreenGuiBlur = p7.props.hasScreenGuiBlur

	if hasScreenGuiBlur ~= p8.hasScreenGuiBlur then
		p7.props.runService:SetRobloxGuiFocused(hasScreenGuiBlur)
	end

	if p7.props.use3DPanels and not p8.use3DPanels then
		p7.pointCameraTo3DPanels()

		if FFlagEnableCoreContentTheme and FFlagEnableCoreContentThemeVRScene then
			VrEnvironmentScene.initialize()

			return
		end
	elseif FFlagEnableCoreContentTheme and FFlagEnableCoreContentThemeVRScene and not p7.props.use3DPanels and p8.use3DPanels then
		VrEnvironmentScene.deinitialize()
	end
end

local v47 = RoactRodux.connect(function(p9) -- line: 298
	-- upvalues: GetFFlagLuaAppEnableTopBanner (copy)
	return {
		statusBarHeight = p9.TopBar.statusBarHeight,
		deviceOrientation = p9.DeviceOrientation,
		globalGuiInset = p9.GlobalGuiInset,
		globalContextMenuInset = p9.GlobalContextMenuInset,
		bottomBarVisible = p9.TabBarVisible,
		hasScreenGuiBlur = p9.ScreenGuiBlur.hasBlur,
		appTopBannerContentHeight = not GetFFlagLuaAppEnableTopBanner() and 0 or p9.AppTopBanner.appTopBannerContentHeight,
		appTopBannerVisible = not not GetFFlagLuaAppEnableTopBanner() and (p9.AppTopBanner.expanded and not p9.AppTopBanner.isDisabled)
	}
end, function(p10) -- line: 313
	-- upvalues: SetScreenSize (copy), SetDeviceOrientation (copy), SetFormFactor (copy), SetStatusBarHeight (copy), SetGlobalGuiInset (copy), SetGlobalContextMenuInset (copy)
	return {
		setScreenSize = function(p11) -- line: 315
			-- upvalues: p10 (copy), SetScreenSize (copy)
			p10(SetScreenSize(p11))
		end,
		setDeviceOrientation = function(p12) -- line: 318
			-- upvalues: p10 (copy), SetDeviceOrientation (copy)
			p10(SetDeviceOrientation(p12))
		end,
		setFormFactor = function(p13) -- line: 321
			-- upvalues: p10 (copy), SetFormFactor (copy)
			p10(SetFormFactor(p13))
		end,
		setStatusBarHeight = function(p14) -- line: 324
			-- upvalues: p10 (copy), SetStatusBarHeight (copy)
			p10(SetStatusBarHeight(p14))
		end,
		setGlobalGuiInset = function(p15, p16, p17, p18) -- line: 327
			-- upvalues: p10 (copy), SetGlobalGuiInset (copy)
			return p10(SetGlobalGuiInset(p15, p16, p17, p18))
		end,
		setGlobalContextMenuInset = function(p19, p20, p21, p22) -- line: 330
			-- upvalues: p10 (copy), SetGlobalContextMenuInset (copy)
			return p10(SetGlobalContextMenuInset(p19, p20, p21, p22))
		end
	}
end)(v46)
local v48 = RoactServices.connect({
	guiService = AppGuiService,
	runService = AppRunService
})(v47)

if not FFlagLuaAppForceVrAppPanelWidthRollout and GetFFlagVRPanelWidthIXPEnabled() then
	v48 = IxpUtils.connectTestVariables({
		vrPanelWidthMultiplier = VRPanelWidthIXP.VrAppPanelWidthMultiplier,
		vrPanelCurvature = VRPanelWidthIXP.VrAppPanelCurvature
	})(v48)
end

local u49 = RoactAppPolicy.connect(function(p23, _) -- line: 348
	return {
		useWidthBasedRule = p23.getUseWidthBasedFormFactorRule()
	}
end)(v48)

return function(p25) -- line: 354
	-- upvalues: useIsSpatial (copy), useNavBarPlacement (copy), useNavBarSize (copy), Cryo (copy), Roact (copy), u49 (ref)
	local v64 = useIsSpatial()
	local v65 = useNavBarPlacement()
	local v66 = useNavBarSize()
	local v67 = Cryo.Dictionary.join(p25, {
		use3DPanels = v64,
		navBarPlacement = v65,
		navBarSize = v66
	})

	return Roact.createElement(u49, v67)
end
