local Players = game:GetService("Players")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local GuiService = game:GetService("GuiService")
local CorePackages = game:GetService("CorePackages")
local VRService = game:GetService("VRService")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local UserInputService = game:GetService("UserInputService")

local platform = UserInputService:GetPlatform()
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local t = InGameMenuDependencies.t
local UIBlox = InGameMenuDependencies.UIBlox

local LocalPlayer = Players.LocalPlayer
local propertyChangedSignal = LocalPlayer:GetPropertyChangedSignal("DevEnableMouseLock")

local propertyChangedSignal2 = UserGameSettings:GetPropertyChangedSignal("IsUsingCameraYInverted")

local FocusHandler = require(script.Parent.Parent.Connection.FocusHandler)

local parent = script.Parent.Parent.Parent

local Divider = require(parent.Components.Divider)
local ExternalEventConnection = require(parent.Utility.ExternalEventConnection)
local Page = require(parent.Components.Page)
local ThemedTextLabel = require(parent.Components.ThemedTextLabel)

local withLocalization = require(parent.Localization.withLocalization)
local Assets = require(parent.Resources.Assets)

local SetCurrentPage = require(parent.Actions.SetCurrentPage)

local AutoPropertyToggleEntry = require(script.Parent.AutoPropertyToggleEntry)
local SafetyBubbleModeEntry = require(script.Parent.SafetyBubbleModeEntry)
local ComfortSettingsEntry

if game:GetEngineFeature("VRMoreComfortSettings") then
	ComfortSettingsEntry = require(script.Parent.ComfortSettingsEntry)
else
	ComfortSettingsEntry = nil
end

local CameraModeEntry = require(script.Parent.CameraModeEntry)
local CameraSensitivityEntry = require(script.Parent.CameraSensitivityEntry)
local CategoryHeader = require(script.Parent.CategoryHeader)
local DeviceSelectionEntry = require(script.Parent.DeviceSelectionEntry)
local GraphicsQualityEntry = require(script.Parent.GraphicsQualityEntry)
local MovementModeEntry = require(script.Parent.MovementModeEntry)
local ToggleEntry = require(script.Parent.ToggleEntry)
local VolumeEntry = require(script.Parent.VolumeEntry)

local SendAnalytics = require(parent.Utility.SendAnalytics)
local Constants = require(parent.Resources.Constants)

local Foundation = require(CorePackages.Packages.Foundation)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagCoreUiMigrateUIBloxToFoundation = SharedFlags.FFlagCoreUiMigrateUIBloxToFoundation
local v

if FFlagCoreUiMigrateUIBloxToFoundation then
	v = Foundation.UNSTABLE.withCursorMigration
else
	v = UIBlox.App.SelectionImage.withSelectionCursorProvider
end

local v2

if FFlagCoreUiMigrateUIBloxToFoundation then
	v2 = Foundation.Enums.CursorType
else
	v2 = UIBlox.App.SelectionImage.CursorKind
end

local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local flags = parent.Flags
local GetFFlagIGMGamepadSelectionHistory = require(flags.GetFFlagIGMGamepadSelectionHistory)
local GetFFlagAlwaysShowVRToggle = require(RobloxGui.Modules.Flags.GetFFlagAlwaysShowVRToggle)

local engineFeature = game:GetEngineFeature("VRMoreComfortSettings")

local propertyChangedSignal3 = UserGameSettings:GetPropertyChangedSignal("VREnabled")
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local IsVRAppBuild = AppCommonLib.IsVRAppBuild

