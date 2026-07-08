local Players = game:GetService("Players")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local GuiService = game:GetService("GuiService")
local CorePackages = game:GetService("CorePackages")
local VRService = game:GetService("VRService")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local Platform = game:GetService("UserInputService"):GetPlatform()
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local t = InGameMenuDependencies.t
local UIBlox = InGameMenuDependencies.UIBlox
local LocalPlayer = Players.LocalPlayer
local PropertyChangedSignal = LocalPlayer:GetPropertyChangedSignal("DevEnableMouseLock")
local PropertyChangedSignal2 = UserGameSettings:GetPropertyChangedSignal("IsUsingCameraYInverted")
local FocusHandler = require(script.Parent.Parent.Connection.FocusHandler)
local ParentParent = script.Parent.Parent.Parent
local Divider = require(ParentParent.Components.Divider)
local ExternalEventConnection = require(ParentParent.Utility.ExternalEventConnection)
local Page = require(ParentParent.Components.Page)
local ThemedTextLabel = require(ParentParent.Components.ThemedTextLabel)
local withLocalization = require(ParentParent.Localization.withLocalization)
local Assets = require(ParentParent.Resources.Assets)
local SetCurrentPage = require(ParentParent.Actions.SetCurrentPage)
local AutoPropertyToggleEntry = require(script.Parent.AutoPropertyToggleEntry)
local SafetyBubbleModeEntry = require(script.Parent.SafetyBubbleModeEntry)
local ComfortSettingsEntry = nil

if game:GetEngineFeature("VRMoreComfortSettings") then
	ComfortSettingsEntry = require(script.Parent.ComfortSettingsEntry)
end

local CameraModeEntry = require(script.Parent.CameraModeEntry)
local CameraSensitivityEntry = require(script.Parent.CameraSensitivityEntry)
local CategoryHeader = require(script.Parent.CategoryHeader)
local DeviceSelectionEntry = require(script.Parent.DeviceSelectionEntry)
local GraphicsQualityEntry = require(script.Parent.GraphicsQualityEntry)
local MovementModeEntry = require(script.Parent.MovementModeEntry)
local ToggleEntry = require(script.Parent.ToggleEntry)
local VolumeEntry = require(script.Parent.VolumeEntry)
local SendAnalytics = require(ParentParent.Utility.SendAnalytics)
local Constants = require(ParentParent.Resources.Constants)
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Flags = ParentParent.Flags
local GetFFlagIGMGamepadSelectionHistory = require(Flags.GetFFlagIGMGamepadSelectionHistory)
local GetFFlagAlwaysShowVRToggle = require(RobloxGui.Modules.Flags.GetFFlagAlwaysShowVRToggle)
local EngineFeature = game:GetEngineFeature("VRMoreComfortSettings")
local PropertyChangedSignal3 = UserGameSettings:GetPropertyChangedSignal("VREnabled")
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local v47 = Roact.PureComponent:extend("BasicPage")

v47.validateProps = t.strictInterface({
	switchToAdvancedPage = t.callback,
	switchToVRComfortSettingsPage = t.callback,
	pageTitle = t.string,
	isMenuOpen = t.boolean,
	currentPage = t.optional(t.string),
	canCaptureFocus = t.optional(t.boolean),
	canGamepadCaptureFocus = t.optional(t.boolean),
	vrService = t.optional(t.union(t.Instance, t.table)),
	isVRAppBuild = t.optional(t.callback),
	currentZone = GetFFlagIGMGamepadSelectionHistory() and t.optional(t.number) or nil
})
v47.defaultProps = {
	vrService = VRService,
	isVRAppBuild = IsVRAppBuild
}

local VREnabled = UserGameSettings.VREnabled

function v47.init(p1) -- line: 94
	-- upvalues: LocalPlayer (copy), UserGameSettings (copy), Roact (copy)
	p1:setState({
		voiceChatEnabled = false,
		shiftLockEnabled = LocalPlayer.DevEnableMouseLock,
		fullScreenEnabled = UserGameSettings:InFullScreen(),
		invertedCameraEnabled = UserGameSettings.IsUsingCameraYInverted,
		vrActive = p1.props.vrService.VREnabled,
		vrEnabled = UserGameSettings.VREnabled
	})

	local v51, v52 = Roact.createBinding(UDim2.new(0, 0, 0, 0))

	p1.pageSize = v51
	p1.setPageSize = v52
	p1.cameraModeButton = Roact.createRef()
	p1.volumeButton = Roact.createRef()
