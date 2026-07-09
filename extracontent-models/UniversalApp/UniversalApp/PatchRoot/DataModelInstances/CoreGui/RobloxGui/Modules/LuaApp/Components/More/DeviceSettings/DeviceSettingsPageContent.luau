local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local UserInputService = game:GetService("UserInputService")
local AppStorageService = game:GetService("AppStorageService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local scriptParent = script.Parent
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local Foundation = require(CorePackages.Packages.Foundation)
local InputSize = Foundation.Enums.InputSize
local Toggle = Foundation.Toggle
local DropdownMenu = UIBlox.App.Menu.DropdownMenu
local useTokens = require(CorePackages.Packages.Foundation).Hooks.useTokens
local Slider = Foundation.Slider
local Constants = require(Modules.LuaApp.Constants)
local withLocalization = require(Modules.LuaApp.withLocalization)
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local EventStreamConstants = require(Modules.LuaApp.EventStreamConstants)
local DeviceSettingsPageContentConstants = require(scriptParent.DeviceSettingsPageContentConstants)
local DeviceSettingsEnum = require(scriptParent.DeviceSettingsEnum)
local changeAccessibilitySettingFromApp = require(Modules.LuaApp.Analytics.Events.changeAccessibilitySettingFromApp)
local DeviceSettingsPageSetting = require(scriptParent.DeviceSettingsPageSetting)
local MasterVolumeSetting = require(Modules.LuaApp.Components.More.MasterVolumeSetting)
local PartyVoiceVolumeSettings = require(Modules.LuaApp.Components.More.PartyVoiceVolumeSettings)
local HapticsToggleSetting = require(Modules.LuaApp.Components.More.HapticsToggleSetting)
local ThemeContext = require(CorePackages.Workspace.Packages.Style).ThemeContext
local LocalPlayerPartyVoiceEligibleBinder = require(CorePackages.Workspace.Packages.SquadsCore.LocalPlayerPartyVoiceEligibleBinder)
local VREnvironmentSetting = require(Modules.LuaApp.Components.More.VREnvironmentSetting)
local SkyStyleSetting = require(Modules.LuaApp.Components.More.SkyStyleSetting)
local Cryo = require(CorePackages.Packages.Cryo)
local SystemThemeFeature = require(Modules.LuaApp.Components.EventReceivers.SystemThemeFeature)
local v38 = SystemThemeFeature.GetSystemThemeEnabled()
local v39 = SystemThemeFeature.GetSystemThemeService()
local v40 = SystemThemeFeature.GetSystemThemeEnum()
local Logger = require(CorePackages.Workspace.Packages.Loggers).Logger
local default = require(CorePackages.Workspace.Packages.AppCommonLib).Utils.AppStorageJsonCacheUtils.default
local LocalStorageKey = require(CorePackages.Workspace.Packages.LocalStorage).Enums.LocalStorageKey
local GetFFlagEnableUiNavigationKeyBindSettingInAppShellSettings = require(Modules.LuaApp.Flags.GetFFlagEnableUiNavigationKeyBindSettingInAppShellSettings)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagEnablePartyVoiceVolumeOnlyWhenInEligibleParty = SharedFlags.GetFFlagEnablePartyVoiceVolumeOnlyWhenInEligibleParty
local FFlagEnableDevicePreferenceLayoutUpdate = require(Modules.LuaApp.Flags.FFlagEnableDevicePreferenceLayoutUpdate)
local v48 = SharedFlags.GetFFlagMacMenuBarContentUpdates()
local GetFFlagEnableReadAloudInUA = SharedFlags.GetFFlagEnableReadAloudInUA
local GetFFlagSystemTrayEnabled = SharedFlags.GetFFlagSystemTrayEnabled
local GetFFlagHideLaunchAtStartupMac = SharedFlags.GetFFlagHideLaunchAtStartupMac
local useLocalUserId = require(CorePackages.Workspace.Packages.RobloxAppHooks).useLocalUserId
local GetFFlagEnableThemeUpdatedLoggingFix = require(Modules.LuaApp.Flags.GetFFlagEnableThemeUpdatedLoggingFix)
local GetFFlagEnableVREnvironmentSetting = SharedFlags.GetFFlagEnableVREnvironmentSetting
local GetFFlagEnableSkyStyle = SharedFlags.GetFFlagEnableSkyStyle
local default2 = require(CorePackages.Workspace.Packages.CrossExperienceVoice).IXPManager.default
local ApplyThemeSelection = require(scriptParent.ApplyThemeSelection)
local GetSystemTheme = require(Modules.LuaApp.Components.EventReceivers.GetSystemTheme)
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local FFlagEnableRobloxPlusThemeSetting = SharedFlags.FFlagEnableRobloxPlusThemeSetting
local v61 = if not FFlagEnableRobloxPlusThemeSetting then nil else require(Modules.LuaApp.Themes.RobloxPlusTheme)
local v62 = if not FFlagEnableRobloxPlusThemeSetting then nil else require(Modules.LuaApp.Themes.Stores.GetRobloxPlusThemeStore)
local v63 = if not FFlagEnableRobloxPlusThemeSetting then nil else require(Modules.LuaApp.Hooks.useShowRobloxPlusThemeSetting)
local v64 = default2 and default2.getHasPartyVoiceVolume()
local DeviceLevelThemeKey = DeviceSettingsPageContentConstants.DeviceLevelThemeKey
local LAYOUT_ORDER = DeviceSettingsPageContentConstants.LAYOUT_ORDER
local useIsSpatial = require(CorePackages.Workspace.Packages.Responsive).useIsSpatial
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy

local function createLayoutOrderGenerator() -- line: 107
	-- upvalues: LAYOUT_ORDER (copy)
	local n1 = 0

	return function(p1) -- line: 109
		-- upvalues: LAYOUT_ORDER (copy), n1 (ref)
		if p1 then
			return LAYOUT_ORDER[p1]
		end

		n1 += 1

		return n1
	end
end

local v70 = Roact.PureComponent:extend("DeviceSettingsPageContent")

if v38 then
	v70.validateProps = t.strictInterface({
		formFactor = t.string,
		platform = t.EnumItem,
		themeSelectedCallback = t.callback,
		themeCellHeight = t.UDim,
		userId = t.string,
		screenSize = t.Vector2,
		isSpatial = t.optional(t.boolean),
		isMacVariant = if not v48 then nil else t.optional(t.boolean),
		robloxPlusTheme = if not FFlagEnableRobloxPlusThemeSetting then nil else t.optional(t.string),
		setRobloxPlusTheme = if not FFlagEnableRobloxPlusThemeSetting then nil else t.optional(t.callback),
		showRobloxPlusThemeSetting = if not FFlagEnableRobloxPlusThemeSetting then nil else t.optional(t.boolean),
		roactAnalytics = t.union(t.Instance, t.table)
	})
else
	v70.validateProps = t.strictInterface({
		formFactor = t.string,
		platform = t.EnumItem,
		isSpatial = t.optional(t.boolean),
		isMacVariant = if not v48 then nil else t.optional(t.boolean),
		robloxPlusTheme = if not FFlagEnableRobloxPlusThemeSetting then nil else t.optional(t.string),
		setRobloxPlusTheme = if not FFlagEnableRobloxPlusThemeSetting then nil else t.optional(t.callback),
		showRobloxPlusThemeSetting = if not FFlagEnableRobloxPlusThemeSetting then nil else t.optional(t.boolean),
		roactAnalytics = t.union(t.Instance, t.table)
	})
end

function v70.eventDisconnect(p2) -- line: 150
	-- upvalues: GetFFlagEnableReadAloudInUA (copy)
	if p2.onReducedMotionChangedSignal then
		p2.onReducedMotionChangedSignal:Disconnect()
		p2.onReducedMotionChangedSignal = nil
	end

	if p2.onPreferredTransparencyChangedSignal then
		p2.onPreferredTransparencyChangedSignal:Disconnect()
		p2.onPreferredTransparencyChangedSignal = nil
	end

	if p2.onPreferredTextSizeChangedSignal then
		p2.onPreferredTextSizeChangedSignal:Disconnect()
		p2.onPreferredTextSizeChangedSignal = nil
	end

	if p2.onUiNavigationKeyBindEnabledChanged then
		p2.onUiNavigationKeyBindEnabledChanged:Disconnect()
		p2.onUiNavigationKeyBindEnabledChanged = nil
	end

	if p2.onKeyboardEnabledChangedSignal then
		p2.onKeyboardEnabledChangedSignal:Disconnect()
		p2.onKeyboardEnabledChangedSignal = nil
	end

	if GetFFlagEnableReadAloudInUA() and p2.onReadAloudChangedSignal then
		p2.onReadAloudChangedSignal:Disconnect()
		p2.onReadAloudChangedSignal = nil
	end
end
function v70.init(p3) -- line: 178
	-- upvalues: GetFFlagSystemTrayEnabled (copy), AppStorageService (copy), UserInputService (copy), UserGameSettings (copy), GetFFlagEnableReadAloudInUA (copy), LocalStorageKey (copy), GetFFlagEnableVREnvironmentSetting (copy), GetFFlagEnableSkyStyle (copy), FFlagEnableRobloxPlusThemeSetting (copy), GetFFlagHideLaunchAtStartupMac (copy), changeAccessibilitySettingFromApp (copy), EventStreamConstants (copy), DeviceSettingsEnum (copy)
	local function preferredTransparencySliderValueFromValue(n2: number) -- line: 179
		return 10 - math.clamp(math.floor(n2 * 10 + 0.5), 0, 10)
	end
	local function preferredTextSizeSliderValueFromValue(p4) -- line: 183
		return p4.Value - 1
	end
	local function appStorageItem(p5) -- line: 187
		-- upvalues: GetFFlagSystemTrayEnabled (copy), AppStorageService (copy)
		if GetFFlagSystemTrayEnabled() then
			if AppStorageService:GetItem(p5) == "true" then
				return true
			end

			return false
		end

		return nil
	end

	local t1 = {
		isLocalPlayerPartyVoiceEligible = false,
		keyboardEnabled = UserInputService.KeyboardEnabled,
		reducedMotionEnabled = UserGameSettings.ReducedMotion,
		preferredTransparencyValue = 10 - math.clamp(math.floor(UserGameSettings.PreferredTransparency * 10 + 0.5), 0, 10),
		preferredTextSizeValue = UserGameSettings.PreferredTextSize.Value - 1,
		uiNavigationKeyBindEnabled = UserGameSettings.UiNavigationKeyBindEnabled,
		readAloudEnabled = if not GetFFlagEnableReadAloudInUA() then nil else UserGameSettings.ReadAloud
	}
	local LaunchAtStartup = LocalStorageKey.LaunchAtStartup

	t1.isLaunchAtStartupEnabled = if not GetFFlagSystemTrayEnabled() then nil else AppStorageService:GetItem(LaunchAtStartup) == "true"

	local MinimizeToTray = LocalStorageKey.MinimizeToTray

	t1.isMinimizeToTrayEnabled = if not GetFFlagSystemTrayEnabled() then nil else AppStorageService:GetItem(MinimizeToTray) == "true"
	t1.openDropdownSetting = if not GetFFlagEnableVREnvironmentSetting() and (not GetFFlagEnableSkyStyle() and not FFlagEnableRobloxPlusThemeSetting) then nil else ""
	p3.state = t1

	if GetFFlagEnableVREnvironmentSetting() or GetFFlagEnableSkyStyle() or FFlagEnableRobloxPlusThemeSetting then
		function p3.getDropdownRowZIndex(p6) -- line: 217
			-- upvalues: p3 (copy)
			if p6 == p3.state.openDropdownSetting then
				return 3
			end

			return 2
		end
		function p3.onDropdownMenuOpenChange(p7, b1: boolean) -- line: 223
			-- upvalues: p3 (copy)
			p3:setState(function(p8) -- line: 224
				-- upvalues: b1 (copy), p7 (copy)
				local openDropdownSetting = p8.openDropdownSetting

				if b1 then
					openDropdownSetting = p7
				elseif openDropdownSetting == p7 then
					openDropdownSetting = ""
				end

				return {
					openDropdownSetting = openDropdownSetting
				}
			end)
		end
	end

	if GetFFlagSystemTrayEnabled() and not GetFFlagHideLaunchAtStartupMac() then
		function p3.onLaunchAtStartupActivated() -- line: 240
			-- upvalues: p3 (copy), AppStorageService (copy), LocalStorageKey (copy)
			local v137 = not p3.state.isLaunchAtStartupEnabled

			AppStorageService:SetItem(LocalStorageKey.LaunchAtStartup, (tostring(v137)))
			AppStorageService:Flush()
			p3:setState({
				isLaunchAtStartupEnabled = v137
			})
		end
		function p3.onMinimizeToTrayActivated() -- line: 252
			-- upvalues: p3 (copy), AppStorageService (copy), LocalStorageKey (copy)
			local v138 = not p3.state.isMinimizeToTrayEnabled

			AppStorageService:SetItem(LocalStorageKey.MinimizeToTray, (tostring(v138)))
			AppStorageService:Flush()
			p3:setState({
				isMinimizeToTrayEnabled = v138
			})
		end
	end

	function p3.onReducedMotionActivated() -- line: 265
		-- upvalues: p3 (copy), UserGameSettings (copy), changeAccessibilitySettingFromApp (copy), EventStreamConstants (copy)
		local reducedMotionEnabled = p3.state.reducedMotionEnabled
		local v140 = not p3.state.reducedMotionEnabled

		UserGameSettings.ReducedMotion = v140
		changeAccessibilitySettingFromApp(p3.props.roactAnalytics.EventStream, EventStreamConstants.Context.AccessibilitySettingsPage, "ReducedMotion", tostring(reducedMotionEnabled), (tostring(v140)))
	end

	p3.onReducedMotionChangedSignal = UserGameSettings:GetPropertyChangedSignal("ReducedMotion"):Connect(function() -- line: 278
		-- upvalues: p3 (copy), UserGameSettings (copy)
		p3:setState({
			reducedMotionEnabled = UserGameSettings.ReducedMotion
		})
	end)

	if GetFFlagEnableReadAloudInUA() then
		function p3.onReadAloudActivated() -- line: 285
			-- upvalues: p3 (copy), UserGameSettings (copy), changeAccessibilitySettingFromApp (copy), EventStreamConstants (copy), DeviceSettingsEnum (copy)
			local readAloudEnabled = p3.state.readAloudEnabled
			local v142 = not p3.state.readAloudEnabled

			UserGameSettings.ReadAloud = v142
			changeAccessibilitySettingFromApp(p3.props.roactAnalytics.EventStream, EventStreamConstants.Context.AccessibilitySettingsPage, DeviceSettingsEnum.ReadAloud, tostring(readAloudEnabled), (tostring(v142)))
		end

		p3.onReadAloudChangedSignal = UserGameSettings:GetPropertyChangedSignal("ReadAloud"):Connect(function() -- line: 298
			-- upvalues: p3 (copy), UserGameSettings (copy)
			p3:setState({
				readAloudEnabled = UserGameSettings.ReadAloud
			})
		end)
	end

	function p3.onPreferredTransparencyValueChanged(p9) -- line: 305
		-- upvalues: UserGameSettings (copy), changeAccessibilitySettingFromApp (copy), p3 (copy), EventStreamConstants (copy)
		local PreferredTransparency = UserGameSettings.PreferredTransparency
		local v145 = (10 - math.clamp(math.floor(p9), 0, 10)) / 10

		UserGameSettings.PreferredTransparency = v145
		changeAccessibilitySettingFromApp(p3.props.roactAnalytics.EventStream, EventStreamConstants.Context.AccessibilitySettingsPage, "PreferredTransparency", tostring(PreferredTransparency), (tostring(v145)))
	end

	p3.onPreferredTransparencyChangedSignal = UserGameSettings:GetPropertyChangedSignal("PreferredTransparency"):Connect(function() -- line: 319
		-- upvalues: p3 (copy), UserGameSettings (copy)
		p3:setState({
			preferredTransparencyValue = 10 - math.clamp(math.floor(UserGameSettings.PreferredTransparency * 10 + 0.5), 0, 10)
		})
	end)

	function p3.onPreferredTextSizeValueChanged(n3: number) -- line: 327
		-- upvalues: UserGameSettings (copy), changeAccessibilitySettingFromApp (copy), p3 (copy), EventStreamConstants (copy)
		local PreferredTextSize = UserGameSettings.PreferredTextSize
		local v148 = Enum.PreferredTextSize:GetEnumItems()[n3 + 1]

		UserGameSettings.PreferredTextSize = v148
		changeAccessibilitySettingFromApp(p3.props.roactAnalytics.EventStream, EventStreamConstants.Context.AccessibilitySettingsPage, "PreferredTextSize", tostring(PreferredTextSize), (tostring(v148)))
	end

	p3.onPreferredTextSizeChangedSignal = UserGameSettings:GetPropertyChangedSignal("PreferredTextSize"):Connect(function() -- line: 340
		-- upvalues: p3 (copy), UserGameSettings (copy)
		p3:setState({
			preferredTextSizeValue = UserGameSettings.PreferredTextSize.Value - 1
		})
	end)

	function p3.onUiNavigationKeyBindActivated() -- line: 346
		-- upvalues: p3 (copy), UserGameSettings (copy), changeAccessibilitySettingFromApp (copy), EventStreamConstants (copy)
		local uiNavigationKeyBindEnabled = p3.state.uiNavigationKeyBindEnabled
		local v150 = not p3.state.uiNavigationKeyBindEnabled

		UserGameSettings.UiNavigationKeyBindEnabled = v150
		changeAccessibilitySettingFromApp(p3.props.roactAnalytics.EventStream, EventStreamConstants.Context.AccessibilitySettingsPage, "UiNavigationKeyBind", tostring(uiNavigationKeyBindEnabled), (tostring(v150)))
	end

	p3.onUiNavigationKeyBindEnabledChanged = UserGameSettings:GetPropertyChangedSignal("UiNavigationKeyBindEnabled"):Connect(function() -- line: 360
		-- upvalues: p3 (copy), UserGameSettings (copy)
		p3:setState({
			uiNavigationKeyBindEnabled = UserGameSettings.UiNavigationKeyBindEnabled
		})
	end)
	p3.onKeyboardEnabledChangedSignal = UserInputService:GetPropertyChangedSignal("KeyboardEnabled"):Connect(function() -- line: 367
		-- upvalues: p3 (copy), UserInputService (copy)
		p3:setState({
			keyboardEnabled = UserInputService.KeyboardEnabled
		})
	end)
end

local function Divider(p10) -- line: 374
	-- upvalues: Roact (copy)
	local style = p10.style

	return Roact.createElement("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 1),
		BackgroundColor3 = style.Theme.Divider.Color,
		BackgroundTransparency = style.Theme.Divider.Transparency,
		LayoutOrder = p10.layoutOrder
	})
