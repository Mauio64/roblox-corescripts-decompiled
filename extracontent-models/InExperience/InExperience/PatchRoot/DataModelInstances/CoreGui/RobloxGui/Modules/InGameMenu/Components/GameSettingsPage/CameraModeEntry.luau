local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local UserGameSettings = UserSettings():GetService("UserGameSettings")

local propertyChangedSignal = UserGameSettings:GetPropertyChangedSignal("ComputerCameraMovementMode")

local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local CoreUtility = require(RobloxGui.Modules.CoreUtility)

local LocalPlayer = Players.LocalPlayer
local v = CoreUtility.waitForChildOfClass(LocalPlayer, "PlayerScripts")
local propertyChangedSignal2 = LocalPlayer:GetPropertyChangedSignal("DevComputerMovementMode")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t

local parent = script.Parent.Parent.Parent

local DropDownSelection = require(parent.Components.DropDownSelection)
local ExternalEventConnection = require(parent.Utility.ExternalEventConnection)

local InputLabel = require(script.Parent.InputLabel)
local DeveloperLockLabel = require(script.Parent.DeveloperLockLabel)

local withLocalization = require(parent.Localization.withLocalization)

local SendAnalytics = require(parent.Utility.SendAnalytics)
local Constants = require(parent.Resources.Constants)

local v2 = {
	[Enum.ComputerCameraMovementMode.Classic] = "CoreScripts.InGameMenu.GameSettings.CameraModeClassic",
	[Enum.ComputerCameraMovementMode.Follow] = "CoreScripts.InGameMenu.GameSettings.CameraModeFollow",
	[Enum.ComputerCameraMovementMode.Default] = "CoreScripts.InGameMenu.GameSettings.Default",
	[Enum.ComputerCameraMovementMode.CameraToggle] = "CoreScripts.InGameMenu.GameSettings.CameraModeCameraToggle"
}

local extended = Roact.PureComponent:extend("CameraModeEntry")
extended.validateProps = t.strictInterface({
	LayoutOrder = t.integer,
	canOpen = t.optional(t.boolean),
	canCaptureFocus = t.optional(t.boolean),
	ButtonRef = t.optional(t.union(t.callback, t.table))
})

extended.defaultProps = { canOpen = true }

function extended.init(object)
	object:setState({
		selectedComputerMode = UserGameSettings.ComputerCameraMovementMode,
		computerOptions = v and v:GetRegisteredComputerCameraMovementModes() or {},
		developerComputerMode = LocalPlayer.DevComputerCameraMode
	})
end

function extended.render(object)
	local v3 = {
		ComputerCameraMovementModeListener = Roact.createElement(ExternalEventConnection, {
			event = propertyChangedSignal,
			callback = function()
				object:setState({
					selectedComputerMode = UserGameSettings.ComputerCameraMovementMode
				})
			end
		}),
		ComputerCameraMovementModeRegisteredListener = v and Roact.createElement(ExternalEventConnection, {
			event = v.ComputerCameraMovementModeRegistered,
			callback = function()
				object:setState({
					computerOptions = v:GetRegisteredComputerCameraMovementModes()
				})
			end
		}),
		LocalPlayerComputerMovementMode = Roact.createElement(ExternalEventConnection, {
			event = propertyChangedSignal2,
			callback = function()
				object:setState({ developerComputerMode = LocalPlayer.DevComputerCameraMode })
			end
		})
	}

	if #object.state.computerOptions == 0 then
		return Roact.createFragment(v3)
	end

	local v4 = object.state.developerComputerMode ~= Enum.DevComputerCameraMovementMode.UserChoice
	local selections = {}
	local selectedIndex = 0

	if not v4 then
		for i, computerOption in ipairs(object.state.computerOptions) do
			selections[i] = v2[computerOption]
			assert(selections[i] ~= nil, "Camera movement mode " .. computerOption.Name .. " has no localization key")

			if object.state.selectedComputerMode.Value == computerOption.Value then
				selectedIndex = i
			end
		end
	end

	local createElement = Roact.createElement
	local v5 = {
		Size = UDim2.new(1, 0, 0, 120),
		BackgroundTransparency = 1,
		LayoutOrder = object.props.LayoutOrder,
		ZIndex = 2
	}

	local v6 = {
		Padding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 24),
			PaddingRight = UDim.new(0, 24)
		}),
		InputLabel = Roact.createElement(InputLabel, {
			localizationKey = "CoreScripts.InGameMenu.GameSettings.CameraMode",
			Size = UDim2.new(1, 0, 0, 56),
			Position = UDim2.new(0, 0, 0, 0),
			AnchorPoint = Vector2.new(0, 0)
		}),
		Dropdown = 0,
		LockedLabel = 0
	}
	local placeholder

	if v4 then
		placeholder = v2[object.state.developerComputerMode] or nil
	end

	v6.Dropdown = withLocalization({ placeholder = placeholder })(function(_)
		return Roact.createElement(DropDownSelection, {
			Size = UDim2.new(1, 0, 0, 44),
			Position = UDim2.new(0, 0, 0, 56),
			selections = selections,
			selectedIndex = selectedIndex,
			placeHolderText = object.state.developerComputerMode.Name,
			enabled = not v4,
			localize = true,
			selectionChanged = function(p)
				UserGameSettings.ComputerCameraMovementMode = object.state.computerOptions[p]
				SendAnalytics(Constants.AnalyticsSettingsChangeName, nil, {}, true)
			end,
			selectionParentName = "cameraModeDropdown",
			canOpen = object.props.canOpen,
			canCaptureFocus = object.props.canCaptureFocus,
			ButtonRef = object.props.ButtonRef
		})
	end)

	v6.LockedLabel = v4
		and Roact.createElement(DeveloperLockLabel, {
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, 0),
			Size = UDim2.new(1, -72, 0.25, 0)
		})
	v3.CameraModeEntrySelector = createElement("Frame", v5, v6)

	return Roact.createFragment(v3)
end

return extended
