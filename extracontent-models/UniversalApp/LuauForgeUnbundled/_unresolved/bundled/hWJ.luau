local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/dUd")
local formFactor = require("@luauforge/bundled/dDI").Enums.FormFactor
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local mainScreenResolution = require("@luauforge/bundled/fye").VRConstants.MainScreenResolution
local vrEnvironmentScene = require("@luauforge/bundled/hWK").VrEnvironmentScene
local deviceOrientationMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").DeviceOrientationMode
local module2 = require("@luauforge/bundled/hWL")

local module3 = require("@luauforge/bundled/edm")
local SetScreenSize = require("@game/CoreGui/RobloxGui/Modules/PlayerList/Actions/SetScreenSize")
local module5 = require("@luauforge/bundled/dwq")
local setFormFactor = require("@luauforge/bundled/dDI").Actions.SetFormFactor
local module6 = require("@luauforge/bundled/dwz")
local module7 = require("@luauforge/bundled/hJu")
local module8 = require("@luauforge/bundled/hJw")

local appGuiService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppGuiService
local appRunService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppRunService
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices

local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local getVirtualResolutionScale = Responsive.getVirtualResolutionScale
local hardwareSafeAreaInsets = Responsive.HardwareSafeAreaInsets
local useIsSpatial = Responsive.useIsSpatial
local module10 = require("@luauforge/bundled/dHu")
local useNavBarPlacement = module10.useNavBarPlacement
local useNavBarSize = module10.useNavBarSize

local module11 = require("@luauforge/bundled/hWM")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local getFFlagApplyResolutionScale = SharedFlags.GetFFlagApplyResolutionScale
local getFFlagLuaAppEnableTopBanner = SharedFlags.GetFFlagLuaAppEnableTopBanner
local fFlagLuaAppSupportDeviceSafeInsets = SharedFlags.FFlagLuaAppSupportDeviceSafeInsets
local shouldUseDeviceSafeInsets = module.shouldUseDeviceSafeInsets
local fFlagEnableCoreContentThemeVRScene = SharedFlags.FFlagEnableCoreContentThemeVRScene
local fFlagUseSignalsForGlobalContextMenuInset = SharedFlags.FFlagUseSignalsForGlobalContextMenuInset

local v5 = if fFlagUseSignalsForGlobalContextMenuInset then require("@luauforge/bundled/hEw") else nil

local fFlagUseSignalsForScreenGuiBlur = SharedFlags.FFlagUseSignalsForScreenGuiBlur

local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local getScreenGuiBlurStore

if fFlagUseSignalsForScreenGuiBlur then
	getScreenGuiBlurStore = require("@luauforge/bundled/gea").GetScreenGuiBlurStore
else
	getScreenGuiBlurStore = nil
end

local fFlagUseSignalsForAppTopBanner = SharedFlags.FFlagUseSignalsForAppTopBanner

local getAppTopBannerStore = if fFlagUseSignalsForAppTopBanner then require("@luauforge/bundled/dwT").GetAppTopBannerStore else nil

local fFlagUseSignalsForDeviceOrientation = SharedFlags.FFlagUseSignalsForDeviceOrientation
local getDeviceOrientationStore

if fFlagUseSignalsForDeviceOrientation then
	getDeviceOrientationStore = require("@luauforge/bundled/hMr").GetDeviceOrientationStore
else
	getDeviceOrientationStore = nil
end

local extended = Roact.Component:extend("ViewportManager")