end
local function getThemeDropdownProperties(p11, p12) -- line: 385
	-- upvalues: v38 (copy), v40 (copy), default (copy), SystemThemeFeature (copy), DeviceLevelThemeKey (copy), GetFFlagEnableThemeUpdatedLoggingFix (copy)
	local Light = nil
	local deviceLevelThemeLight = nil

	if v38 and v40 then
		local result = default:decodeInternal(SystemThemeFeature.DeviceLevelThemeLocalStorageKey).result
		local v91 = result and result[p12] or nil

		if v91 then
			local v92 = v40.getSystemThemeEnum(v91)

			if v92 == v40.Light then
				Light = DeviceLevelThemeKey.Light
				deviceLevelThemeLight = p11.deviceLevelThemeLight
			elseif v92 == v40.Dark then
				Light = DeviceLevelThemeKey.Dark
				deviceLevelThemeLight = p11.deviceLevelThemeDark
			elseif v92 == v40.SystemLight or v92 == v40.SystemDark then
				Light = DeviceLevelThemeKey.System
				deviceLevelThemeLight = p11.deviceLevelThemeSystem
			end
		end
	end

	if GetFFlagEnableThemeUpdatedLoggingFix() and v38 and (deviceLevelThemeLight == nil or deviceLevelThemeLight == "") then
		deviceLevelThemeLight = p11.deviceLevelThemeLight or (p11.deviceLevelThemeDark or (p11.deviceLevelThemeSystem or ""))
	end

	if GetFFlagEnableThemeUpdatedLoggingFix() and deviceLevelThemeLight == nil then
		deviceLevelThemeLight = ""
	end

	return Light, deviceLevelThemeLight
