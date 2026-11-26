local CorePackages = game:GetService("CorePackages")

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local AppStorageService = game:GetService("AppStorageService")
local GuiService = game:GetService("GuiService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")

local module = require("@luauforge/deferred/fGp")
local uiScaleOptions = require("@game/CorePackages/Workspace/Packages/Responsive").UIScaleOptions
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module2 = require("@luauforge/bundled/ecq")
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local Foundation = require(CorePackages.Packages.Foundation)

local inputSize = Foundation.Enums.InputSize

local toggle = Foundation.Toggle
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local dropdownMenu = UIBlox.App.Menu.DropdownMenu
local Foundation2 = require(CorePackages.Packages.Foundation)
local useTokens = Foundation2.Hooks.useTokens
local slider = Foundation.Slider
local segmentedControl = Foundation.SegmentedControl

local module3 = require("@luauforge/bundled/dzD")
local module4 = require("@luauforge/bundled/egZ")
local formFactor = require("@luauforge/bundled/dGN").Enums.FormFactor

local module5 = require("@luauforge/bundled/fzS")
local module6 = require("@luauforge/bundled/fGs")
local module7 = require("@luauforge/bundled/fGt")
local module8 = require("@luauforge/deferred/fGu")
local module9 = require("@luauforge/deferred/fGv")
local module10 = require("@luauforge/bundled/fGw")

local module11 = require("@luauforge/deferred/fGx")
local module12 = require("@luauforge/deferred/fGz")
local module13 = require("@luauforge/deferred/fGC")
local module14 = require("@luauforge/deferred/fGE")
local appearanceContext = require("@game/CorePackages/Workspace/Packages/Style").AppearanceContext

local module15 = require("@luauforge/deferred/fGF")
local module16 = require("@luauforge/deferred/fGH")
local module17 = require("@luauforge/deferred/fGY")
local Cryo = require(CorePackages.Packages.Cryo)

local module18 = require("@luauforge/bundled/fGL")
local systemThemeEnabled = module18.GetSystemThemeEnabled()
local systemThemeService = module18.GetSystemThemeService()
local systemThemeEnum = module18.GetSystemThemeEnum()
local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").Logger

local default = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Utils.AppStorageJsonCacheUtils.default
local localStorageKey = require("@luauforge/bundled/dFv").Enums.LocalStorageKey

local module19 = require("@luauforge/deferred/fHb")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")

local getFFlagEnablePartyVoiceVolumeOnlyWhenInEligibleParty = SharedFlags.GetFFlagEnablePartyVoiceVolumeOnlyWhenInEligibleParty
local fFlagMacMenuBarContentUpdates = SharedFlags.GetFFlagMacMenuBarContentUpdates()
local fFlagUIScaleEngineOptions = SharedFlags.FFlagUIScaleEngineOptions
local getFFlagEnableReadAloudInUA = SharedFlags.GetFFlagEnableReadAloudInUA
local getFFlagSystemTrayEnabled = SharedFlags.GetFFlagSystemTrayEnabled
local getFFlagHideLaunchAtStartupMac = SharedFlags.GetFFlagHideLaunchAtStartupMac
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useLocalUserId
local module21 = require("@luauforge/bundled/fHc")
local getFFlagEnableVREnvironmentSetting = SharedFlags.GetFFlagEnableVREnvironmentSetting
local getFFlagEnableSkyStyle = SharedFlags.GetFFlagEnableSkyStyle
local getFFlagLuaAppCustomizableEntryPoint = SharedFlags.GetFFlagLuaAppCustomizableEntryPoint

local default2 = require("@luauforge/bundled/fHd").IXPManager.default
local module22 = require("@luauforge/bundled/fHe")
local module23 = require("@luauforge/bundled/fGJ")

local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local fFlagUseSignalsForPlatform = SharedFlags.FFlagUseSignalsForPlatform
local fFlagUnifyConsoleSettingsPage = SharedFlags.FFlagUnifyConsoleSettingsPage
local fFlagEnableSettingsTelemetry = SharedFlags.FFlagEnableSettingsTelemetry

local v5 = if fFlagUseSignalsForPlatform then require("@luauforge/bundled/fGm") else nil

local module24 = require("@luauforge/bundled/fBQ")
local module25 = require("@luauforge/bundled/fBO")
local module26 = require("@luauforge/bundled/fHg")
local module27 = require("@luauforge/bundled/fHi")
local module28 = require("@luauforge/deferred/fHo")
local fFlagAppIconSelectionPage = SharedFlags.FFlagAppIconSelectionPage

local v6 = if fFlagAppIconSelectionPage then require("@luauforge/deferred/fHA") else nil

local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")
local module30 = require("@luauforge/bundled/fHx")
local module31 = require("@luauforge/bundled/fBM")
local module32 = require("@luauforge/bundled/fHr")

local module33 = require("@luauforge/deferred/fGB")

local module34 = require("@luauforge/deferred/fHK")
local module35 = require("@luauforge/bundled/fHL")
local module36 = require("@luauforge/bundled/fHp")

local v7 = default2 and default2.getHasPartyVoiceVolume()

local deviceLevelThemeKey = module6.DeviceLevelThemeKey
local LAYOUT_ORDER = module6.LAYOUT_ORDER

local keys = module24.Keys
local robloxThemeKeys = module24.RobloxThemeKeys

local useIsSpatial = require("@game/CorePackages/Workspace/Packages/Responsive").useIsSpatial

local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy

local function createLayoutOrderGenerator()
	local count = 0
	return function(p2)
		if p2 then
			return LAYOUT_ORDER[p2]
		end

		count += 1
		return count
	end
end

local extended = Roact.PureComponent:extend("DeviceSettingsPageContent")

if systemThemeEnabled then
	local strictInterface = t.strictInterface
	local v8 = {
		formFactor = t.string,
		platform = t.EnumItem,
		themeSelectedCallback = t.callback,
		themeCellHeight = t.UDim,
		userId = t.string,
		screenSize = t.Vector2,
		isSpatial = t.optional(t.boolean),
		isMacVariant = 0,
		robloxPlusTheme = 0,
		renderedThemeName = 0,
		setRobloxPlusTheme = 0,
		showRobloxPlusThemeSetting = 0,
		showAppIconSetting = 0,
		canChangeRobloxPlusTheme = 0,
		canSeeExclusiveThemes = 0,
		isUpdatingRobloxPlusTheme = 0,
		roactAnalytics = 0
	}
	local v9 = if fFlagMacMenuBarContentUpdates then t.optional(t.boolean) else nil
	v8.isMacVariant = v9
	v8.robloxPlusTheme = t.optional(t.string)
	v8.renderedThemeName = t.optional(t.string)
	v8.setRobloxPlusTheme = t.optional(t.callback)
	v8.showRobloxPlusThemeSetting = t.optional(t.boolean)
	v8.showAppIconSetting = t.optional(t.boolean)
	v8.canChangeRobloxPlusTheme = t.optional(t.boolean)
	v8.canSeeExclusiveThemes = t.optional(t.boolean)
	v8.isUpdatingRobloxPlusTheme = t.optional(t.boolean)

	v8.roactAnalytics = t.union(t.Instance, t.table)
	extended.validateProps = strictInterface(v8)
