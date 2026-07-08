local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local PropertyChangedSignal = UserGameSettings:GetPropertyChangedSignal("ComputerCameraMovementMode")
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
	[Enum.ComputerCameraMovementMode.Classic] = "CoreScripts.InGameMenu.GameSettings.CameraModeClassic",
	[Enum.ComputerCameraMovementMode.Follow] = "CoreScripts.InGameMenu.GameSettings.CameraModeFollow",
	[Enum.ComputerCameraMovementMode.Default] = "CoreScripts.InGameMenu.GameSettings.Default",
	[Enum.ComputerCameraMovementMode.CameraToggle] = "CoreScripts.InGameMenu.GameSettings.CameraModeCameraToggle"
}
local v22 = Roact.PureComponent:extend("CameraModeEntry")

v22.validateProps = t.strictInterface({
	LayoutOrder = t.integer,
	canOpen = t.optional(t.boolean),
	canCaptureFocus = t.optional(t.boolean),
	ButtonRef = t.optional(t.union(t.callback, t.table))
})
v22.defaultProps = {
	canOpen = true
}

function v22.init(p1) -- line: 52
	-- upvalues: UserGameSettings (copy), v8 (copy), LocalPlayer (copy)
	p1:setState({
		selectedComputerMode = UserGameSettings.ComputerCameraMovementMode,
		computerOptions = v8 and v8:GetRegisteredComputerCameraMovementModes() or {},
		developerComputerMode = LocalPlayer.DevComputerCameraMode
	})
end
function v22.render(p2) -- line: 60
	-- upvalues: Roact (copy), ExternalEventConnection (copy), PropertyChangedSignal (copy), UserGameSettings (copy), v8 (copy), PropertyChangedSignal2 (copy), LocalPlayer (copy), t1 (copy), InputLabel (copy), withLocalization (copy), DropDownSelection (copy), SendAnalytics (copy), Constants (copy), DeveloperLockLabel (copy)
	local t2 = {
		ComputerCameraMovementModeListener = Roact.createElement(ExternalEventConnection, {
			event = PropertyChangedSignal,
			callback = function() -- line: 66
				-- upvalues: p2 (copy), UserGameSettings (copy)
				p2:setState({
					selectedComputerMode = UserGameSettings.ComputerCameraMovementMode
				})
			end
		}),
		ComputerCameraMovementModeRegisteredListener = v8 and Roact.createElement(ExternalEventConnection, {
			event = v8.ComputerCameraMovementModeRegistered,
			callback = function() -- line: 75
				-- upvalues: p2 (copy), v8 (copy)
				p2:setState({
					computerOptions = v8:GetRegisteredComputerCameraMovementModes()
				})
			end
		}),
		LocalPlayerComputerMovementMode = Roact.createElement(ExternalEventConnection, {
			event = PropertyChangedSignal2,
			callback = function() -- line: 83
				-- upvalues: p2 (copy), LocalPlayer (copy)
				p2:setState({
					developerComputerMode = LocalPlayer.DevComputerCameraMode
				})
			end
		})
	}

	if #p2.state.computerOptions == 0 then
		return Roact.createFragment(t2)
	end

	local v26 = p2.state.developerComputerMode ~= Enum.DevComputerCameraMovementMode.UserChoice
	local t3 = {}
	local n1 = 0

	if not v26 then
		for i, v in ipairs(p2.state.computerOptions) do
			t3[i] = t1[v]
			assert(t3[i] ~= nil, "Camera movement mode " .. v.Name .. " has no localization key")

			if p2.state.selectedComputerMode.Value == v.Value then
				n1 = i
			end
		end
	end

	t2.CameraModeEntrySelector = Roact.createElement("Frame", {
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
			localizationKey = "CoreScripts.InGameMenu.GameSettings.CameraMode",
			Size = UDim2.new(1, 0, 0, 56),
			Position = UDim2.new(0, 0, 0, 0),
			AnchorPoint = Vector2.new(0, 0)
		}),
		Dropdown = withLocalization({
			placeholder = v26 and t1[p2.state.developerComputerMode] or nil
		})(function(_) -- line: 128
			-- upvalues: Roact (copy), DropDownSelection (copy), t3 (copy), n1 (ref), p2 (copy), v26 (copy), UserGameSettings (copy), SendAnalytics (copy), Constants (copy)
			return Roact.createElement(DropDownSelection, {
				localize = true,
				selectionParentName = "cameraModeDropdown",
				Size = UDim2.new(1, 0, 0, 44),
				Position = UDim2.new(0, 0, 0, 56),
				selections = t3,
				selectedIndex = n1,
				placeHolderText = p2.state.developerComputerMode.Name,
				enabled = not v26,
				selectionChanged = function(p4) -- line: 137
					-- upvalues: UserGameSettings (copy), p2 (copy), SendAnalytics (copy), Constants (copy)
					UserGameSettings.ComputerCameraMovementMode = p2.state.computerOptions[p4]
					SendAnalytics(Constants.AnalyticsSettingsChangeName, nil, {}, true)
				end,
				canOpen = p2.props.canOpen,
				canCaptureFocus = p2.props.canCaptureFocus,
				ButtonRef = p2.props.ButtonRef
			})
		end),
		LockedLabel = v26 and Roact.createElement(DeveloperLockLabel, {
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, 0),
			Size = UDim2.new(1, -72, 0.25, 0)
		})
	})

	return Roact.createFragment(t2)
end

return v22
