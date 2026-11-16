local CorePackages = game:GetService("CorePackages")
game:GetService("AppStorageService")
game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local React = require(CorePackages.Packages.React)

require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)

local withStyle = UIBlox.Core.Style.withStyle
local GamepadNavigationDialogShowCounter = require(script.GamepadNavigationDialogShowCounter)

local parent = script.Parent.Parent
local parent2 = script.Parent.Parent.Parent
local actions = parent.Parent.Actions
local SetGamepadNavigationDialogOpen = require(actions.SetGamepadNavigationDialogOpen)

local GetFStringGamepadNavigationDialogABTestLayerName = require(parent2.Flags.GetFStringGamepadNavigationDialogABTestLayerName)

local FFlagAlwaysShowGamepadNavigationDialog = require(parent2.Flags.FFlagAlwaysShowGamepadNavigationDialog)

local FFlagTopBarDeprecateGamepadNavigationDialogRodux = require(parent2.Flags.FFlagTopBarDeprecateGamepadNavigationDialogRodux)

local function GamepadNavigationDialogContainer(_)
	local state, setState = React.useState(false)

	React.useEffect(function()
		local gamepadConnectedConnection = nil
		local function disconnectGamepadConnected() -- 1 equivalent call inferred from this helper
			if gamepadConnectedConnection then
				gamepadConnectedConnection:Disconnect()
				gamepadConnectedConnection = nil
			end
		end

		if UserInputService:GetGamepadConnected(Enum.UserInputType.Gamepad1) then
			setState(true)
		else
			gamepadConnectedConnection = UserInputService.GamepadConnected:Connect(function()
				setState(true)
				disconnectGamepadConnected() -- inferred equivalent call
			end)
		end

		GuiService:GetPropertyChangedSignal("MenuIsOpen"):Connect(disconnectGamepadConnected)

		return disconnectGamepadConnected
	end, {})

	if state then
		return (React.createElement(GamepadNavigationDialogShowCounter, {
			isGamepadNavigationDialogEnabled = FFlagAlwaysShowGamepadNavigationDialog,
			selectButtonDismissesGamepadNavigationDialog = false,
			appStorageKey = "GamepadMenuVirtualCursorPromptShown",
			maxShownCount = 1,
			isGamepadNavigationDialogOpen = state,
			SetGamepadNavigationDialogOpen = setState
		}))
	end

	return nil
end

local fStringGamepadNavigationDialogABTestLayerName = GetFStringGamepadNavigationDialogABTestLayerName()
local v = RoactAppExperiment.connectUserLayer({ fStringGamepadNavigationDialogABTestLayerName }, function(p, _)
	local v = p[fStringGamepadNavigationDialogABTestLayerName] or {}
	return {
		isGamepadNavigationDialogEnabled = FFlagAlwaysShowGamepadNavigationDialog or v.isGamepadNavigationDialogEnabled,
		selectButtonDismissesGamepadNavigationDialog = v.selectButtonDismissesGamepadNavigationDialog,
		appStorageKey = "GamepadMenuVirtualCursorPromptShown",
		maxShownCount = 1
	}
end)(GamepadNavigationDialogShowCounter)

if FFlagTopBarDeprecateGamepadNavigationDialogRodux then
	return GamepadNavigationDialogContainer
end

return RoactRodux.connect(function(p)
	return { isGamepadNavigationDialogOpen = p.displayOptions.isGamepadNavigationDialogOpen }
end, function(callback)
	return {
		SetGamepadNavigationDialogOpen = function(p)
			return callback(SetGamepadNavigationDialogOpen(p))
		end
	}
end)(v)