else
	local strictInterface = t.strictInterface
	local v8 = {
		formFactor = t.string,
		platform = t.EnumItem,
		isSpatial = t.optional(t.boolean),
		isMacVariant = 0,
		robloxPlusTheme = 0,
		renderedThemeName = 0,
		setRobloxPlusTheme = 0,
		showRobloxPlusThemeSetting = 0,
		showAppIconSetting = 0,
		canChangeRobloxPlusTheme = 0,
		canSeeExclusiveThemes = 0,
		isUpdatingRobloxPlusTheme = 0,
		roactAnalytics = 0
	}
	local v9 = if fFlagMacMenuBarContentUpdates then t.optional(t.boolean) else nil
	v8.isMacVariant = v9
	v8.robloxPlusTheme = t.optional(t.string)
	v8.renderedThemeName = t.optional(t.string)
	v8.setRobloxPlusTheme = t.optional(t.callback)
	v8.showRobloxPlusThemeSetting = t.optional(t.boolean)
	v8.showAppIconSetting = t.optional(t.boolean)
	v8.canChangeRobloxPlusTheme = t.optional(t.boolean)
	v8.canSeeExclusiveThemes = t.optional(t.boolean)
	v8.isUpdatingRobloxPlusTheme = t.optional(t.boolean)

	v8.roactAnalytics = t.union(t.Instance, t.table)
	extended.validateProps = strictInterface(v8)
end

function extended:eventDisconnect()
	if self.onReducedMotionChangedSignal then
		self.onReducedMotionChangedSignal:Disconnect()
		self.onReducedMotionChangedSignal = nil
	end

	if self.onPreferredTransparencyChangedSignal then
		self.onPreferredTransparencyChangedSignal:Disconnect()
		self.onPreferredTransparencyChangedSignal = nil
	end

	if self.onPreferredTextSizeChangedSignal then
		self.onPreferredTextSizeChangedSignal:Disconnect()
		self.onPreferredTextSizeChangedSignal = nil
	end

	if fFlagUIScaleEngineOptions then
		if self.onUIScaleMultiplierChangedSignal then
			self.onUIScaleMultiplierChangedSignal:Disconnect()
			self.onUIScaleMultiplierChangedSignal = nil
		end

		if self.onUIScaleViewportChangedSignal then
			self.onUIScaleViewportChangedSignal:Disconnect()
			self.onUIScaleViewportChangedSignal = nil
		end

		if self.onUIScaleCurrentCameraChangedSignal then
			self.onUIScaleCurrentCameraChangedSignal:Disconnect()
			self.onUIScaleCurrentCameraChangedSignal = nil
		end

		if self.onUIScaleDisplayPollConnection then
			self.onUIScaleDisplayPollConnection:Disconnect()
			self.onUIScaleDisplayPollConnection = nil
		end
	end

	if self.onUiNavigationKeyBindEnabledChanged then
		self.onUiNavigationKeyBindEnabledChanged:Disconnect()
		self.onUiNavigationKeyBindEnabledChanged = nil
	end

	if self.onKeyboardEnabledChangedSignal then
		self.onKeyboardEnabledChangedSignal:Disconnect()
		self.onKeyboardEnabledChangedSignal = nil
	end

	if getFFlagEnableReadAloudInUA() and self.onReadAloudChangedSignal then
		self.onReadAloudChangedSignal:Disconnect()
		self.onReadAloudChangedSignal = nil
	end
end