local extended = Roact.PureComponent:extend("BasicPage")
extended.validateProps = t.strictInterface({
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

extended.defaultProps = { vrService = VRService, isVRAppBuild = IsVRAppBuild }

local VREnabled = UserGameSettings.VREnabled

function extended:init()
	self:setState({
		shiftLockEnabled = LocalPlayer.DevEnableMouseLock,
		fullScreenEnabled = UserGameSettings:InFullScreen(),
		invertedCameraEnabled = UserGameSettings.IsUsingCameraYInverted,
		vrActive = self.props.vrService.VREnabled,
		vrEnabled = UserGameSettings.VREnabled,
		voiceChatEnabled = false
	})

	local binding, setPageSize = Roact.createBinding(UDim2.new(0, 0, 0, 0))
	self.pageSize = binding
	self.setPageSize = setPageSize

	self.cameraModeButton = Roact.createRef()
	self.volumeButton = Roact.createRef()
end

function extended.didUpdate(data, p)
	if
		not GetFFlagIGMGamepadSelectionHistory()
		and data.props.canCaptureFocus
		and data.props.canGamepadCaptureFocus
		and not (p.canCaptureFocus and p.canGamepadCaptureFocus)
	then
		if data.state.vrActive then
			GuiService.SelectedCoreObject = data.volumeButton:getValue()
		else
			GuiService.SelectedCoreObject = data.cameraModeButton:getValue()
		end
	end
end

local function createLayoutOrderGenerator() -- 1 equivalent call inferred from this helper
	local count = 0
	return function()
		count += 1
		return count
	end
end

function extended:renderWithSelectionCursor(callback)
	local layoutOrderGenerator = createLayoutOrderGenerator() -- inferred equivalent call
	local v3 = self.state.voiceChatEnabled and not self.props.isVRAppBuild()
	local v4

	if GetFFlagAlwaysShowVRToggle() then
		v4 = platform == Enum.Platform.Windows or platform == Enum.Platform.UWP
	else
		v4 = (self.state.vrActive or UserGameSettings.HasEverUsedVR) and not self.props.isVRAppBuild()
	end

	local createElement = Roact.createElement
	local v5 = { pageTitle = self.props.pageTitle, position = self.props.position }
	local focusHandler

	if GetFFlagIGMGamepadSelectionHistory() then
		focusHandler = Roact.createElement(FocusHandler, {
			isFocused = self.props.canCaptureFocus and self.props.canGamepadCaptureFocus,
			shouldForgetPreviousSelection = self.props.currentPage == Constants.MainPagePageKey or self.props.currentZone == 0,
			didFocus = function(selectedCoreObject)
				if selectedCoreObject then
					GuiService.SelectedCoreObject = selectedCoreObject
				elseif self.state.vrActive then
					GuiService.SelectedCoreObject = self.volumeButton:getValue()
				else
					GuiService.SelectedCoreObject = self.cameraModeButton:getValue()
				end
			end
		}) or nil
	end

	local createElement2 = Roact.createElement
	local v6 = {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		CanvasSize = self.pageSize,
		Position = self.props.position,
		Size = UDim2.new(1, 0, 1, 0),
		Selectable = false
	}

	local children = {}
	children.Layout = Roact.createElement("UIListLayout", {
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		[Roact.Change.AbsoluteContentSize] = function(p)
			self.setPageSize(UDim2.new(0, 0, 0, p.AbsoluteContentSize.Y))
		end
	})
	local vrControlsHeader

	if self.state.vrActive then
		vrControlsHeader = Roact.createElement(CategoryHeader, {
			LayoutOrder = layoutOrderGenerator(),
			localizationKey = "CoreScripts.InGameMenu.GameSettings.VrControlsTitle"
		})
	end

	children.VRControlsHeader = vrControlsHeader
	local vignetteEnabled

	if not (engineFeature or not self.state.vrActive) then
		vignetteEnabled = Roact.createElement(AutoPropertyToggleEntry, {
			LayoutOrder = layoutOrderGenerator(),
			labelKey = "CoreScripts.InGameMenu.GameSettings.VignetteEnabled",
			instance = UserGameSettings,
			valueKey = "VignetteEnabled"
		})
	end

	children.VignetteEnabled = vignetteEnabled
	local vrSmoothRotationEnabled

	if not (engineFeature or not self.state.vrActive) then
		vrSmoothRotationEnabled = Roact.createElement(AutoPropertyToggleEntry, {
			LayoutOrder = layoutOrderGenerator(),
			labelKey = "CoreScripts.InGameMenu.GameSettings.VRSmoothRotationEnabled",
			instance = UserGameSettings,
			valueKey = "VRSmoothRotationEnabled"
		})
	end

	children.VRSmoothRotationEnabled = vrSmoothRotationEnabled
	local vrComfortSettings

	if engineFeature and self.state.vrActive then
		vrComfortSettings = Roact.createElement(ComfortSettingsEntry, {
			LayoutOrder = layoutOrderGenerator()
		})
	end

	children.VRComfortSettings = vrComfortSettings
	local vrComfortSettingsPageButton

	if engineFeature and self.state.vrActive then
		vrComfortSettingsPageButton = Roact.createElement("TextButton", {
			LayoutOrder = layoutOrderGenerator(),
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 54),
			Text = "",
			[Roact.Event.Activated] = self.props.switchToVRComfortSettingsPage
		}, {
			Text = withLocalization({
				text = "CoreScripts.InGameMenu.GameSettings.SwitchToVRComfortSettings"
			})(function(p)
				return Roact.createElement(ThemedTextLabel, {
					Text = p.text,
					TextXAlignment = Enum.TextXAlignment.Left,
					fontKey = "Body",
					themeKey = "TextDefault",
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
		})
	end

	children.VRComfortSettingsPageButton = vrComfortSettingsPageButton
	local vrMode

	if v4 then
		vrMode = Roact.createElement(AutoPropertyToggleEntry, {
			LayoutOrder = layoutOrderGenerator(),
			labelKey = "CoreScripts.InGameMenu.GameSettings.VREnabled",
			instance = UserGameSettings,
			valueKey = "VREnabled",
			subtextEnabled = self.state.vrEnabled ~= VREnabled,
			subtextKey = "CoreScripts.InGameMenu.GameSettings.RestartPending"
		})
	end

	children.VRMode = vrMode
	local vrSafetyBubbleMode

	if self.state.vrActive then
		vrSafetyBubbleMode = Roact.createElement(SafetyBubbleModeEntry, {
			LayoutOrder = layoutOrderGenerator()
		})
	end

	children.VRSafetyBubbleMode = vrSafetyBubbleMode
	local vrControlsDivider

	if self.state.vrActive then
		vrControlsDivider = Roact.createElement(Divider, {
			LayoutOrder = layoutOrderGenerator(),
			Size = UDim2.new(1, -24, 0, 1)
		})
	end

	children.VRControlsDivider = vrControlsDivider
	local cameraHeader

	if not self.state.vrActive then
		cameraHeader = Roact.createElement(CategoryHeader, {
			LayoutOrder = layoutOrderGenerator(),
			localizationKey = "CoreScripts.InGameMenu.GameSettings.CameraTitle"
		})
	end

	children.CameraHeader = cameraHeader

	children.CameraMode = not self.state.vrActive
		and Roact.createElement(CameraModeEntry, {
			LayoutOrder = layoutOrderGenerator(),
			ButtonRef = self.cameraModeButton,
			canOpen = self.props.canCaptureFocus,
			canCaptureFocus = self.props.canGamepadCaptureFocus
		})

	children.InvertedCamera = not self.state.vrActive
		and self.state.invertedCameraEnabled
		and Roact.createElement(AutoPropertyToggleEntry, {
			LayoutOrder = layoutOrderGenerator(),
			labelKey = "CoreScripts.InGameMenu.GameSettings.InvertedCamera",
			instance = UserGameSettings,
			valueKey = "CameraYInverted"
		})

	children.CameraSensitivity = not self.state.vrActive and Roact.createElement(CameraSensitivityEntry, {
		LayoutOrder = layoutOrderGenerator(),
		canCaptureFocus = self.props.canCaptureFocus and self.props.canGamepadCaptureFocus,
		isMenuOpen = self.props.isMenuOpen
	})
	local cameraDivider

	if not self.state.vrActive then
		cameraDivider = Roact.createElement(Divider, {
			LayoutOrder = layoutOrderGenerator(),
			Size = UDim2.new(1, -24, 0, 1)
		})
	end

	children.CameraDivider = cameraDivider

	children.ControlsHeader = Roact.createElement(CategoryHeader, {
		LayoutOrder = layoutOrderGenerator(),
		localizationKey = "CoreScripts.InGameMenu.GameSettings.ControlsAudio"
	})

	children.ShiftLock = not self.state.vrActive and Roact.createElement(AutoPropertyToggleEntry, {
		LayoutOrder = layoutOrderGenerator(),
		labelKey = "CoreScripts.InGameMenu.GameSettings.ShiftLock",
		instance = UserGameSettings,
		valueKey = "ControlMode",
		onValue = Enum.ControlMode.MouseLockSwitch,
		offValue = Enum.ControlMode.Classic,
		lockedToOff = not self.state.shiftLockEnabled
	})

	children.MovementMode = not self.state.vrActive
		and Roact.createElement(MovementModeEntry, {
			LayoutOrder = layoutOrderGenerator(),
			canOpen = self.props.canCaptureFocus,
			canCaptureFocus = self.props.canGamepadCaptureFocus
		})

	children.VolumeEntry = Roact.createElement(VolumeEntry, {
		LayoutOrder = layoutOrderGenerator(),
		buttonRef = self.volumeButton,
		canCaptureFocus = self.props.canCaptureFocus and self.props.canGamepadCaptureFocus,
		isMenuOpen = self.props.isMenuOpen
	})

	children.HapticsToggle = Roact.createElement(AutoPropertyToggleEntry, {
		LayoutOrder = layoutOrderGenerator(),
		labelKey = "Feature.Accessibility.Header.Haptics",
		instance = UserGameSettings,
		valueKey = "HapticStrength",
		onValue = 1,
		offValue = 0
	})

	children.InputDevice = v3 and Roact.createElement(DeviceSelectionEntry, {
		LayoutOrder = layoutOrderGenerator(),
		deviceType = DeviceSelectionEntry.DeviceType.Input,
		isMenuOpen = self.props.isMenuOpen,
		canOpen = self.props.canCaptureFocus,
		canCaptureFocus = self.props.canGamepadCaptureFocus
	})

	children.OutputDevice = v3 and Roact.createElement(DeviceSelectionEntry, {
		LayoutOrder = layoutOrderGenerator(),
		deviceType = DeviceSelectionEntry.DeviceType.Output,
		isMenuOpen = self.props.isMenuOpen,
		canOpen = self.props.canCaptureFocus,
		canCaptureFocus = self.props.canGamepadCaptureFocus
	})

	children.ControlsDivider = Roact.createElement(Divider, {
		LayoutOrder = layoutOrderGenerator(),
		Size = UDim2.new(1, -24, 0, 1)
	})

	children.GraphicsHeader = Roact.createElement(CategoryHeader, {
		LayoutOrder = layoutOrderGenerator(),
		localizationKey = "CoreScripts.InGameMenu.GameSettings.GraphicsTitle"
	})

	children.GraphicsQualityEntry = Roact.createElement(GraphicsQualityEntry, {
		LayoutOrder = layoutOrderGenerator(),
		canCaptureFocus = self.props.canCaptureFocus and self.props.canGamepadCaptureFocus,
		isMenuOpen = self.props.isMenuOpen
	})

	children.FullScreen = not self.state.vrActive and Roact.createElement(ToggleEntry, {
		LayoutOrder = layoutOrderGenerator(),
		labelKey = "CoreScripts.InGameMenu.GameSettings.FullScreen",
		checked = self.state.fullScreenEnabled,
		onToggled = function()
			GuiService:ToggleFullscreen()
			SendAnalytics(Constants.AnalyticsSettingsChangeName, nil, {}, true)
		end
	})

	children.GraphicsDivider = Roact.createElement(Divider, {
		LayoutOrder = layoutOrderGenerator(),
		Size = UDim2.new(1, -24, 0, 1)
	})

	children.AdvancedSettings = Roact.createElement("TextButton", {
		LayoutOrder = layoutOrderGenerator(),
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 54),
		Text = "",
		SelectionImageObject = callback(v2.Square),
		[Roact.Event.Activated] = self.props.switchToAdvancedPage
	}, {
		Text = withLocalization({
			text = "CoreScripts.InGameMenu.GameSettings.SwitchToAdvancedSettings"
		})(function(p)
			return Roact.createElement(ThemedTextLabel, {
				Text = p.text,
				TextXAlignment = Enum.TextXAlignment.Left,
				fontKey = "Body",
				themeKey = "TextDefault",
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
	})

	children.AdvancedDivider = Roact.createElement(Divider, {
		LayoutOrder = layoutOrderGenerator(),
		Size = UDim2.new(1, -24, 0, 1)
	})

	children.ShiftLockEnabledListener = Roact.createElement(ExternalEventConnection, {
		event = propertyChangedSignal,
		callback = function()
			self:setState({ shiftLockEnabled = LocalPlayer.DevEnableMouseLock })
		end
	})

	children.FullScreenListener = Roact.createElement(ExternalEventConnection, {
		event = UserGameSettings.FullscreenChanged,
		callback = function(p)
			self:setState({ fullScreenEnabled = p })

			SendAnalytics(Constants.AnalyticsInGameMenuName, Constants.AnalyticsFullscreenModeName, {
				enabled = p
			})
		end
	})

	children.CameraYInvertedListener = Roact.createElement(ExternalEventConnection, {
		event = propertyChangedSignal2,
		callback = function()
			self:setState({ invertedCameraEnabled = UserGameSettings.IsUsingCameraYInverted })
		end
	})

	children.VRActiveListener = Roact.createElement(ExternalEventConnection, {
		event = self.props.vrService:GetPropertyChangedSignal("VREnabled"),
		callback = function()
			if self.props.vrService.VREnabled then
				UserGameSettings.HasEverUsedVR = true
			end

			self:setState({ vrActive = self.props.vrService.VREnabled })
		end
	})

	children.VREnabledListener = Roact.createElement(ExternalEventConnection, {
		event = propertyChangedSignal3,
		callback = function()
			self:setState({ vrEnabled = UserGameSettings.VREnabled })
		end
	})
	return createElement(Page, v5, {
		FocusHandler = focusHandler,
		PageContents = createElement2("ScrollingFrame", v6, children)
	})
end

function extended:render()
	return v(function(p)
		return self:renderWithSelectionCursor(p)
	end)
end

function extended.didMount(object)
	spawn(function()
		local VoiceChatServiceManager = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager)
		VoiceChatServiceManager.default:asyncInit():andThen(function()
			object:setState({ voiceChatEnabled = true })
		end):catch(function() end)
	end)
end

return RoactRodux.UNSTABLE_connect2(function(data)
	local canCaptureFocus

	if data.menuPage == "GameSettings" then
		canCaptureFocus = data.isMenuOpen and not data.respawn.dialogOpen
	else
		canCaptureFocus = false
	end

	local canGamepadCaptureFocus

	if data.displayOptions.inputType == Constants.InputType.Gamepad then
		canGamepadCaptureFocus = data.currentZone == 1
	else
		canGamepadCaptureFocus = false
	end

	local currentZone

	if GetFFlagIGMGamepadSelectionHistory() then
		currentZone = data.currentZone
	end

	return {
		isMenuOpen = data.isMenuOpen,
		currentPage = data.menuPage,
		currentZone = currentZone,
		canCaptureFocus = canCaptureFocus,
		canGamepadCaptureFocus = canGamepadCaptureFocus
	}
end, function(callback)
	return {
		switchToAdvancedPage = function()
			callback(SetCurrentPage(Constants.advancedSettingsPageKey))
		end,
		switchToVRComfortSettingsPage = function()
			callback(SetCurrentPage(Constants.vrComfortSettingsPageKey))
		end
	}
end)(extended)