end
function v47.didUpdate(p2, p3) -- line: 110
	-- upvalues: GetFFlagIGMGamepadSelectionHistory (copy), GuiService (copy)
	if not GetFFlagIGMGamepadSelectionHistory() and (p2.props.canCaptureFocus and p2.props.canGamepadCaptureFocus) and (not p3.canCaptureFocus or not p3.canGamepadCaptureFocus) then
		if not p2.state.vrActive then
			GuiService.SelectedCoreObject = p2.cameraModeButton:getValue()

			return
		end

		GuiService.SelectedCoreObject = p2.volumeButton:getValue()
	end
end

local function createLayoutOrderGenerator() -- line: 127
	local n1 = 0

	return function() -- line: 129
		-- upvalues: n1 (ref)
		n1 += 1

		return n1
	end
end

function v47.renderWithSelectionCursor(p4, p5) -- line: 135
	-- upvalues: GetFFlagAlwaysShowVRToggle (copy), Platform (copy), UserGameSettings (copy), Roact (copy), Page (copy), GetFFlagIGMGamepadSelectionHistory (copy), FocusHandler (copy), Constants (copy), GuiService (copy), CategoryHeader (copy), EngineFeature (copy), AutoPropertyToggleEntry (copy), ComfortSettingsEntry (ref), withLocalization (copy), ThemedTextLabel (copy), ImageSetLabel (copy), Assets (copy), VREnabled (copy), SafetyBubbleModeEntry (copy), Divider (copy), CameraModeEntry (copy), CameraSensitivityEntry (copy), MovementModeEntry (copy), VolumeEntry (copy), DeviceSelectionEntry (copy), GraphicsQualityEntry (copy), ToggleEntry (copy), SendAnalytics (copy), CursorKind (copy), ExternalEventConnection (copy), PropertyChangedSignal (copy), LocalPlayer (copy), PropertyChangedSignal2 (copy), PropertyChangedSignal3 (copy)
	local n2 = 0

	local function v59() -- line: 129
		-- upvalues: n2 (ref)
		n2 += 1

		return n2
	end

	local v60 = p4.state.voiceChatEnabled and not p4.props.isVRAppBuild()
	local v61 = if not GetFFlagAlwaysShowVRToggle() then (p4.state.vrActive or UserGameSettings.HasEverUsedVR) and not p4.props.isVRAppBuild() else Platform == Enum.Platform.Windows or Platform == Enum.Platform.UWP

	return Roact.createElement(Page, {
		pageTitle = p4.props.pageTitle,
		position = p4.props.position
	}, {
		FocusHandler = GetFFlagIGMGamepadSelectionHistory() and Roact.createElement(FocusHandler, {
			isFocused = p4.props.canCaptureFocus and p4.props.canGamepadCaptureFocus,
			shouldForgetPreviousSelection = p4.props.currentPage == Constants.MainPagePageKey or p4.props.currentZone == 0,
			didFocus = function(p6) -- line: 150
				-- upvalues: GuiService (copy), p4 (copy)
				if p6 then
					GuiService.SelectedCoreObject = p6

					return
				end

				if not p4.state.vrActive then
					GuiService.SelectedCoreObject = p4.cameraModeButton:getValue()

					return
				end

				GuiService.SelectedCoreObject = p4.volumeButton:getValue()
			end
		}) or nil,
		PageContents = Roact.createElement("ScrollingFrame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Selectable = false,
			CanvasSize = p4.pageSize,
			Position = p4.props.position,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			Layout = Roact.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				[Roact.Change.AbsoluteContentSize] = function(p7) -- line: 172
					-- upvalues: p4 (copy)
					p4.setPageSize(UDim2.new(0, 0, 0, p7.AbsoluteContentSize.Y))
				end
			}),
			VRControlsHeader = if not p4.state.vrActive then nil else Roact.createElement(CategoryHeader, {
				localizationKey = "CoreScripts.InGameMenu.GameSettings.VrControlsTitle",
				LayoutOrder = v59()
			}),
			VignetteEnabled = if EngineFeature or not p4.state.vrActive then nil else Roact.createElement(AutoPropertyToggleEntry, {
				labelKey = "CoreScripts.InGameMenu.GameSettings.VignetteEnabled",
				valueKey = "VignetteEnabled",
				LayoutOrder = v59(),
				instance = UserGameSettings
			}),
			VRSmoothRotationEnabled = if EngineFeature or not p4.state.vrActive then nil else Roact.createElement(AutoPropertyToggleEntry, {
				labelKey = "CoreScripts.InGameMenu.GameSettings.VRSmoothRotationEnabled",
				valueKey = "VRSmoothRotationEnabled",
				LayoutOrder = v59(),
				instance = UserGameSettings
			}),
			VRComfortSettings = if not EngineFeature or not p4.state.vrActive then nil else Roact.createElement(ComfortSettingsEntry, {
				LayoutOrder = v59()
			}),
			VRComfortSettingsPageButton = if not EngineFeature or not p4.state.vrActive then nil else Roact.createElement("TextButton", {
				LayoutOrder = v59(),
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 54),
				Text = "",
				[Roact.Event.Activated] = p4.props.switchToVRComfortSettingsPage
			}, {
				Text = withLocalization({
					text = "CoreScripts.InGameMenu.GameSettings.SwitchToVRComfortSettings"
				})(function(p8) -- line: 213
					-- upvalues: Roact (copy), ThemedTextLabel (copy)
					return Roact.createElement(ThemedTextLabel, {
						fontKey = "Body",
						themeKey = "TextDefault",
						Text = p8.text,
						TextXAlignment = Enum.TextXAlignment.Left,
						Size = UDim2.new(1, -96, 1, 0),
						Position = UDim2.new(0, 24, 0.5, 0),
						AnchorPoint = Vector2.new(0, 0.5)
					})
				end),
				Icon = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Image = Assets.Images.NavigateForward,
					Size = UDim2.new(0, 36, 0, 36),
					Position = UDim2.new(1, -36, 0.5, 0),
					AnchorPoint = Vector2.new(1, 0.5)
				})
			}),
			VRMode = if not v61 then nil else Roact.createElement(AutoPropertyToggleEntry, {
				labelKey = "CoreScripts.InGameMenu.GameSettings.VREnabled",
				valueKey = "VREnabled",
				subtextKey = "CoreScripts.InGameMenu.GameSettings.RestartPending",
				LayoutOrder = v59(),
				instance = UserGameSettings,
				subtextEnabled = p4.state.vrEnabled ~= VREnabled
			}),
			VRSafetyBubbleMode = if not p4.state.vrActive then nil else Roact.createElement(SafetyBubbleModeEntry, {
				LayoutOrder = v59()
			}),
			VRControlsDivider = if not p4.state.vrActive then nil else Roact.createElement(Divider, {
				LayoutOrder = v59(),
				Size = UDim2.new(1, -24, 0, 1)
			}),
			CameraHeader = if p4.state.vrActive then nil else Roact.createElement(CategoryHeader, {
				localizationKey = "CoreScripts.InGameMenu.GameSettings.CameraTitle",
				LayoutOrder = v59()
			}),
			CameraMode = not p4.state.vrActive and Roact.createElement(CameraModeEntry, {
				LayoutOrder = v59(),
				ButtonRef = p4.cameraModeButton,
				canOpen = p4.props.canCaptureFocus,
				canCaptureFocus = p4.props.canGamepadCaptureFocus
			}),
			InvertedCamera = not p4.state.vrActive and (p4.state.invertedCameraEnabled and Roact.createElement(AutoPropertyToggleEntry, {
				labelKey = "CoreScripts.InGameMenu.GameSettings.InvertedCamera",
				valueKey = "CameraYInverted",
				LayoutOrder = v59(),
				instance = UserGameSettings
			})),
			CameraSensitivity = not p4.state.vrActive and Roact.createElement(CameraSensitivityEntry, {
				LayoutOrder = v59(),
				canCaptureFocus = p4.props.canCaptureFocus and p4.props.canGamepadCaptureFocus,
				isMenuOpen = p4.props.isMenuOpen
			}),
			CameraDivider = if p4.state.vrActive then nil else Roact.createElement(Divider, {
				LayoutOrder = v59(),
				Size = UDim2.new(1, -24, 0, 1)
			}),
			ControlsHeader = Roact.createElement(CategoryHeader, {
				localizationKey = "CoreScripts.InGameMenu.GameSettings.ControlsAudio",
				LayoutOrder = v59()
			}),
			ShiftLock = not p4.state.vrActive and Roact.createElement(AutoPropertyToggleEntry, {
				labelKey = "CoreScripts.InGameMenu.GameSettings.ShiftLock",
				valueKey = "ControlMode",
				LayoutOrder = v59(),
				instance = UserGameSettings,
				onValue = Enum.ControlMode.MouseLockSwitch,
				offValue = Enum.ControlMode.Classic,
				lockedToOff = not p4.state.shiftLockEnabled
			}),
			MovementMode = not p4.state.vrActive and Roact.createElement(MovementModeEntry, {
				LayoutOrder = v59(),
				canOpen = p4.props.canCaptureFocus,
				canCaptureFocus = p4.props.canGamepadCaptureFocus
			}),
			VolumeEntry = Roact.createElement(VolumeEntry, {
				LayoutOrder = v59(),
				buttonRef = p4.volumeButton,
				canCaptureFocus = p4.props.canCaptureFocus and p4.props.canGamepadCaptureFocus,
				isMenuOpen = p4.props.isMenuOpen
			}),
			HapticsToggle = Roact.createElement(AutoPropertyToggleEntry, {
				labelKey = "Feature.Accessibility.Header.Haptics",
				valueKey = "HapticStrength",
				onValue = 1,
				offValue = 0,
				LayoutOrder = v59(),
				instance = UserGameSettings
			}),
			InputDevice = v60 and Roact.createElement(DeviceSelectionEntry, {
				LayoutOrder = v59(),
				deviceType = DeviceSelectionEntry.DeviceType.Input,
				isMenuOpen = p4.props.isMenuOpen,
				canOpen = p4.props.canCaptureFocus,
				canCaptureFocus = p4.props.canGamepadCaptureFocus
			}),
			OutputDevice = v60 and Roact.createElement(DeviceSelectionEntry, {
				LayoutOrder = v59(),
				deviceType = DeviceSelectionEntry.DeviceType.Output,
				isMenuOpen = p4.props.isMenuOpen,
				canOpen = p4.props.canCaptureFocus,
				canCaptureFocus = p4.props.canGamepadCaptureFocus
			}),
			ControlsDivider = Roact.createElement(Divider, {
				LayoutOrder = v59(),
				Size = UDim2.new(1, -24, 0, 1)
			}),
			GraphicsHeader = Roact.createElement(CategoryHeader, {
				localizationKey = "CoreScripts.InGameMenu.GameSettings.GraphicsTitle",
				LayoutOrder = v59()
			}),
			GraphicsQualityEntry = Roact.createElement(GraphicsQualityEntry, {
				LayoutOrder = v59(),
				canCaptureFocus = p4.props.canCaptureFocus and p4.props.canGamepadCaptureFocus,
				isMenuOpen = p4.props.isMenuOpen
			}),
			FullScreen = not p4.state.vrActive and Roact.createElement(ToggleEntry, {
				labelKey = "CoreScripts.InGameMenu.GameSettings.FullScreen",
				LayoutOrder = v59(),
				checked = p4.state.fullScreenEnabled,
				onToggled = function() -- line: 355
					-- upvalues: GuiService (copy), SendAnalytics (copy), Constants (copy)
					GuiService:ToggleFullscreen()
					SendAnalytics(Constants.AnalyticsSettingsChangeName, nil, {}, true)
				end
			}),
			GraphicsDivider = Roact.createElement(Divider, {
				LayoutOrder = v59(),
				Size = UDim2.new(1, -24, 0, 1)
			}),
			AdvancedSettings = Roact.createElement("TextButton", {
				LayoutOrder = v59(),
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 54),
				Text = "",
				SelectionImageObject = p5(CursorKind.Square),
				[Roact.Event.Activated] = p4.props.switchToAdvancedPage
			}, {
				Text = withLocalization({
					text = "CoreScripts.InGameMenu.GameSettings.SwitchToAdvancedSettings"
				})(function(p9) -- line: 374
					-- upvalues: Roact (copy), ThemedTextLabel (copy)
					return Roact.createElement(ThemedTextLabel, {
						fontKey = "Body",
						themeKey = "TextDefault",
						Text = p9.text,
						TextXAlignment = Enum.TextXAlignment.Left,
						Size = UDim2.new(1, -96, 1, 0),
						Position = UDim2.new(0, 24, 0.5, 0),
						AnchorPoint = Vector2.new(0, 0.5)
					})
				end),
				Icon = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Image = Assets.Images.NavigateForward,
					Size = UDim2.new(0, 36, 0, 36),
					Position = UDim2.new(1, -36, 0.5, 0),
					AnchorPoint = Vector2.new(1, 0.5)
				})
			}),
			AdvancedDivider = Roact.createElement(Divider, {
				LayoutOrder = v59(),
				Size = UDim2.new(1, -24, 0, 1)
			}),
			ShiftLockEnabledListener = Roact.createElement(ExternalEventConnection, {
				event = PropertyChangedSignal,
				callback = function() -- line: 405
					-- upvalues: p4 (copy), LocalPlayer (copy)
					p4:setState({
						shiftLockEnabled = LocalPlayer.DevEnableMouseLock
					})
				end
			}),
			FullScreenListener = Roact.createElement(ExternalEventConnection, {
				event = UserGameSettings.FullscreenChanged,
				callback = function(p10) -- line: 413
					-- upvalues: p4 (copy), SendAnalytics (copy), Constants (copy)
					p4:setState({
						fullScreenEnabled = p10
					})
					SendAnalytics(Constants.AnalyticsInGameMenuName, Constants.AnalyticsFullscreenModeName, {
						enabled = p10
					})
				end
			}),
			CameraYInvertedListener = Roact.createElement(ExternalEventConnection, {
				event = PropertyChangedSignal2,
				callback = function() -- line: 425
					-- upvalues: p4 (copy), UserGameSettings (copy)
					p4:setState({
						invertedCameraEnabled = UserGameSettings.IsUsingCameraYInverted
					})
				end
			}),
			VRActiveListener = Roact.createElement(ExternalEventConnection, {
				event = p4.props.vrService:GetPropertyChangedSignal("VREnabled"),
				callback = function() -- line: 433
					-- upvalues: p4 (copy), UserGameSettings (copy)
					if p4.props.vrService.VREnabled then
						UserGameSettings.HasEverUsedVR = true
					end

					p4:setState({
						vrActive = p4.props.vrService.VREnabled
					})
				end
			}),
			VREnabledListener = Roact.createElement(ExternalEventConnection, {
				event = PropertyChangedSignal3,
				callback = function() -- line: 444
					-- upvalues: p4 (copy), UserGameSettings (copy)
					p4:setState({
						vrEnabled = UserGameSettings.VREnabled
					})
				end
			})
		})
	})