function extended:init()
	local function preferredTransparencySliderValueFromValue(p2)
		return 10 - math.clamp(math.floor(p2 * 10 + 0.5), 0, 10)
	end

	local function preferredTextSizeSliderValueFromValue(p2)
		return p2.Value - 1
	end

	local function appStorageItem(p2): nil | boolean
		if getFFlagSystemTrayEnabled() then
			return AppStorageService:GetItem(p2) == "true"
		end

		return nil
	end

	local v8 = if fFlagUIScaleEngineOptions then uiScaleOptions.get(GuiService) else nil
	local v9 = {
		keyboardEnabled = UserInputService.KeyboardEnabled,
		reducedMotionEnabled = UserGameSettings.ReducedMotion,
		preferredTransparencyValue = 10 - math.clamp(
			math.floor(UserGameSettings.PreferredTransparency * 10 + 0.5),
			0,
			10
		),
		preferredTextSizeValue = UserGameSettings.PreferredTextSize.Value - 1,
		shownUIScaleOptions = v8,
		uiNavigationKeyBindEnabled = UserGameSettings.UiNavigationKeyBindEnabled,
		readAloudEnabled = 0,
		isLocalPlayerPartyVoiceEligible = false,
		isLaunchAtStartupEnabled = 0,
		isMinimizeToTrayEnabled = 0,
		openDropdownSetting = ""
	}
	local v10 = if getFFlagEnableReadAloudInUA() then UserGameSettings.ReadAloud else nil
	v9.readAloudEnabled = v10

	local launchAtStartup = localStorageKey.LaunchAtStartup
	local v11 = if getFFlagSystemTrayEnabled() then AppStorageService:GetItem(launchAtStartup) == "true" else nil

	v9.isLaunchAtStartupEnabled = v11
	local minimizeToTray = localStorageKey.MinimizeToTray
	local v12 = if getFFlagSystemTrayEnabled() then AppStorageService:GetItem(minimizeToTray) == "true" else nil

	v9.isMinimizeToTrayEnabled = v12
	self.state = v9

	function self.getDropdownRowZIndex(p2): number
		if self.state.openDropdownSetting == p2 then
			return 3
		end

		return 2
	end

	function self.reportSettingToggle(p2, p3, p4)
		if fFlagEnableSettingsTelemetry then
			module10.reportSettingToggle(p2, p3, p4)
		end
	end

	function self.onDropdownMenuOpenChange(p2, p3)
		self:setState(function(p4)
			local openDropdownSetting = p4.openDropdownSetting

			return {
				openDropdownSetting = if p3 then p2 else openDropdownSetting == p2 and "" or openDropdownSetting
			}
		end)
	end

	if getFFlagSystemTrayEnabled() and not getFFlagHideLaunchAtStartupMac() then
		function self.onLaunchAtStartupActivated()
			local isLaunchAtStartupEnabled = self.state.isLaunchAtStartupEnabled
			local v13 = not isLaunchAtStartupEnabled

			AppStorageService:SetItem(localStorageKey.LaunchAtStartup, (tostring(v13)))
			AppStorageService:Flush()

			self:setState({ isLaunchAtStartupEnabled = v13 })

			self.reportSettingToggle(module7.LaunchAtStartup, isLaunchAtStartupEnabled, v13)
		end

		function self.onMinimizeToTrayActivated()
			local isMinimizeToTrayEnabled = self.state.isMinimizeToTrayEnabled
			local v13 = not isMinimizeToTrayEnabled

			AppStorageService:SetItem(localStorageKey.MinimizeToTray, (tostring(v13)))
			AppStorageService:Flush()

			self:setState({ isMinimizeToTrayEnabled = v13 })

			self.reportSettingToggle(module7.MinimizeToTray, isMinimizeToTrayEnabled, v13)
		end
	end

	function self.onReducedMotionActivated()
		local reducedMotionEnabled = self.state.reducedMotionEnabled
		local v13 = not self.state.reducedMotionEnabled
		UserGameSettings.ReducedMotion = v13
		module8(
			self.props.roactAnalytics.EventStream,
			module5.Context.AccessibilitySettingsPage,
			"ReducedMotion",
			tostring(reducedMotionEnabled),
			(tostring(v13))
		)

		self.reportSettingToggle(module7.ReducedMotion, reducedMotionEnabled, v13)
	end

	self.onReducedMotionChangedSignal = UserGameSettings:GetPropertyChangedSignal("ReducedMotion"):Connect(function()
		self:setState({ reducedMotionEnabled = UserGameSettings.ReducedMotion })
	end)

	if getFFlagEnableReadAloudInUA() then
		function self.onReadAloudActivated()
			local readAloudEnabled = self.state.readAloudEnabled
			local v13 = not self.state.readAloudEnabled
			UserGameSettings.ReadAloud = v13
			module8(
				self.props.roactAnalytics.EventStream,
				module5.Context.AccessibilitySettingsPage,
				module7.ReadAloud,
				tostring(readAloudEnabled),
				(tostring(v13))
			)

			self.reportSettingToggle(module7.ReadAloud, readAloudEnabled, v13)
		end

		self.onReadAloudChangedSignal = UserGameSettings:GetPropertyChangedSignal("ReadAloud"):Connect(function()
			self:setState({ readAloudEnabled = UserGameSettings.ReadAloud })
		end)
	end

	function self.onPreferredTransparencyValueChanged(p2)
		local preferredTransparency = UserGameSettings.PreferredTransparency
		local v13 = (10 - math.clamp(math.floor(p2), 0, 10)) / 10
		UserGameSettings.PreferredTransparency = v13
		module8(
			self.props.roactAnalytics.EventStream,
			module5.Context.AccessibilitySettingsPage,
			"PreferredTransparency",
			tostring(preferredTransparency),
			(tostring(v13))
		)

		self.reportSettingToggle(module7.PreferredTransparency, preferredTransparency, v13)
	end

	self.onPreferredTransparencyChangedSignal = UserGameSettings:GetPropertyChangedSignal("PreferredTransparency"):Connect(function()
		self:setState({
			preferredTransparencyValue = 10 - math.clamp(
				math.floor(UserGameSettings.PreferredTransparency * 10 + 0.5),
				0,
				10
			)
		})
	end)

	function self.onPreferredTextSizeValueChanged(p2)
		local preferredTextSize = UserGameSettings.PreferredTextSize
		local v13 = Enum.PreferredTextSize:GetEnumItems()[p2 + 1]
		UserGameSettings.PreferredTextSize = v13
		module8(
			self.props.roactAnalytics.EventStream,
			module5.Context.AccessibilitySettingsPage,
			"PreferredTextSize",
			tostring(preferredTextSize),
			(tostring(v13))
		)

		self.reportSettingToggle(module7.PreferredTextSize, preferredTextSize, v13)
	end
	self.onPreferredTextSizeChangedSignal = UserGameSettings:GetPropertyChangedSignal("PreferredTextSize"):Connect(function()
		self:setState({
			preferredTextSizeValue = UserGameSettings.PreferredTextSize.Value - 1
		})
	end)

	if fFlagUIScaleEngineOptions then
		function self.onUIScaleModeActivated(p2)
			local v13 = uiScaleOptions.get(GuiService)

			if not v13 then
				return
			end

			local v14 = p2 == "Manual"
			local valueForMode = uiScaleOptions.valueForMode(v13, v14)

			if valueForMode == nil then
				return
			end

			GuiService:SetUIScaleMultiplier(valueForMode)
			module8(
				self.props.roactAnalytics.EventStream,
				module5.Context.AccessibilitySettingsPage,
				"UIScaleMode",
				v14 and "auto" or "manual",
				v14 and "manual" or "auto"
			)

			self.reportSettingToggle(module7.UIScaleMode, not v14, v14)
		end

		function self.onUIScaleOptionChanged(value)
			local v13 = uiScaleOptions.get(GuiService)

			if type(value) ~= "string" or not v13 or v13.savedHundredths == 0 then
				return
			end

			local savedHundredths = v13.savedHundredths

			local valueFromOption = uiScaleOptions.valueFromOption(value, v13)

			if valueFromOption and valueFromOption ~= savedHundredths then
				GuiService:SetUIScaleMultiplier(valueFromOption)
				module8(
					self.props.roactAnalytics.EventStream,
					module5.Context.AccessibilitySettingsPage,
					"UIScaleValue",
					tostring(savedHundredths),
					(tostring(valueFromOption))
				)

				self.reportSettingToggle(module7.UIScale, savedHundredths, valueFromOption)
			end
		end

		local function fn()
			local v13 = uiScaleOptions.get(GuiService)
			local shownUIScaleOptions = self.state.shownUIScaleOptions

			if v13 and not (shownUIScaleOptions and uiScaleOptions.equal(v13, shownUIScaleOptions)) then
				self:setState({ shownUIScaleOptions = v13 })
			end
		end

		self.onUIScaleMultiplierChangedSignal = UserGameSettings:GetPropertyChangedSignal("UIScaleMultiplierHundredths"):Connect(fn)

		local total = 0
		self.onUIScaleDisplayPollConnection = RunService.Heartbeat:Connect(function(dt)
			total += dt

			if total < 0.1 then
				return
			end

			total = 0

			fn()
		end)

		self.onUIScaleCurrentCameraChangedSignal = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
			if self.onUIScaleViewportChangedSignal then
				self.onUIScaleViewportChangedSignal:Disconnect()
				self.onUIScaleViewportChangedSignal = nil
			end

			local currentCamera = workspace.CurrentCamera

			if currentCamera then
				self.onUIScaleViewportChangedSignal = currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fn)
			end

			fn()
		end)

		if self.onUIScaleViewportChangedSignal then
			self.onUIScaleViewportChangedSignal:Disconnect()
			self.onUIScaleViewportChangedSignal = nil
		end

		local currentCamera = workspace.CurrentCamera

		if currentCamera then
			self.onUIScaleViewportChangedSignal = currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fn)
		end
	end

	function self.onUiNavigationKeyBindActivated()
		local uiNavigationKeyBindEnabled = self.state.uiNavigationKeyBindEnabled
		local v13 = not self.state.uiNavigationKeyBindEnabled
		UserGameSettings.UiNavigationKeyBindEnabled = v13
		module8(
			self.props.roactAnalytics.EventStream,
			module5.Context.AccessibilitySettingsPage,
			"UiNavigationKeyBind",
			tostring(uiNavigationKeyBindEnabled),
			(tostring(v13))
		)

		self.reportSettingToggle(module7.UINavigationKeyBind, uiNavigationKeyBindEnabled, v13)
	end

	self.onUiNavigationKeyBindEnabledChanged = UserGameSettings:GetPropertyChangedSignal("UiNavigationKeyBindEnabled"):Connect(function()
		self:setState({
			uiNavigationKeyBindEnabled = UserGameSettings.UiNavigationKeyBindEnabled
		})
	end)

	self.onKeyboardEnabledChangedSignal = UserInputService:GetPropertyChangedSignal("KeyboardEnabled"):Connect(function()
		self:setState({ keyboardEnabled = UserInputService.KeyboardEnabled })
	end)

	local v13 = module9

	function self.onAppThemeSubscribeClicked()
		v13.reportSubscribeClick(self.props.canChangeRobloxPlusTheme == true)
	end

	function self.onAppThemeSelected(p2)
		v13.reportThemeSelected(self.props.canChangeRobloxPlusTheme == true, p2)
	end