function extended:init()
	function self.updateDeviceOrientation(p2)
		local landscape = p2.x > p2.y and deviceOrientationMode.Landscape or deviceOrientationMode.Portrait
		local v6

		if fFlagUseSignalsForDeviceOrientation then
			v6 = getDeviceOrientationStore(false).getDeviceOrientation(false)
		else
			v6 = self.props.deviceOrientation
		end

		if module11() or v6 ~= landscape then
			self.props.setDeviceOrientation(landscape)
		end
	end

	function self.updateDeviceFormFactor(p2)
		local useWidthBasedRule = self.props.useWidthBasedRule
		local v6 = formFactor.WIDE

		if useWidthBasedRule then
			if p2.X < 600 then
				v6 = formFactor.COMPACT
			end
		elseif p2.Y > p2.X then
			v6 = formFactor.COMPACT
		end

		self.props.setFormFactor(v6)
	end

	function self.updateViewport()
		local v6

		if fFlagLuaAppSupportDeviceSafeInsets then
			v6 = hardwareSafeAreaInsets.fullscreenGui().AbsoluteSize
		else
			v6 = Workspace.CurrentCamera.ViewportSize
		end

		if self.props.use3DPanels then
			v6 = mainScreenResolution
		end

		if getFFlagApplyResolutionScale() then
			local virtualResolutionScale = getVirtualResolutionScale()
			local vector2 = Vector2.new(v6.X / virtualResolutionScale, v6.Y / virtualResolutionScale)

			self.props.setScreenSize(vector2)
			self.updateDeviceOrientation(vector2)
			self.updateDeviceFormFactor(vector2)
		elseif v6.X > 1 and v6.Y > 1 then
			self.props.setScreenSize(v6)
			self.updateDeviceOrientation(v6)
			self.updateDeviceFormFactor(v6)
		end
	end

	function self.pointCameraTo3DPanels()
		local currentCamera = workspace.CurrentCamera

		if currentCamera then
			currentCamera.CFrame = CFrame.new(0, 5, 0)
		end
	end

	function self.updateStatusBarHeight()
		if shouldUseDeviceSafeInsets then
			self.props.setStatusBarHeight(0)
		else
			self.props.setStatusBarHeight(UserInputService.StatusBarSize.Y)
		end
	end

	function self.updateGlobalGuiInset()
		local bottomBarVisible = self.props.bottomBarVisible
		local appTopBannerContentHeight = self.props.appTopBannerContentHeight
		local appTopBannerVisible = self.props.appTopBannerVisible

		local v6 = module2()

		local total = 0
		local x = UserInputService.RightBarSize.X
		local v7 = not (getFFlagLuaAppEnableTopBanner() and appTopBannerVisible) and 0
			or appTopBannerContentHeight

		if
			bottomBarVisible
			and not self.props.use3DPanels
			and self.props.navBarPlacement == module10.Placement.Left
		then
			total += self.props.navBarSize
		end

		module.GetDisplayStore().setGuiInset({
			left = total,
			top = v7,
			right = x,
			bottom = v6
		})

		self.props.setGlobalContextMenuInset(0, 0, x, v6)
		self.props.setGlobalGuiInset(total, v7, x, v6)
	end

	if fFlagLuaAppSupportDeviceSafeInsets then
		self.viewportSizeChangedConnnection = hardwareSafeAreaInsets.fullscreenGui():GetPropertyChangedSignal("AbsoluteSize"):Connect(self.updateViewport)
	else
		self.viewportSizeChangedConnnection = Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(self.updateViewport)
	end

	self.updateViewport()
end

function extended.render(props)
	local guiService = props.props.guiService

	return Roact.createElement("Folder", {}, {
		statusBarSizeListener = Roact.createElement(module3, {
			event = UserInputService:GetPropertyChangedSignal("StatusBarSize"),
			callback = props.updateStatusBarHeight
		}),
		bottomBarSizeListener = not _G.__TESTEZ_RUNNING_TEST__ and Roact.createElement(module3, {
			event = UserInputService:GetPropertyChangedSignal("BottomBarSize"),
			callback = props.updateGlobalGuiInset
		}),
		rightBarSizeListener = not _G.__TESTEZ_RUNNING_TEST__ and Roact.createElement(module3, {
			event = UserInputService:GetPropertyChangedSignal("RightBarSize"),
			callback = props.updateGlobalGuiInset
		}),
		safeZoneOffsetsListener = not _G.__TESTEZ_RUNNING_TEST__ and Roact.createElement(module3, {
			event = guiService.SafeZoneOffsetsChanged,
			callback = props.updateGlobalGuiInset
		})
	})
end

function extended.didMount(data)
	UserInputService.LegacyInputEventsEnabled = false

	data.updateStatusBarHeight()
	data.updateGlobalGuiInset()

	if data.props.use3DPanels then
		data.pointCameraTo3DPanels()

		if fFlagEnableCoreContentThemeVRScene then
			vrEnvironmentScene.initialize()
		end
	end
end

function extended:willUnmount()
	if self.viewportSizeChangedConnnection then
		self.viewportSizeChangedConnnection:Disconnect()
		self.viewportSizeChangedConnnection = nil
	end

	if fFlagEnableCoreContentThemeVRScene then
		vrEnvironmentScene.deinitialize()
	end
end

function extended.didUpdate(data, data2)
	if data.props.use3DPanels and data2.use3DPanels ~= data.props.use3DPanels then
		data.updateViewport()
	end

	if data.props.bottomBarVisible ~= data2.bottomBarVisible then
		data.updateGlobalGuiInset()
	end

	if
		getFFlagLuaAppEnableTopBanner()
		and (data.props.appTopBannerVisible ~= data2.appTopBannerVisible or data.props.appTopBannerContentHeight ~= data2.appTopBannerContentHeight)
	then
		data.updateGlobalGuiInset()
	end

	if
		data.props.use3DPanels ~= data2.use3DPanels
		or data.props.navBarPlacement ~= data2.navBarPlacement
		or data.props.navBarSize ~= data2.navBarSize
	then
		data.updateGlobalGuiInset()
	end

	if not fFlagLuaAppSupportDeviceSafeInsets then
		local globalGuiInset = data.props.globalGuiInset

		if globalGuiInset ~= data2.globalGuiInset then
			data.props.guiService:SetGlobalGuiInset(
				globalGuiInset.left,
				globalGuiInset.top,
				globalGuiInset.right,
				globalGuiInset.bottom
			)
		end
	end

	local hasScreenGuiBlur = data.props.hasScreenGuiBlur

	if hasScreenGuiBlur ~= data2.hasScreenGuiBlur then
		data.props.runService:SetRobloxGuiFocused(hasScreenGuiBlur)
	end

	if data.props.use3DPanels and not data2.use3DPanels then
		data.pointCameraTo3DPanels()

		if fFlagEnableCoreContentThemeVRScene then
			vrEnvironmentScene.initialize()
		end
	elseif fFlagEnableCoreContentThemeVRScene and not data.props.use3DPanels and data2.use3DPanels then
		vrEnvironmentScene.deinitialize()
	end