end

function v70.renderWithProviders(p13, p14, _, p16) -- line: 427
	-- upvalues: FormFactor (copy), LAYOUT_ORDER (copy), GetFFlagEnableUiNavigationKeyBindSettingInAppShellSettings (copy), DeviceSettingsPageContentConstants (copy), v38 (copy), getThemeDropdownProperties (copy), FFlagEnableRobloxPlusThemeSetting (copy), GetFFlagEnablePartyVoiceVolumeOnlyWhenInEligibleParty (copy), Roact (copy), DeviceSettingsEnum (copy), FFlagEnableDevicePreferenceLayoutUpdate (copy), DeviceSettingsPageSetting (copy), Toggle (copy), InputSize (copy), Divider (copy), Constants (copy), Slider (copy), Foundation (copy), MasterVolumeSetting (copy), v64 (copy), PartyVoiceVolumeSettings (copy), HapticsToggleSetting (copy), GetFFlagEnableVREnvironmentSetting (copy), GetFFlagEnableSkyStyle (copy), DropdownMenu (copy), DeviceLevelThemeKey (copy), v61 (copy), GetFFlagEnableReadAloudInUA (copy), LocalPlayerPartyVoiceEligibleBinder (copy), GetFFlagSystemTrayEnabled (copy), GetFFlagHideLaunchAtStartupMac (copy), React (copy), VREnvironmentSetting (copy), SkyStyleSetting (copy)
	local v97 = p13.props.formFactor == FormFactor.WIDE
	local n4 = 0

	local function v99(p17) -- line: 109
		-- upvalues: LAYOUT_ORDER (copy), n4 (ref)
		if p17 then
			return LAYOUT_ORDER[p17]
		end

		n4 += 1

		return n4
	end

	local userId = p13.props.userId
	local isSpatial = p13.props.isSpatial
	local v102 = not isSpatial
	local v103 = not isSpatial
	local v104 = GetFFlagEnableUiNavigationKeyBindSettingInAppShellSettings() and p13.state.keyboardEnabled
	local BaseSize = p16.Font.BaseSize
	local v106 = BaseSize * p16.Font.Body.RelativeSize
	local v107 = BaseSize * p16.Font.CaptionBody.RelativeSize
	local BodyFont = p16.Font.Body.Font
	local CaptionBodyFont = p16.Font.CaptionBody.Font
	local v110 = p16.Tokens.Stroke.Standard * DeviceSettingsPageContentConstants.CONTEXTUAL_SLIDER_BASE_WIDTH
	local v111 = nil
	local v112 = nil

	if v38 then
		v111, v112 = getThemeDropdownProperties(p14, userId)
	end

	local v113 = FFlagEnableRobloxPlusThemeSetting and (p13.props.showRobloxPlusThemeSetting == true and p13.props.setRobloxPlusTheme ~= nil)

	return Roact.createFragment({
		Frame = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = v99(DeviceSettingsEnum.SettingDescription)
		}, {
			UIPadding = if FFlagEnableDevicePreferenceLayoutUpdate then nil else Roact.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, 25)
			}),
			SettingDescriptionText = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				TextWrapped = true,
				Size = UDim2.new(1, 0, 0, 0),
				Text = p14.accessibilityDescription,
				Font = BodyFont,
				TextSize = v106,
				TextColor3 = p16.Theme.TextDefault.Color,
				TextTransparency = p16.Theme.TextDefault.Transparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				AutomaticSize = Enum.AutomaticSize.Y
			})
		}),
		ReducedMotion = if not v102 then nil else Roact.createElement(DeviceSettingsPageSetting, {
			style = p16,
			header = p14.reducedMotionHeader,
			description = p14.reducedMotionDescription,
			layoutOrder = v99(DeviceSettingsEnum.ReducedMotion),
			Control = Roact.createElement(Toggle, {
				label = "",
				isChecked = p13.state.reducedMotionEnabled,
				onActivated = p13.onReducedMotionActivated,
				size = InputSize.Large
			})
		}),
		Divider1 = if not v102 then nil else Divider({
			style = p16,
			layoutOrder = v99(DeviceSettingsEnum.PreferredTransparencyDivider)
		}),
		PreferredTransparency = if not v103 then nil else Roact.createElement(DeviceSettingsPageSetting, {
			style = p16,
			header = p14.preferredTransparencyHeader,
			description = p14.preferredTransparencyDescription,
			layoutOrder = v99(DeviceSettingsEnum.PreferredTransparency),
			topToBottom = not v97,
			Control = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Size = if not v97 then UDim2.fromScale(1, 0) else UDim2.new(0, v110, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				Layout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.Name,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0, Constants.MORE_PAGE_SECTION_PADDING)
				}),
				ContextualSlider = Roact.createElement(Slider, {
					step = 1,
					width = UDim.new(1, 0),
					range = NumberRange.new(0, 10),
					value = p13.state.preferredTransparencyValue,
					onValueChanged = p13.onPreferredTransparencyValueChanged,
					size = Foundation.Enums.InputSize.Large,
					knobVisibility = Foundation.Enums.ScrollBarVisibility.Always,
					variant = Foundation.Enums.SliderVariant.Emphasis
				}),
				Frame = Roact.createElement("Frame", {
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
					UIPadding = Roact.createElement("UIPadding", {
						PaddingTop = UDim.new(0, -10)
					}),
					LeftText = Roact.createElement("TextLabel", {
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						LayoutOrder = 1,
						Size = UDim2.fromScale(1, 0),
						Text = p14.preferredTransparencyTransparent,
						Font = CaptionBodyFont,
						TextSize = v107,
						TextColor3 = p16.Theme.TextMuted.Color,
						TextTransparency = p16.Theme.TextMuted.Transparency,
						TextXAlignment = Enum.TextXAlignment.Left
					}),
					RightText = Roact.createElement("TextLabel", {
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						LayoutOrder = 2,
						Size = UDim2.fromScale(1, 0),
						Text = p14.preferredTransparencyOpaque,
						Font = CaptionBodyFont,
						TextSize = v107,
						TextColor3 = p16.Theme.TextMuted.Color,
						TextTransparency = p16.Theme.TextMuted.Transparency,
						TextXAlignment = Enum.TextXAlignment.Right
					})
				})
			})
		}),
		Divider2 = if not v103 then nil else Divider({
			style = p16,
			layoutOrder = v99(DeviceSettingsEnum.PreferredTextSizeDivider)
		}),
		PreferredTextSize = Roact.createElement(DeviceSettingsPageSetting, {
			style = p16,
			header = p14.preferredTextSizeHeader,
			description = p14.preferredTextSizeDescription,
			layoutOrder = v99(DeviceSettingsEnum.PreferredTextSize),
			topToBottom = not v97,
			Control = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Size = if not v97 then UDim2.fromScale(1, 0) else UDim2.new(0, v110, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				Layout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.Name,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0, Constants.MORE_PAGE_SECTION_PADDING)
				}),
				ContextualSlider = Roact.createElement(Slider, {
					step = 1,
					width = UDim.new(1, 0),
					range = NumberRange.new(0, 3),
					value = p13.state.preferredTextSizeValue,
					onValueChanged = p13.onPreferredTextSizeValueChanged,
					size = Foundation.Enums.InputSize.Large,
					knobVisibility = Foundation.Enums.ScrollBarVisibility.Always,
					variant = Foundation.Enums.SliderVariant.Emphasis
				}),
				Frame = Roact.createElement("Frame", {
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
					UIPadding = Roact.createElement("UIPadding", {
						PaddingTop = UDim.new(0, -10)
					}),
					LeftText = Roact.createElement("TextLabel", {
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						LayoutOrder = 1,
						Size = UDim2.fromScale(1, 0),
						Text = p14.preferredTextSizeDefault,
						Font = CaptionBodyFont,
						TextSize = v107,
						TextColor3 = p16.Theme.TextMuted.Color,
						TextTransparency = p16.Theme.TextMuted.Transparency,
						TextXAlignment = Enum.TextXAlignment.Left
					}),
					RightText = Roact.createElement("TextLabel", {
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						LayoutOrder = 2,
						Size = UDim2.fromScale(1, 0),
						Text = p14.preferredTextSizeLargest,
						Font = CaptionBodyFont,
						TextSize = v107,
						TextColor3 = p16.Theme.TextMuted.Color,
						TextTransparency = p16.Theme.TextMuted.Transparency,
						TextXAlignment = Enum.TextXAlignment.Right
					})
				})
			})
		}),
		Divider3 = if not v104 then nil else Divider({
			style = p16,
			layoutOrder = v99(DeviceSettingsEnum.UINavigationKeyBindDivider)
		}),
		UiNavigationKeyBind = if not v104 then nil else Roact.createElement(DeviceSettingsPageSetting, {
			style = p16,
			header = p14.uiNavigationKeyBindHeader,
			description = p14.uiNavigationKeyBindDescription,
			layoutOrder = v99(DeviceSettingsEnum.UINavigationKeyBind),
			Control = Roact.createElement(Toggle, {
				label = "",
				isChecked = p13.state.uiNavigationKeyBindEnabled,
				onActivated = p13.onUiNavigationKeyBindActivated,
				size = InputSize.Large
			})
		}),
		Divider4 = Divider({
			style = p16,
			layoutOrder = v99(DeviceSettingsEnum.ReducedMotionDivider)
		}),
		MasterVolume = Roact.createElement(MasterVolumeSetting, {
			layoutOrder = v99(DeviceSettingsEnum.MasterVolume)
		}),
		Divider5 = if not v64 or not not GetFFlagEnablePartyVoiceVolumeOnlyWhenInEligibleParty() and not p13.state.isLocalPlayerPartyVoiceEligible then nil else Divider({
			style = p16,
			layoutOrder = v99(DeviceSettingsEnum.PartyVoiceVolumeDivider)
		}),
		PartyVoiceVolume = if not v64 or not not GetFFlagEnablePartyVoiceVolumeOnlyWhenInEligibleParty() and not p13.state.isLocalPlayerPartyVoiceEligible then nil else Roact.createElement(PartyVoiceVolumeSettings, {
			layoutOrder = v99(DeviceSettingsEnum.PartyVoiceVolume)
		}),
		Divider6 = Divider({
			style = p16,
			layoutOrder = v99(DeviceSettingsEnum.HapticsDivider)
		}),
		HapticsToggle = Roact.createElement(HapticsToggleSetting, {
			layoutOrder = v99(DeviceSettingsEnum.Haptics)
		}),
		Divider7 = if not v38 then nil else Divider({
			style = p16,
			layoutOrder = v99(DeviceSettingsEnum.DeviceLevelThemeDivider)
		}),
		DeviceLevelThemeDropdown = if not v38 then nil else Roact.createElement(DeviceSettingsPageSetting, {
			style = p16,
			header = if not FFlagEnableRobloxPlusThemeSetting then p14.deviceLevelThemeHeading else "Color Mode",
			description = if not FFlagEnableRobloxPlusThemeSetting then p14.deviceLevelThemeDescription else "Choose how the app looks on this device. (Note: This won't change how Roblox looks on your other devices.)",
			layoutOrder = v99(DeviceSettingsEnum.DeviceLevelTheme),
			zIndex = not GetFFlagEnableVREnvironmentSetting() and (not GetFFlagEnableSkyStyle() and not FFlagEnableRobloxPlusThemeSetting) and 2 or p13.getDropdownRowZIndex(DeviceSettingsEnum.DeviceLevelTheme),
			topToBottom = not v97,
			Control = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Size = if not v97 then UDim2.new(1, 0, 0, p13.props.themeCellHeight.Offset) else UDim2.new(0, v110, 0, p13.props.themeCellHeight.Offset)
			}, { Roact.createElement(DropdownMenu, {
				errorState = false,
				showDropShadow = false,
				dropdownMenuListPositionFixed = true,
				placeholder = v112,
				onChange = p13.props.themeSelectedCallback,
				height = p13.props.themeCellHeight,
				screenSize = p13.props.screenSize,
				onMenuOpenChange = if not GetFFlagEnableVREnvironmentSetting() and (not GetFFlagEnableSkyStyle() and not FFlagEnableRobloxPlusThemeSetting) then nil else function(b2: boolean) -- line: 738
					-- upvalues: p13 (copy), DeviceSettingsEnum (copy)
					p13.onDropdownMenuOpenChange(DeviceSettingsEnum.DeviceLevelTheme, b2)
				end,
				defaultKey = v111,
				cellDatas = {
					{
						key = DeviceLevelThemeKey.System,
						text = p14.deviceLevelThemeSystem
					},
					{
						key = DeviceLevelThemeKey.Dark,
						text = p14.deviceLevelThemeDark
					},
					{
						key = DeviceLevelThemeKey.Light,
						text = p14.deviceLevelThemeLight
					}
				}
			}) })
		}),
		RobloxPlusThemeDivider = if not v113 then nil else Divider({
			style = p16,
			layoutOrder = v99(DeviceSettingsEnum.RobloxPlusThemeDivider)
		}),
		RobloxPlusThemeDropdown = if not v113 then nil else Roact.createElement(DeviceSettingsPageSetting, {
			header = "Themes",
			description = "Pick a color palette to layer on top of your color mode.",
			style = p16,
			layoutOrder = v99(DeviceSettingsEnum.RobloxPlusTheme),
			zIndex = p13.getDropdownRowZIndex(DeviceSettingsEnum.RobloxPlusTheme),
			topToBottom = not v97,
			Control = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Size = if not v97 then UDim2.new(1, 0, 0, p13.props.themeCellHeight.Offset) else UDim2.new(0, v110, 0, p13.props.themeCellHeight.Offset)
			}, { Roact.createElement(DropdownMenu, {
				errorState = false,
				showDropShadow = false,
				dropdownMenuListPositionFixed = true,
				placeholder = if p13.props.robloxPlusTheme ~= v61.Green then p13.props.robloxPlusTheme ~= v61.Orange and "Default" or "Orange" else "Green",
				onChange = p13.props.setRobloxPlusTheme,
				height = p13.props.themeCellHeight,
				screenSize = p13.props.screenSize,
				onMenuOpenChange = function(b3: boolean) -- line: 794
					-- upvalues: p13 (copy), DeviceSettingsEnum (copy)
					p13.onDropdownMenuOpenChange(DeviceSettingsEnum.RobloxPlusTheme, b3)
				end,
				defaultKey = p13.props.robloxPlusTheme,
				cellDatas = {
					{
						text = "Default",
						key = v61.Default
					},
					{
						text = "Green",
						key = v61.Green
					},
					{
						text = "Orange",
						key = v61.Orange
					}
				}
			}) })
		}),
		Divider8 = if not GetFFlagEnableReadAloudInUA() then nil else Divider({
			style = p16,
			layoutOrder = v99(DeviceSettingsEnum.ReadAloudDivider)
		}),
		ReadAloud = if not GetFFlagEnableReadAloudInUA() then nil else Roact.createElement(DeviceSettingsPageSetting, {
			header = "Read Aloud",
			description = "Experimental feature to allow text to be read aloud when right clicking.",
			style = p16,
			layoutOrder = v99(DeviceSettingsEnum.ReadAloud),
			Control = Roact.createElement(Toggle, {
				label = "",
				isChecked = p13.state.readAloudEnabled,
				onActivated = p13.onReadAloudActivated,
				size = InputSize.Large
			})
		}),
		LocalPlayerPartyVoiceEligibleBinder = if not GetFFlagEnablePartyVoiceVolumeOnlyWhenInEligibleParty() then nil else Roact.createElement(LocalPlayerPartyVoiceEligibleBinder, {
			onChange = function(b4: boolean) -- line: 456
				-- upvalues: GetFFlagEnablePartyVoiceVolumeOnlyWhenInEligibleParty (copy), p13 (copy)
				if GetFFlagEnablePartyVoiceVolumeOnlyWhenInEligibleParty() then
					p13:setState({
						isLocalPlayerPartyVoiceEligible = b4
					})
				end
			end
		}),
		Divider9 = if not GetFFlagSystemTrayEnabled() or GetFFlagHideLaunchAtStartupMac() then nil else Divider({
			style = p16,
			layoutOrder = v99(DeviceSettingsEnum.LaunchAtStartupDivider)
		}),
		LaunchAtStartup = if not GetFFlagSystemTrayEnabled() or GetFFlagHideLaunchAtStartupMac() then nil else Roact.createElement(DeviceSettingsPageSetting, {
			style = p16,
			header = p14.launchAtStartupHeader,
			description = p14.launchAtStartupDescription,
			layoutOrder = v99(DeviceSettingsEnum.LaunchAtStartup),
			Control = Roact.createElement(Toggle, {
				label = "",
				isChecked = p13.state.isLaunchAtStartupEnabled,
				onActivated = p13.onLaunchAtStartupActivated,
				size = InputSize.Large
			})
		}),
		Divider10 = if not GetFFlagSystemTrayEnabled() then nil else Divider({
			style = p16,
			layoutOrder = v99(DeviceSettingsEnum.MinimizeToTrayDivider)
		}),
		MinimizeToTray = if not GetFFlagSystemTrayEnabled() then nil else Roact.createElement(DeviceSettingsPageSetting, {
			style = p16,
			header = p14.minimizeToTrayHeader,
			description = p14.minimizeToTrayDescription,
			layoutOrder = v99(DeviceSettingsEnum.MinimizeToTray),
			Control = Roact.createElement(Toggle, {
				label = "",
				isChecked = p13.state.isMinimizeToTrayEnabled,
				onActivated = p13.onMinimizeToTrayActivated,
				size = InputSize.Large
			})
		}),
		Divider11 = if not GetFFlagEnableVREnvironmentSetting() or (GetFFlagEnableSkyStyle() or not isSpatial) then nil else Divider({
			style = p16,
			layoutOrder = v99(DeviceSettingsEnum.VREnvironmentSettingDivider)
		}),
		VREnvironmentSetting = if not GetFFlagEnableVREnvironmentSetting() or (GetFFlagEnableSkyStyle() or not isSpatial) then nil else React.createElement(VREnvironmentSetting, {
			layoutOrder = v99(DeviceSettingsEnum.VREnvironmentSetting),
			isWideView = v97,
			contextualSliderWidth = v110,
			screenSize = p13.props.screenSize,
			zIndex = p13.getDropdownRowZIndex(DeviceSettingsEnum.VREnvironmentSetting),
			onMenuOpenChange = function(b5: boolean) -- line: 898
				-- upvalues: p13 (copy), DeviceSettingsEnum (copy)
				p13.onDropdownMenuOpenChange(DeviceSettingsEnum.VREnvironmentSetting, b5)
			end
		}),
		Divider12 = if not GetFFlagEnableSkyStyle() or not isSpatial then nil else Divider({
			style = p16,
			layoutOrder = v99(DeviceSettingsEnum.SkyStyleDivider)
		}),
		SkyStyle = if not GetFFlagEnableSkyStyle() or not isSpatial then nil else React.createElement(SkyStyleSetting, {
			layoutOrder = v99(DeviceSettingsEnum.SkyStyle),
			isWideView = v97,
			contextualSliderWidth = v110,
			screenSize = p13.props.screenSize,
			zIndex = p13.getDropdownRowZIndex(DeviceSettingsEnum.SkyStyle),
			onMenuOpenChange = function(b6: boolean) -- line: 916
				-- upvalues: p13 (copy), DeviceSettingsEnum (copy)
				p13.onDropdownMenuOpenChange(DeviceSettingsEnum.SkyStyle, b6)
			end
		})
	})