end

local function Divider(p2)
	local style = p2.style
	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 1),
		BorderSizePixel = 0,
		BackgroundColor3 = style.Theme.Divider.Color,
		BackgroundTransparency = style.Theme.Divider.Transparency,
		LayoutOrder = p2.layoutOrder
	})
end

local function getThemeDropdownProperties(data, userId)
	local v8 = nil
	local v9 = nil

	if systemThemeEnabled and systemThemeEnum then
		local result = default:decodeInternal(module18.DeviceLevelThemeLocalStorageKey).result
		local v10 = result and result[userId] or nil

		if v10 then
			local systemThemeEnum2 = systemThemeEnum.getSystemThemeEnum(v10)

			if systemThemeEnum2 == systemThemeEnum.Light then
				v8 = deviceLevelThemeKey.Light
				v9 = data.deviceLevelThemeLight
			elseif systemThemeEnum2 == systemThemeEnum.Dark then
				v8 = deviceLevelThemeKey.Dark
				v9 = data.deviceLevelThemeDark
			elseif
				systemThemeEnum2 == systemThemeEnum.SystemLight
				or systemThemeEnum2 == systemThemeEnum.SystemDark
			then
				v8 = deviceLevelThemeKey.System
				v9 = data.deviceLevelThemeSystem
			end
		end
	end

	local deviceLevelThemeLight = module21()
		and systemThemeEnabled
		and (v9 == nil or v9 == "")
		and (data.deviceLevelThemeLight or data.deviceLevelThemeDark or data.deviceLevelThemeSystem or "")
		or v9

	return v8, module21() and deviceLevelThemeLight == nil and "" or deviceLevelThemeLight
end

