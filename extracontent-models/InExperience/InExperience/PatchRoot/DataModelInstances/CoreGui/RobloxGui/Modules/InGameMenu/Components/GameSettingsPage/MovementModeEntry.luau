local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local PropertyChangedSignal = UserGameSettings:GetPropertyChangedSignal("ComputerMovementMode")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local CoreUtility = require(RobloxGui.Modules.CoreUtility)
local LocalPlayer = Players.LocalPlayer
local v8 = CoreUtility.waitForChildOfClass(LocalPlayer, "PlayerScripts")
local PropertyChangedSignal2 = LocalPlayer:GetPropertyChangedSignal("DevComputerMovementMode")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local ParentParent = script.Parent.Parent.Parent
local DropDownSelection = require(ParentParent.Components.DropDownSelection)
local ExternalEventConnection = require(ParentParent.Utility.ExternalEventConnection)
local InputLabel = require(script.Parent.InputLabel)
local DeveloperLockLabel = require(script.Parent.DeveloperLockLabel)
local withLocalization = require(ParentParent.Localization.withLocalization)
local SendAnalytics = require(ParentParent.Utility.SendAnalytics)
local Constants = require(ParentParent.Resources.Constants)
local t1 = {
	[Enum.ComputerMovementMode.KeyboardMouse] = "CoreScripts.InGameMenu.GameSettings.ComputerMoveModeKeyboardMouse",
	[Enum.ComputerMovementMode.ClickToMove] = "CoreScripts.InGameMenu.GameSettings.ComputerMoveModeClickToMove",
	[Enum.ComputerMovementMode.Default] = "CoreScripts.InGameMenu.GameSettings.Default"
}
local t2 = {
	[Enum.DevComputerMovementMode.KeyboardMouse] = "CoreScripts.InGameMenu.GameSettings.ComputerMoveModeKeyboardMouse",
	[Enum.DevComputerMovementMode.ClickToMove] = "CoreScripts.InGameMenu.GameSettings.ComputerMoveModeClickToMove"
}
local v23 = Roact.PureComponent:extend("MovementModeEntry")

v23.validateProps = t.strictInterface({
	LayoutOrder = t.integer,
	canOpen = t.optional(t.boolean),
	canCaptureFocus = t.optional(t.boolean)
})
v23.defaultProps = {
	canOpen = true
}

function v23.init(p1) -- line: 55
	-- upvalues: UserGameSettings (copy), v8 (copy), LocalPlayer (copy)
	p1:setState({
		selectedComputerMode = UserGameSettings.ComputerMovementMode,
		computerOptions = v8 and v8:GetRegisteredComputerMovementModes() or {},
		developerComputerMode = LocalPlayer.DevComputerMovementMode
	})
end
function v23.render(p2) -- line: 63
	-- upvalues: Roact (copy), ExternalEventConnection (copy), PropertyChangedSignal (copy), UserGameSettings (copy), v8 (copy), PropertyChangedSignal2 (copy), LocalPlayer (copy), t1 (copy), InputLabel (copy), withLocalization (copy), t2 (copy), DropDownSelection (copy), SendAnalytics (copy), Constants (copy), DeveloperLockLabel (copy)
	local t3 = {
		ComputerMovementModeListener = Roact.createElement(ExternalEventConnection, {
			event = PropertyChangedSignal,
			callback = function() -- line: 69
				-- upvalues: p2 (copy), UserGameSettings (copy)
				p2:setState({
					selectedComputerMode = UserGameSettings.ComputerMovementMode
				})
			end
		}),
		ComputerMovementModeRegisteredListener = v8 and Roact.createElement(ExternalEventConnection, {
			event = v8.ComputerMovementModeRegistered,
			callback = function() -- line: 77
				-- upvalues: p2 (copy), v8 (copy)
				p2:setState({
					computerOptions = v8:GetRegisteredComputerMovementModes()
				})
			end
		}),
		DevComputerMovementMode = Roact.createElement(ExternalEventConnection, {
			event = PropertyChangedSignal2,
			callback = function() -- line: 85
				-- upvalues: p2 (copy), LocalPlayer (copy)
				p2:setState({
					developerComputerMode = LocalPlayer.DevComputerMovementMode
				})
			end
		})
	}

	if #p2.state.computerOptions == 0 then
		return Roact.createFragment(t3)
	end

	local v27 = p2.state.developerComputerMode ~= Enum.DevComputerMovementMode.UserChoice
	local t4 = {}
	local n1 = 0

	if not v27 then
		for i, v in ipairs(p2.state.computerOptions) do
			t4[i] = t1[v]
			assert(t4[i] ~= nil, "Movement mode " .. v.Name .. " has no localization key")

			if p2.state.selectedComputerMode.Value == v.Value then
				n1 = i
			end
		end
	end

	t3.MovementModeEntrySelector = Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		ZIndex = 2,
		Size = UDim2.new(1, 0, 0, 120),
		LayoutOrder = p2.props.LayoutOrder
	}, {
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
		Dropdown = withLocalization({
			placeholder = v27 and t2[p2.state.developerComputerMode] or nil
		})(function(p3) -- line: 130
			-- upvalues: Roact (copy), DropDownSelection (copy), t4 (copy), n1 (ref), v27 (copy), p2 (copy), UserGameSettings (copy), SendAnalytics (copy), Constants (copy)
			return Roact.createElement(DropDownSelection, {
				localize = true,
				selectionParentName = "MovementModeEntryDropdown",
				Size = UDim2.new(1, 0, 0, 44),
				Position = UDim2.new(0, 0, 0, 56),
				selections = t4,
				selectedIndex = n1,
				placeHolderText = p3.placeholder,
				enabled = not v27,
				canOpen = p2.props.canOpen,
				canCaptureFocus = p2.props.canCaptureFocus,
				selectionChanged = function(p4) -- line: 142
					-- upvalues: UserGameSettings (copy), p2 (copy), SendAnalytics (copy), Constants (copy)
					UserGameSettings.ComputerMovementMode = p2.state.computerOptions[p4]
					SendAnalytics(Constants.AnalyticsSettingsChangeName, nil, {}, true)
				end
			})
		end),
		LockedLabel = v27 and Roact.createElement(DeveloperLockLabel, {
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, 0),
			Size = UDim2.new(1, -72, 0.25, 0)
		})
	})

	return Roact.createFragment(t3)
end

return v23