end
function v47.render(p11) -- line: 454
	-- upvalues: withSelectionCursorProvider (copy)
	return withSelectionCursorProvider(function(p12) -- line: 455
		-- upvalues: p11 (copy)
		return p11:renderWithSelectionCursor(p12)
	end)
end
function v47.didMount(p13) -- line: 460
	-- upvalues: RobloxGui (copy)
	spawn(function() -- line: 461
		-- upvalues: RobloxGui (copy), p13 (copy)
		require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager).default:asyncInit():andThen(function() -- line: 466
			-- upvalues: p13 (copy)
			p13:setState({
				voiceChatEnabled = true
			})
		end):catch(function() -- line: 471
		end)
	end)
end

return RoactRodux.UNSTABLE_connect2(function(p14) -- line: 475
	-- upvalues: Constants (copy), GetFFlagIGMGamepadSelectionHistory (copy)
	local v65 = p14.menuPage == "GameSettings" and (p14.isMenuOpen and not p14.respawn.dialogOpen)
	local v66 = p14.displayOptions.inputType == Constants.InputType.Gamepad and p14.currentZone == 1
	local currentZone = nil

	if GetFFlagIGMGamepadSelectionHistory() then
		currentZone = p14.currentZone
	end

	return {
		isMenuOpen = p14.isMenuOpen,
		currentPage = p14.menuPage,
		currentZone = currentZone,
		canCaptureFocus = v65,
		canGamepadCaptureFocus = v66
	}
end, function(p15) -- line: 493
	-- upvalues: SetCurrentPage (copy), Constants (copy)
	return {
		switchToAdvancedPage = function() -- line: 495
			-- upvalues: p15 (copy), SetCurrentPage (copy), Constants (copy)
			p15(SetCurrentPage(Constants.advancedSettingsPageKey))
		end,
		switchToVRComfortSettingsPage = function() -- line: 498
			-- upvalues: p15 (copy), SetCurrentPage (copy), Constants (copy)
			p15(SetCurrentPage(Constants.vrComfortSettingsPageKey))
		end
	}
end)(v47)