function extended:renderWithProviders(data, p2, props2)
	local v8 = self.props.formFactor == formFactor.WIDE
	local count = 0
	local function fn(p3)
		if p3 then
			return LAYOUT_ORDER[p3]
		end

		count += 1
		return count
	end

	local userId = self.props.userId

	local isSpatial = self.props.isSpatial
	local v9 = not isSpatial
	local v10 = not isSpatial
	local v11 = fFlagUIScaleEngineOptions and not isSpatial
	local keyboardEnabled = module19() and self.state.keyboardEnabled

	local v12 = props2.Font.BaseSize * props2.Font.CaptionBody.RelativeSize
	local v13 = props2.Tokens.Stroke.Standard * module6.CONTEXTUAL_SLIDER_BASE_WIDTH
	local v14, v15

	if systemThemeEnabled then
		v14, v15 = getThemeDropdownProperties(data, userId)
	end

	local v16 = nil
	local v17

	if v11 and self.state.shownUIScaleOptions then
		local shownUIScaleOptions = self.state.shownUIScaleOptions
		v17 = {}

		for k, value in shownUIScaleOptions.values do
			local optionId = uiScaleOptions.optionId(k, value)
			local v18 = `{value / 100}x`

			if k == shownUIScaleOptions.defaultIndex then
				v18 = data.uiScaleDefault
			end

			v17[k] = {
				id = optionId,
				text = v18,
				isDisabled = not shownUIScaleOptions.enabled[k]
			}

			if k == self.state.shownUIScaleOptions.selectedIndex then
				v16 = optionId
			end
		end
	end

	local v18 = module31 and self.props.renderedThemeName == module24.Halloween2026

	if v18 then
		v14 = deviceLevelThemeKey.Dark
		v15 = data.deviceLevelThemeDark
	end

	local v19 = v18 and "ColorModeLockedToDark" or nil
	local v20 = self.props.showRobloxPlusThemeSetting == true and self.props.setRobloxPlusTheme ~= nil
	local canChangeRobloxPlusTheme = self.props.canChangeRobloxPlusTheme == true
	local canSeeExclusiveThemes = self.props.canSeeExclusiveThemes ~= false
	local v21 = {}

	for k, key in keys do
		v21[key] = data[`appThemeName{key}`]
	end

	local v22 = robloxThemeKeys
	local v23 = keys

	if module32 then
		local featuredThemeKeys = module36.getFeaturedThemeKeys(
			canChangeRobloxPlusTheme,
			not canSeeExclusiveThemes
		)

		if #featuredThemeKeys > 0 then
			v22 = Cryo.List.join(robloxThemeKeys, featuredThemeKeys)
			v23 = Cryo.List.filter(keys, function(p3): boolean
				return not table.find(featuredThemeKeys, p3)
			end)
		end
	end

	local function onChange(p3)
		if getFFlagEnablePartyVoiceVolumeOnlyWhenInEligibleParty() then
			self:setState({ isLocalPlayerPartyVoiceEligible = p3 })
		end
	end

	local v24 = if getFFlagLuaAppCustomizableEntryPoint() then require("@luauforge/deferred/fHM") else nil

	local createFragment = Roact.createFragment

	local v25 = if v9 then Roact.createElement(module11, {
		style = props2,
		header = data.reducedMotionHeader,
		description = data.reducedMotionDescription,
		layoutOrder = fn(module7.ReducedMotion),
		Control = Roact.createElement(toggle, {
			isChecked = self.state.reducedMotionEnabled,
			onActivated = self.onReducedMotionActivated,
			label = "",
			size = inputSize.Large
		})
	}) else nil

	local v26 = if v9 then Divider({
		style = props2,
		layoutOrder = fn(module7.PreferredTransparencyDivider)
	}) else nil
	local v27

	if v10 then
		local createElement = Roact.createElement
		local v29 = {
			style = props2,
			header = data.preferredTransparencyHeader,
			description = data.preferredTransparencyDescription,
			layoutOrder = fn(module7.PreferredTransparency),
			topToBottom = not v8,
			Control = 0
		}

		local createElement2 = Roact.createElement
		local v32 = if v8 then UDim2.new(0, v13, 0, 0) else UDim2.fromScale(1, 0)
		local v31 = {
			Size = v32,
			AutomaticSize = Enum.AutomaticSize.Y,
			BorderSizePixel = 0,
			BackgroundTransparency = 1
		}

		local children2 = {
			Layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.Name,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, module3.MORE_PAGE_SECTION_PADDING)
			}),
			ContextualSlider = 0,
			Frame = 0
		}

		local createElement3 = Roact.createElement
		local v34 = {
			width = UDim.new(1, 0),
			range = NumberRange.new(0, 10),
			value = self.state.preferredTransparencyValue,
			onValueChanged = self.onPreferredTransparencyValueChanged,
			size = Foundation.Enums.InputSize.Large,
			knobVisibility = Foundation.Enums.ScrollBarVisibility.Always,
			variant = 0,
			step = 1
		}

		local v35 = if module33 then Foundation.Enums.SliderVariant.Standard else Foundation.Enums.SliderVariant.Emphasis
		v34.variant = v35
		children2.ContextualSlider = createElement3(slider, v34)

		children2.Frame = Roact.createElement(
			"Frame",
			{
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BorderSizePixel = 0,
				BackgroundTransparency = 1
			},
			{
				UIPadding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, fFlagUnifyConsoleSettingsPage and 0 or -10)
				}),
				LeftText = Roact.createElement("TextLabel", {
					Size = UDim2.fromScale(1, 0),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Text = data.preferredTransparencyTransparent,
					FontFace = normalizeFontFace(props2.Tokens.Typography.BodySmall.Font),
					TextSize = v12,
					TextColor3 = props2.Theme.TextMuted.Color,
					TextTransparency = props2.Theme.TextMuted.Transparency,
					TextXAlignment = Enum.TextXAlignment.Left,
					LayoutOrder = 1
				}),
				RightText = Roact.createElement("TextLabel", {
					Size = UDim2.fromScale(1, 0),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Text = data.preferredTransparencyOpaque,
					FontFace = normalizeFontFace(props2.Tokens.Typography.BodySmall.Font),
					TextSize = v12,
					TextColor3 = props2.Theme.TextMuted.Color,
					TextTransparency = props2.Theme.TextMuted.Transparency,
					TextXAlignment = Enum.TextXAlignment.Right,
					LayoutOrder = 2
				})
			}
		)
		v29.Control = createElement2("Frame", v31, children2)
		v27 = createElement(module11, v29)
	end

	local v28 = if v10 or fFlagUIScaleEngineOptions then Divider({
		style = props2,
		layoutOrder = fn(module7.PreferredTextSizeDivider)
	}) else nil

	local createElement = Roact.createElement
	local v30 = {
		style = props2,
		header = data.preferredTextSizeHeader,
		description = data.preferredTextSizeDescription,
		layoutOrder = fn(module7.PreferredTextSize),
		topToBottom = not v8,
		Control = 0
	}

	local createElement2 = Roact.createElement
	local v33 = if v8 then UDim2.new(0, v13, 0, 0) else UDim2.fromScale(1, 0)
	local v32 = {
		Size = v33,
		AutomaticSize = Enum.AutomaticSize.Y,
		BorderSizePixel = 0,
		BackgroundTransparency = 1
	}

	local children2 = {
		Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.Name,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, module3.MORE_PAGE_SECTION_PADDING)
		}),
		ContextualSlider = 0,
		Frame = 0
	}

	local createElement3 = Roact.createElement
	local v35 = {
		width = UDim.new(1, 0),
		range = NumberRange.new(0, 3),
		value = self.state.preferredTextSizeValue,
		onValueChanged = self.onPreferredTextSizeValueChanged,
		size = Foundation.Enums.InputSize.Large,
		knobVisibility = Foundation.Enums.ScrollBarVisibility.Always,
		variant = 0,
		step = 1
	}

	local v36 = if module33 then Foundation.Enums.SliderVariant.Standard else Foundation.Enums.SliderVariant.Emphasis
	v35.variant = v36
	children2.ContextualSlider = createElement3(slider, v35)

	children2.Frame = Roact.createElement(
		"Frame",
		{
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BorderSizePixel = 0,
			BackgroundTransparency = 1
		},
		{
			UIPadding = Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, fFlagUnifyConsoleSettingsPage and 0 or -10)
			}),
			LeftText = Roact.createElement("TextLabel", {
				Size = UDim2.fromScale(1, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Text = data.preferredTextSizeDefault,
				FontFace = normalizeFontFace(props2.Tokens.Typography.BodySmall.Font),
				TextSize = v12,
				TextColor3 = props2.Theme.TextMuted.Color,
				TextTransparency = props2.Theme.TextMuted.Transparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				LayoutOrder = 1
			}),
			RightText = Roact.createElement("TextLabel", {
				Size = UDim2.fromScale(1, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Text = data.preferredTextSizeLargest,
				FontFace = normalizeFontFace(props2.Tokens.Typography.BodySmall.Font),
				TextSize = v12,
				TextColor3 = props2.Theme.TextMuted.Color,
				TextTransparency = props2.Theme.TextMuted.Transparency,
				TextXAlignment = Enum.TextXAlignment.Right,
				LayoutOrder = 2
			})
		}
	)
	v30.Control = createElement2("Frame", v32, children2)
	local children = {}
	children.ReducedMotion = v25
	children.Divider1 = v26
	children.PreferredTransparency = v27
	children.Divider2 = v28
	children.PreferredTextSize = createElement(module11, v30)

	local v37 = if v11 and self.state.shownUIScaleOptions then Divider({
		style = props2,
		layoutOrder = fn(module7.UIScaleModeDivider)
	}) else nil
	children.UIScaleModeDivider = v37

	local v38 = if v11 and self.state.shownUIScaleOptions then Roact.createElement(module11, {
		style = props2,
		header = data.uiScaleModeHeader,
		description = data.uiScaleManualDescription,
		layoutOrder = fn(module7.UIScaleMode),
		topToBottom = not v8,
		Control = Roact.createElement(segmentedControl, {
			testId = "--devicesettings-segmentedcontrol-uiscalemode",
			segments = {
				{ id = "Auto", text = data.uiScaleModeAuto },
				{ id = "Manual", text = data.uiScaleModeManual }
			},
			value = self.state.shownUIScaleOptions.savedHundredths == 0 and "Auto" or "Manual",
			onActivated = self.onUIScaleModeActivated,
			size = inputSize.Large,
			isCircular = true
		})
	}) else nil
	children.UIScaleMode = v38
	local v39

	if
		v11
		and self.state.shownUIScaleOptions
		and self.state.shownUIScaleOptions.savedHundredths ~= 0
		and v17
	then
		local createElement4 = Roact.createElement
		local v41 = {
			style = props2,
			header = data.uiScaleHeader,
			description = data.uiScaleDescription,
			layoutOrder = fn(module7.UIScale),
			topToBottom = not v8,
			Control = 0
		}

		local createElement5 = Roact.createElement
		local v43 = {
			items = v17,
			value = v16,
			onItemChanged = self.onUIScaleOptionChanged,
			width = 0,
			maxHeight = 0
		}
		local v44 = if v8 then UDim.new(0, v13) else UDim.new(1, 0)
		v43.width = v44
		v43.maxHeight = props2.Tokens.Size.Size_1200 * #v17
		v41.Control = createElement5(module, v43)
		v39 = createElement4(module11, v41)
	end

	children.UIScaleDropdown = v39

	local v40 = if keyboardEnabled then Divider({
		style = props2,
		layoutOrder = fn(module7.UINavigationKeyBindDivider)
	}) else nil
	children.Divider3 = v40

	local v41 = if keyboardEnabled then Roact.createElement(module11, {
		style = props2,
		header = data.uiNavigationKeyBindHeader,
		description = data.uiNavigationKeyBindDescription,
		layoutOrder = fn(module7.UINavigationKeyBind),
		Control = Roact.createElement(toggle, {
			isChecked = self.state.uiNavigationKeyBindEnabled,
			onActivated = self.onUiNavigationKeyBindActivated,
			label = "",
			size = inputSize.Large
		})
	}) else nil
	children.UiNavigationKeyBind = v41

	local v42 = if v9 or not fFlagUIScaleEngineOptions then Divider({
		style = props2,
		layoutOrder = fn(module7.ReducedMotionDivider)
	}) else nil
	children.Divider4 = v42

	children.MasterVolume = Roact.createElement(module12, {
		layoutOrder = fn(module7.MasterVolume)
	})

	local v43 = if v7 and (not getFFlagEnablePartyVoiceVolumeOnlyWhenInEligibleParty() or self.state.isLocalPlayerPartyVoiceEligible) then Divider({
		style = props2,
		layoutOrder = fn(module7.PartyVoiceVolumeDivider)
	}) else nil
	children.Divider5 = v43

	local v44 = if v7 and (not getFFlagEnablePartyVoiceVolumeOnlyWhenInEligibleParty() or self.state.isLocalPlayerPartyVoiceEligible) then Roact.createElement(module13, {
		layoutOrder = fn(module7.PartyVoiceVolume)
	}) else nil
	children.PartyVoiceVolume = v44

	children.Divider6 = Divider({
		style = props2,
		layoutOrder = fn(module7.HapticsDivider)
	})

	children.HapticsToggle = Roact.createElement(module14, {
		layoutOrder = fn(module7.Haptics)
	})

	local v45 = if systemThemeEnabled then Divider({
		style = props2,
		layoutOrder = fn(module7.DeviceLevelThemeDivider)
	}) else nil
	children.Divider7 = v45
	local v46

	if systemThemeEnabled then
		local createElement4 = Roact.createElement
		local v48 = {
			style = props2,
			header = data.appThemeModeHeading,
			description = data.appThemeModeDescription,
			layoutOrder = fn(module7.DeviceLevelTheme),
			zIndex = self.getDropdownRowZIndex(module7.DeviceLevelTheme),
			topToBottom = not v8,
			Control = 0
		}

		local createElement5 = Roact.createElement

		local v51 = if v8 then UDim2.new(0, v13, 0, self.props.themeCellHeight.Offset) else UDim2.new(1, 0, 0, self.props.themeCellHeight.Offset)
		v48.Control = createElement5(
			"Frame",
			{ Size = v51, BorderSizePixel = 0, BackgroundTransparency = 1 },
			{ Roact.createElement(dropdownMenu, {
					key = v19,
					isDisabled = v18,
					placeholder = v15,
					onChange = self.props.themeSelectedCallback,
					height = self.props.themeCellHeight,
					screenSize = self.props.screenSize,
					errorState = false,
					showDropShadow = false,
					dropdownMenuListPositionFixed = true,
					onMenuOpenChange = function(p3)
						self.onDropdownMenuOpenChange(module7.DeviceLevelTheme, p3)
					end,
					defaultKey = v14,
					cellDatas = {
						{
							key = deviceLevelThemeKey.System,
							text = data.deviceLevelThemeSystem
						},
						{
							key = deviceLevelThemeKey.Dark,
							text = data.deviceLevelThemeDark
						},
						{
							key = deviceLevelThemeKey.Light,
							text = data.deviceLevelThemeLight
						}
					}
				}) }
		)
		v46 = createElement4(module11, v48)
	end

	children.DeviceLevelThemeDropdown = v46

	local v47 = if getFFlagLuaAppCustomizableEntryPoint() then Divider({
		style = props2,
		layoutOrder = fn(module7.LaunchDestinationDivider)
	}) else nil
	children.LaunchDestinationDivider = v47
	local v48

	if getFFlagLuaAppCustomizableEntryPoint() then
		v48 = React.createElement(v24, {
			layoutOrder = fn(module7.LaunchDestination),
			isWideView = v8,
			contextualSliderWidth = v13,
			screenSize = self.props.screenSize,
			zIndex = self.getDropdownRowZIndex(module7.LaunchDestination),
			onMenuOpenChange = function(p3)
				self.onDropdownMenuOpenChange(module7.LaunchDestination, p3)
			end
		})
	end

	children.LaunchDestination = v48
	local v49

	if v20 then
		local createElement4 = Roact.createElement
		local v51 = {
			style = props2,
			header = data.deviceAppThemeHeading,
			description = 0,
			layoutOrder = 0,
			zIndex = 0,
			topToBottom = true,
			Control = 0
		}

		local v52 = if canSeeExclusiveThemes then data.appThemeExclusiveDescription else data.deviceAppThemeDescription
		v51.description = v52

		v51.layoutOrder = fn(module7.RobloxPlusTheme)
		v51.zIndex = self.getDropdownRowZIndex(module7.RobloxPlusTheme)

		local createElement5 = Roact.createElement
		local v54 = {
			canChangeRobloxPlusTheme = canChangeRobloxPlusTheme,
			themeKeys = v23,
			themeLabels = v21,
			persistedThemeKey = self.props.robloxPlusTheme or module24.Default,
			setRobloxPlusTheme = self.props.setRobloxPlusTheme,
			isUpdating = self.props.isUpdatingRobloxPlusTheme == true,
			columns = v8 and 3 or 2,
			categoryLabels = {
				[module30.Category.Dynamic] = data.appThemeCategoryDynamic,
				[module30.Category.Calm] = data.appThemeCategoryCalm,
				[module30.Category.Special] = data.appThemeCategorySpecial
			},
			bannerTitle = data.appThemeUnlockBanner,
			subscribeText = data.appThemeSubscribeText,
			reportSubscribeClick = self.onAppThemeSubscribeClicked,
			reportThemeSelected = self.onAppThemeSelected,
			robloxThemeKeys = v22,
			exclusiveThemesLabel = data.exclusiveThemesHeading,
			showExclusiveThemes = canSeeExclusiveThemes,
			newBadgeText = 0
		}

		local v56 = if not module34 then data.appThemeBadgeNew else nil
		v54.newBadgeText = v56
		v51.Control = createElement5(module28, v54)
		v49 = createElement4(module11, v51)
	end

	children.RobloxPlusThemeControl = v49

	local v50 = if fFlagAppIconSelectionPage and self.props.showAppIconSetting == true then Roact.createElement(v6, {
		style = props2,
		layoutOrder = fn(module7.AppIcon),
		columns = v8 and 3 or 2
	}) else nil
	children.AppIconSelector = v50

	local v51 = if getFFlagEnableReadAloudInUA() then Divider({
		style = props2,
		layoutOrder = fn(module7.ReadAloudDivider)
	}) else nil
	children.Divider8 = v51

	local v52 = if getFFlagEnableReadAloudInUA() then Roact.createElement(module11, {
		style = props2,
		header = "Read Aloud",
		description = "Experimental feature to allow text to be read aloud when right clicking.",
		layoutOrder = fn(module7.ReadAloud),
		Control = Roact.createElement(toggle, {
			isChecked = self.state.readAloudEnabled,
			onActivated = self.onReadAloudActivated,
			size = inputSize.Large,
			label = ""
		})
	}) else nil
	children.ReadAloud = v52

	local v53 = if getFFlagEnablePartyVoiceVolumeOnlyWhenInEligibleParty() then Roact.createElement(module15, {
		onChange = onChange
	}) else nil
	children.LocalPlayerPartyVoiceEligibleBinder = v53

	local v54 = if getFFlagSystemTrayEnabled() and not getFFlagHideLaunchAtStartupMac() then Divider({
		style = props2,
		layoutOrder = fn(module7.LaunchAtStartupDivider)
	}) else nil
	children.Divider9 = v54

	local v55 = if getFFlagSystemTrayEnabled() and not getFFlagHideLaunchAtStartupMac() then Roact.createElement(module11, {
		style = props2,
		header = data.launchAtStartupHeader,
		description = data.launchAtStartupDescription,
		layoutOrder = fn(module7.LaunchAtStartup),
		Control = Roact.createElement(toggle, {
			isChecked = self.state.isLaunchAtStartupEnabled,
			onActivated = self.onLaunchAtStartupActivated,
			size = inputSize.Large,
			label = ""
		})
	}) else nil
	children.LaunchAtStartup = v55

	local v56 = if getFFlagSystemTrayEnabled() then Divider({
		style = props2,
		layoutOrder = fn(module7.MinimizeToTrayDivider)
	}) else nil
	children.Divider10 = v56

	local v57 = if getFFlagSystemTrayEnabled() then Roact.createElement(module11, {
		style = props2,
		header = data.minimizeToTrayHeader,
		description = data.minimizeToTrayDescription,
		layoutOrder = fn(module7.MinimizeToTray),
		Control = Roact.createElement(toggle, {
			isChecked = self.state.isMinimizeToTrayEnabled,
			onActivated = self.onMinimizeToTrayActivated,
			size = inputSize.Large,
			label = ""
		})
	}) else nil
	children.MinimizeToTray = v57

	local v58 = if getFFlagEnableVREnvironmentSetting() and not getFFlagEnableSkyStyle() and isSpatial then Divider({
		style = props2,
		layoutOrder = fn(module7.VREnvironmentSettingDivider)
	}) else nil
	children.Divider11 = v58
	local v59

	if getFFlagEnableVREnvironmentSetting() and not getFFlagEnableSkyStyle() and isSpatial then
		v59 = React.createElement(module16, {
			layoutOrder = fn(module7.VREnvironmentSetting),
			isWideView = v8,
			contextualSliderWidth = v13,
			screenSize = self.props.screenSize,
			zIndex = self.getDropdownRowZIndex(module7.VREnvironmentSetting),
			onMenuOpenChange = function(p3)
				self.onDropdownMenuOpenChange(module7.VREnvironmentSetting, p3)
			end
		})
	end

	children.VREnvironmentSetting = v59

	local v60 = if getFFlagEnableSkyStyle() and isSpatial then Divider({
		style = props2,
		layoutOrder = fn(module7.SkyStyleDivider)
	}) else nil
	children.Divider12 = v60
	local v61

	if getFFlagEnableSkyStyle() and isSpatial then
		v61 = React.createElement(module17, {
			layoutOrder = fn(module7.SkyStyle),
			isWideView = v8,
			contextualSliderWidth = v13,
			screenSize = self.props.screenSize,
			zIndex = self.getDropdownRowZIndex(module7.SkyStyle),
			onMenuOpenChange = function(p3)
				self.onDropdownMenuOpenChange(module7.SkyStyle, p3)
			end
		})
	end

	children.SkyStyle = v61
	return createFragment(children)
