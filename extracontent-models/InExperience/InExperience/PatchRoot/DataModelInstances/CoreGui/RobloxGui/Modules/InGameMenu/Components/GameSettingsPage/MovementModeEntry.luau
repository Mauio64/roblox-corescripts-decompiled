local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local UserGameSettings = UserSettings():GetService("UserGameSettings")

local propertyChangedSignal = UserGameSettings:GetPropertyChangedSignal("ComputerMovementMode")

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
	[Enum.ComputerMovementMode.KeyboardMouse] = "CoreScripts.InGameMenu.GameSettings.ComputerMoveModeKeyboardMouse",
	[Enum.ComputerMovementMode.ClickToMove] = "CoreScripts.InGameMenu.GameSettings.ComputerMoveModeClickToMove",
	[Enum.ComputerMovementMode.Default] = "CoreScripts.InGameMenu.GameSettings.Default"
}

local v3 = {
	[Enum.DevComputerMovementMode.KeyboardMouse] = "CoreScripts.InGameMenu.GameSettings.ComputerMoveModeKeyboardMouse",
	[Enum.DevComputerMovementMode.ClickToMove] = "CoreScripts.InGameMenu.GameSettings.ComputerMoveModeClickToMove"
}

local extended = Roact.PureComponent:extend("MovementModeEntry")
extended.validateProps = t.strictInterface({
	LayoutOrder = t.integer,
	canOpen = t.optional(t.boolean),
	canCaptureFocus = t.optional(t.boolean)
})

extended.defaultProps = { canOpen = true }

function extended.init(object)
	object:setState({
		selectedComputerMode = UserGameSettings.ComputerMovementMode,
		computerOptions = v and v:GetRegisteredComputerMovementModes() or {},
		developerComputerMode = LocalPlayer.DevComputerMovementMode
	})
end

function extended.render(object)
	local v4 = {
		ComputerMovementModeListener = Roact.createElement(ExternalEventConnection, {
			event = propertyChangedSignal,
			callback = function()
				object:setState({ selectedComputerMode = UserGameSettings.ComputerMovementMode })
			end
		}),
		ComputerMovementModeRegisteredListener = v and Roact.createElement(ExternalEventConnection, {
			event = v.ComputerMovementModeRegistered,
			callback = function()
				object:setState({
					computerOptions = v:GetRegisteredComputerMovementModes()
				})
			end
		}),
		DevComputerMovementMode = Roact.createElement(ExternalEventConnection, {
			event = propertyChangedSignal2,
			callback = function()
				object:setState({ developerComputerMode = LocalPlayer.DevComputerMovementMode })
			end
		})
	}

	if #object.state.computerOptions == 0 then
		return Roact.createFragment(v4)
	end

	local v5 = object.state.developerComputerMode ~= Enum.DevComputerMovementMode.UserChoice
	local selections = {}
	local selectedIndex = 0

	if not v5 then
		for i, computerOption in ipairs(object.state.computerOptions) do
			selections[i] = v2[computerOption]
			assert(selections[i] ~= nil, "Movement mode " .. computerOption.Name .. " has no localization key")

			if object.state.selectedComputerMode.Value == computerOption.Value then
				selectedIndex = i
			end
		end
	end

	local createElement = Roact.createElement
	local v6 = {
		Size = UDim2.new(1, 0, 0, 120),
		BackgroundTransparency = 1,
		LayoutOrder = object.props.LayoutOrder,
		ZIndex = 2
	}

	local v7 = {
		Padding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 24),
			PaddingRight = UDim.new(0, 24)
		}),
		InputLabel = Roact.createElement(InputLabel, {
			localizationKey = "CoreScripts.InGameMenu.GameSettings.MovementMode",
			Size = UDim2.new(1, 0, 0, 56),
			Position = UDim2.new(0, 0, 0, 0),
			AnchorPoint = Vector2.new(0, 0)
		}),
		Dropdown = 0,
		LockedLabel = 0
	}
	local placeholder

	if v5 then
		placeholder = v3[object.state.developerComputerMode] or nil
	end

	v7.Dropdown = withLocalization({ placeholder = placeholder })(function(p)
		return Roact.createElement(DropDownSelection, {
			Size = UDim2.new(1, 0, 0, 44),
			Position = UDim2.new(0, 0, 0, 56),
			selections = selections,
			selectedIndex = selectedIndex,
			placeHolderText = p.placeholder,
			enabled = not v5,
			localize = true,
			selectionParentName = "MovementModeEntryDropdown",
			canOpen = object.props.canOpen,
			canCaptureFocus = object.props.canCaptureFocus,
			selectionChanged = function(p2)
				UserGameSettings.ComputerMovementMode = object.state.computerOptions[p2]
				SendAnalytics(Constants.AnalyticsSettingsChangeName, nil, {}, true)
			end
		})
	end)

	v7.LockedLabel = v5
		and Roact.createElement(DeveloperLockLabel, {
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, 0),
			Size = UDim2.new(1, -72, 0.25, 0)
		})
	v4.MovementModeEntrySelector = createElement("Frame", v6, v7)

	return Roact.createFragment(v4)
end

return extended