end
function v70.render(p18) -- line: 924
	-- upvalues: withLocalization (copy), UserInputService (copy), v48 (copy), withStyle (copy)
	return withLocalization({
		accessibilityDescription = "Feature.Accessibility.Description.Main",
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
		uiNavigationKeyBindHeader = "Feature.Accessibility.Heading.UiNavigationKeyBind",
		deviceLevelThemeHeading = "Feature.Accessibility.Heading.DeviceLevelTheme",
		deviceLevelThemeDescription = "Feature.Accessibility.Description.DeviceLevelTheme",
		deviceLevelThemeDark = "Feature.Accessibility.DeviceLevelTheme.Dark",
		deviceLevelThemeLight = "Feature.Accessibility.DeviceLevelTheme.Light",
		deviceLevelThemeSystem = "Feature.Accessibility.DeviceLevelTheme.System",
		uiNavigationKeyBindDescription = {
			"Feature.Accessibility.Description.UiNavigationKeyBind",
			uiNavigationKey = UserInputService:GetStringForKeyCode(Enum.KeyCode.BackSlash)
		},
		launchAtStartupHeader = (not v48 or not p18.props.isMacVariant) and "Feature.Accessibility.Heading.LaunchAtStartup" or "Feature.Accessibility.Heading.LaunchAtLogin",
		launchAtStartupDescription = (not v48 or not p18.props.isMacVariant) and "Feature.Accessibility.Description.LaunchAtStartup" or nil,
		minimizeToTrayHeader = (not v48 or not p18.props.isMacVariant) and "Feature.Accessibility.Heading.MinimizeToTray" or "Feature.Accessibility.Header.ShowInMenuBar",
		minimizeToTrayDescription = (not v48 or not p18.props.isMacVariant) and "Feature.Accessibility.Description.MinimizeToTray" or nil
	})(function(p19) -- line: 959
		-- upvalues: withStyle (copy), p18 (copy)
		return withStyle(function(p20) -- line: 960
			-- upvalues: p18 (copy), p19 (copy)
			return p18:renderWithProviders(p19, p20.Theme.BackgroundDefault, p20)
		end)
	end)