end

function extended:render()
	local v8 = {
		reducedMotionHeader = "Feature.Accessibility.Heading.ReducedMotion",
		reducedMotionDescription = "Feature.Accessibility.Description.ReducedMotion",
		preferredTransparencyHeader = "Feature.Accessibility.Heading.PreferredTransparency",
		preferredTransparencyDescription = "Feature.Accessibility.Description.PreferredTransparency",
		preferredTransparencyOpaque = "Feature.Accessibility.PreferredTransparency.Opaque",
		preferredTransparencyTransparent = "Feature.Accessibility.PreferredTransparency.Transparent",
		preferredTextSizeHeader = "Feature.Accessibility.Heading.PreferredTextSize",
		preferredTextSizeDescription = "Feature.Accessibility.Description.PreferredTextSize",
		preferredTextSizeLargest = "Feature.Accessibility.PreferredTextSize.Largest",
		preferredTextSizeDefault = "Feature.Accessibility.PreferredTextSize.Default",
		uiScaleModeHeader = fFlagUIScaleEngineOptions and "CoreScripts.InGameMenu.GameSettings.UIScaleMode" or nil,
		uiScaleModeAuto = fFlagUIScaleEngineOptions and "CoreScripts.InGameMenu.GameSettings.UIScaleModeAuto" or nil,
		uiScaleModeManual = fFlagUIScaleEngineOptions and "CoreScripts.InGameMenu.GameSettings.UIScaleModeManual" or nil,
		uiScaleDefault = fFlagUIScaleEngineOptions and self.state.shownUIScaleOptions and {
			"Feature.Accessibility.UIScale.Default",
			scale = `{self.state.shownUIScaleOptions.values[self.state.shownUIScaleOptions.defaultIndex] / 100}x`
		} or nil,
		uiScaleManualDescription = fFlagUIScaleEngineOptions and "Feature.Accessibility.Description.UIScaleMode" or nil,
		uiScaleHeader = fFlagUIScaleEngineOptions and "Feature.Accessibility.Heading.UIScale" or nil,
		uiScaleDescription = fFlagUIScaleEngineOptions and "Feature.Accessibility.Description.UIScaleV2" or nil,
		uiNavigationKeyBindHeader = "Feature.Accessibility.Heading.UiNavigationKeyBind",
		uiNavigationKeyBindDescription = {
			"Feature.Accessibility.Description.UiNavigationKeyBind",
			uiNavigationKey = UserInputService:GetStringForKeyCode(Enum.KeyCode.BackSlash)
		},
		deviceLevelThemeDark = "Feature.Accessibility.DeviceLevelTheme.Dark",
		deviceLevelThemeLight = "Feature.Accessibility.DeviceLevelTheme.Light",
		deviceLevelThemeSystem = "Feature.Accessibility.DeviceLevelTheme.System",
		deviceAppThemeHeading = "Feature.Accessibility.Heading.DeviceAppTheme",
		deviceAppThemeDescription = "Feature.Accessibility.Description.DeviceAppTheme",
		appThemeModeHeading = "Feature.Accessibility.Heading.AppThemeMode",
		appThemeModeDescription = "Feature.Accessibility.Description.AppThemeMode",
		appThemeUnlockBanner = "Feature.Accessibility.Label.AppThemeUnlockBanner",
		appThemeBadgeNew = "Feature.Accessibility.Label.AppThemeBadgeNew",
		appThemeCategoryDynamic = "Feature.Accessibility.AppTheme.CategoryDynamic",
		appThemeCategoryCalm = "Feature.Accessibility.AppTheme.CategoryCalm",
		appThemeCategorySpecial = "Feature.Accessibility.AppTheme.CategorySpecial",
		appThemeSubscribeText = "Feature.RobloxSubscription.Action.Subscribe",
		appThemeExclusiveDescription = "Feature.Accessibility.Description.DeviceAppThemeExclusive",
		exclusiveThemesHeading = "Feature.Accessibility.Heading.ExclusiveThemes",
		launchAtStartupHeader = fFlagMacMenuBarContentUpdates and self.props.isMacVariant and "Feature.Accessibility.Heading.LaunchAtLogin" or "Feature.Accessibility.Heading.LaunchAtStartup",
		launchAtStartupDescription = not (fFlagMacMenuBarContentUpdates and self.props.isMacVariant) and "Feature.Accessibility.Description.LaunchAtStartup" or nil,
		minimizeToTrayHeader = fFlagMacMenuBarContentUpdates and self.props.isMacVariant and "Feature.Accessibility.Header.ShowInMenuBar" or "Feature.Accessibility.Heading.MinimizeToTray",
		minimizeToTrayDescription = not (fFlagMacMenuBarContentUpdates and self.props.isMacVariant) and "Feature.Accessibility.Description.MinimizeToTray" or nil
	}

	for k, key in keys do
		v8[`appThemeName{key}`] = module24.Labels[key]
	end

	return module4(v8)(function(p2)
		return withStyle(function(p3)
			return self:renderWithProviders(p2, p3.Theme.BackgroundDefault, p3)
		end)
	end)