end

local v6 = RoactRodux.connect(function(data)
	local v7 = {
		statusBarHeight = data.TopBar.statusBarHeight,
		deviceOrientation = 0,
		globalGuiInset = 0,
		globalContextMenuInset = 0,
		bottomBarVisible = 0,
		hasScreenGuiBlur = 0,
		appTopBannerContentHeight = 0,
		appTopBannerVisible = 0
	}
	local v8 = if not fFlagUseSignalsForDeviceOrientation then data.DeviceOrientation else nil
	v7.deviceOrientation = v8
	v7.globalGuiInset = data.GlobalGuiInset
	local v9 = if not fFlagUseSignalsForGlobalContextMenuInset then data.GlobalContextMenuInset else nil
	v7.globalContextMenuInset = v9
	v7.bottomBarVisible = data.TabBarVisible
	local v10 = if not fFlagUseSignalsForScreenGuiBlur then data.ScreenGuiBlur.hasBlur else nil
	v7.hasScreenGuiBlur = v10

	local v11 = if not fFlagUseSignalsForAppTopBanner then not getFFlagLuaAppEnableTopBanner() and 0 or data.AppTopBanner.appTopBannerContentHeight else nil
	v7.appTopBannerContentHeight = v11
	local v12

	if not fFlagUseSignalsForAppTopBanner then
		if getFFlagLuaAppEnableTopBanner() then
			v12 = data.AppTopBanner.expanded and not data.AppTopBanner.isDisabled
		else
			v12 = false
		end
	end

	v7.appTopBannerVisible = v12
	return v7
end, function(callback)
	return {
		setScreenSize = function(p2)
			callback(SetScreenSize(p2))
		end,
		setDeviceOrientation = function(p2)
			if fFlagUseSignalsForDeviceOrientation then
				getDeviceOrientationStore(false).setDeviceOrientation(p2)
			end

			callback(module5(p2))
		end,
		setFormFactor = function(p2)
			callback(setFormFactor(p2))
		end,
		setStatusBarHeight = function(p2)
			callback(module6(p2))
		end,
		setGlobalGuiInset = function(p2, p3, p4, p5)
			return callback(module7(p2, p3, p4, p5))
		end,
		setGlobalContextMenuInset = function(p2, p3, p4, p5)
			if fFlagUseSignalsForGlobalContextMenuInset then
				return v5(false).setGlobalContextMenuInset(p2, p3, p4, p5)
			end

			return callback(module8(p2, p3, p4, p5))
		end
	}
end)(extended)

local v7 = roactServices.connect({
	guiService = appGuiService,
	runService = appRunService
})(v6)

local v8 = roactAppPolicy.connect(function(p2, p3)
	return {
		useWidthBasedRule = p2.getUseWidthBasedFormFactorRule()
	}
end)(v7)

return function(p2)
	local v9 = useIsSpatial()
	local v10 = useNavBarPlacement()
	local v11 = useNavBarSize()
	local joined = Cryo.Dictionary.join(p2, {
		use3DPanels = v9,
		navBarPlacement = v10,
		navBarSize = v11
	})

	if fFlagUseSignalsForScreenGuiBlur then
		local v12 = useSignalState(getScreenGuiBlurStore(false).getHasBlur)
		joined = Cryo.Dictionary.union(joined, { hasScreenGuiBlur = v12 })
	end

	if fFlagUseSignalsForAppTopBanner then
		local appTopBannerStore = getAppTopBannerStore(false)
		local v12 = useSignalState(appTopBannerStore.getAppTopBannerContentHeight)
		local v13 = useSignalState(appTopBannerStore.getIsVisible)
		local union = Cryo.Dictionary.union
		local v14 = {
			appTopBannerContentHeight = not getFFlagLuaAppEnableTopBanner() and 0 or v12,
			appTopBannerVisible = 0
		}

		if not getFFlagLuaAppEnableTopBanner() then
			v13 = false
		end

		v14.appTopBannerVisible = v13
		joined = union(joined, v14)
	end

	return Roact.createElement(v8, joined)
end