end
function v70.willUnmount(p21) -- line: 966
	p21:eventDisconnect()
end

local u73 = RoactRodux.connect(function(p22, _) -- line: 970
	-- upvalues: v38 (copy)
	return {
		formFactor = p22.FormFactor,
		platform = p22.Platform,
		screenSize = if not v38 then nil else p22.ScreenSize
	}
end)(v70)

if v48 then
	u73 = RoactAppPolicy.connect(function(p24) -- line: 979
		return {
			isMacVariant = p24.getDevicePreferencesPersistentPresenceVariant() == "mac"
		}
	end)(u73)
end

local function DeviceSettingsPageContentContainer(p25) -- line: 987
	-- upvalues: React (copy), ThemeContext (copy), v38 (copy), useLocalUserId (copy), GetFFlagEnableThemeUpdatedLoggingFix (copy), ApplyThemeSelection (copy), DeviceLevelThemeKey (copy), v39 (copy), GetSystemTheme (copy), v40 (copy), Logger (copy), useTokens (copy), FFlagEnableRobloxPlusThemeSetting (copy), v62 (copy), useSignalState (copy), v63 (copy), Cryo (copy), useIsSpatial (copy), u73 (ref)
	local v120 = React.useContext(ThemeContext)
	local v121 = if not v38 then nil else useLocalUserId()
	local v122 = React.useCallback(function(s1: string) -- line: 990
		-- upvalues: GetFFlagEnableThemeUpdatedLoggingFix (copy), ApplyThemeSelection (copy), DeviceLevelThemeKey (copy), v39 (copy), GetSystemTheme (copy), v40 (copy), Logger (copy)
		if GetFFlagEnableThemeUpdatedLoggingFix() then
			ApplyThemeSelection(s1, {})

			return
		end

		local v159 = nil

		if s1 == DeviceLevelThemeKey.System then
			v159 = v39 and GetSystemTheme(v39) or nil
		elseif s1 == DeviceLevelThemeKey.Light then
			v159 = v40 and v40.Light or nil
		elseif s1 == DeviceLevelThemeKey.Dark then
			v159 = v40 and v40.Dark or nil
		end

		Logger:info("The user selected theme: " .. s1 .. ". Setting theme to: " .. tostring(v159))

		if v39 and v159 then
			v39:setTheme(v159)
		end
	end, { v120 })
	local v123 = useTokens()
	local uDim = UDim.new(0, v123.Size.Size_1200)
	local v125 = nil
	local v126 = nil
	local v127 = nil

	if FFlagEnableRobloxPlusThemeSetting then
		local v128 = v62(false)

		v125 = useSignalState(v128.getColorThemeKey)
		v126 = React.useCallback(function(s2: string) -- line: 1019
			-- upvalues: v128 (copy)
			v128.setColorThemeKey(s2)
		end, { v128 })
		v127 = v63()
	end

	local v129 = Cryo.Dictionary.join(p25, {
		themeSelectedCallback = v122,
		themeCellHeight = uDim,
		userId = v121,
		isSpatial = useIsSpatial(),
		robloxPlusTheme = v125,
		setRobloxPlusTheme = v126,
		showRobloxPlusThemeSetting = v127
	})

	return React.createElement(u73, v129)
end

return if not v38 then RoactServices.connect({
	roactAnalytics = RoactAnalytics
})(u73) else RoactServices.connect({
	roactAnalytics = RoactAnalytics
})(DeviceSettingsPageContentContainer)