end

function extended:willUnmount()
	self:eventDisconnect()

	if self.props.showRobloxPlusThemeSetting == true and self.props.canSeeExclusiveThemes ~= false then
		module9.reportPageExit(self.props.canChangeRobloxPlusTheme == true)
	end
end

local v8 = RoactRodux.connect(function(data, p2)
	local v9 = { formFactor = data.FormFactor, platform = 0, screenSize = 0 }
	local v10 = if not fFlagUseSignalsForPlatform then data.Platform else nil
	v9.platform = v10
	local v11 = if systemThemeEnabled then data.ScreenSize else nil
	v9.screenSize = v11
	return v9
end)(extended)

if fFlagUseSignalsForPlatform then
	local v9 = v8
	local function DeviceSettingsPageContentWithSignals(p2)
		local v10 = useSignalState(v5(false).getPlatform)
		return Roact.createElement(v9, Cryo.Dictionary.union(p2, { platform = v10 }))
	end

	v8 = React.memo(DeviceSettingsPageContentWithSignals)
end

if fFlagMacMenuBarContentUpdates then
	v8 = roactAppPolicy.connect(function(p2)
		return {
			isMacVariant = p2.getDevicePreferencesPersistentPresenceVariant() == "mac"
		}
	end)(v8)
end

local function DeviceSettingsPageContentContainer(p2)
	local v9 = React.useContext(appearanceContext)

	local v10 = if systemThemeEnabled then useLocalUserId() else nil
	local v11 = useIsSpatial()
	local v12 = React.useCallback(function(p3)
		if module21() then
			module22(p3, {})
			return
		end

		local v13 = nil

		if p3 == deviceLevelThemeKey.System then
			v13 = systemThemeService and module23(systemThemeService) or nil
		elseif p3 == deviceLevelThemeKey.Light then
			v13 = systemThemeEnum and systemThemeEnum.Light or nil
		elseif p3 == deviceLevelThemeKey.Dark then
			v13 = systemThemeEnum and systemThemeEnum.Dark or nil
		end

		logger:info("The user selected theme: " .. p3 .. ". Setting theme to: " .. tostring(v13))

		if systemThemeService and v13 then
			systemThemeService:setTheme(v13)
		end
	end, { v9 })
	local v13 = useTokens()
	local udim = UDim.new(0, v13.Size.Size_1200)

	local v14 = module25(false)
	local v15 = useSignalState(v14.getColorThemeKey)

	local v16 = if module31 then module35() else nil
	local v17 = useSignalState(v14.getWriteStatus) == "Pending"

	local v18 = module27()
	local v19 = React.useCallback(function(p3, p4)
		v18(p3, p4)

		if module31 and p3 == module24.Halloween2026 then
			v12(deviceLevelThemeKey.Dark)
		end
	end, { v18, v12 })

	local v20 = module26()
	local isRobloxPlusUpsellEligible = v20.isRobloxPlusUpsellEligible
	local v21

	if fFlagAppIconSelectionPage then
		v21 = useAppPolicy(function(p3)
			return p3.getShowAppIconSetting()
		end)
	end

	local hasRobloxPlusSubscription = v20.hasRobloxPlusSubscription
	local canSeeExclusiveThemes = v20.canSeeExclusiveThemes

	local joined = Cryo.Dictionary.join(p2, {
		themeSelectedCallback = v12,
		themeCellHeight = udim,
		userId = v10,
		isSpatial = v11,
		robloxPlusTheme = v15,
		renderedThemeName = v16,
		setRobloxPlusTheme = v19,
		showRobloxPlusThemeSetting = isRobloxPlusUpsellEligible,
		showAppIconSetting = v21,
		canChangeRobloxPlusTheme = hasRobloxPlusSubscription,
		canSeeExclusiveThemes = canSeeExclusiveThemes,
		isUpdatingRobloxPlusTheme = v17
	})

	return React.createElement(v8, joined)
end

return if systemThemeEnabled then roactServices.connect({ roactAnalytics = module2 })(DeviceSettingsPageContentContainer) else roactServices.connect({
	roactAnalytics = module2
})(v8)
