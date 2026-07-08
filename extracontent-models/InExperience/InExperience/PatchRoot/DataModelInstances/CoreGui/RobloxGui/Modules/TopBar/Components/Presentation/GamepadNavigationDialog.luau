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
local _ = UIBlox.Core.Style.withStyle
local GamepadNavigationDialogShowCounter = require(script.GamepadNavigationDialogShowCounter)
local ParentParent = script.Parent.Parent
local ParentParent2 = script.Parent.Parent.Parent
local Actions = ParentParent.Parent.Actions
local SetGamepadNavigationDialogOpen = require(Actions.SetGamepadNavigationDialogOpen)
local GetFStringGamepadNavigationDialogABTestLayerName = require(ParentParent2.Flags.GetFStringGamepadNavigationDialogABTestLayerName)
local FFlagAlwaysShowGamepadNavigationDialog = require(ParentParent2.Flags.FFlagAlwaysShowGamepadNavigationDialog)
local FFlagTopBarDeprecateGamepadNavigationDialogRodux = require(ParentParent2.Flags.FFlagTopBarDeprecateGamepadNavigationDialogRodux)

local function GamepadNavigationDialogContainer(_) -- line: 31
	-- upvalues: React (copy), UserInputService (copy), GuiService (copy), GamepadNavigationDialogShowCounter (copy), FFlagAlwaysShowGamepadNavigationDialog (copy)
	local v21, v22 = React.useState(false)

	React.useEffect(function() -- line: 34
		-- upvalues: UserInputService (copy), v22 (copy), GuiService (copy)
		local u28 = nil

		local function disconnectGamepadConnected() -- line: 36
			-- upvalues: u28 (ref)
			if u28 then
				u28:Disconnect()
				u28 = nil
			end
		end

		if UserInputService:GetGamepadConnected(Enum.UserInputType.Gamepad1) then
			v22(true)
		else
			u28 = UserInputService.GamepadConnected:Connect(function() -- line: 46
				-- upvalues: v22 (copy), u28 (ref)
				v22(true)

				if u28 then
					u28:Disconnect()
					u28 = nil
				end
			end)
		end

		GuiService:GetPropertyChangedSignal("MenuIsOpen"):Connect(disconnectGamepadConnected)

		return disconnectGamepadConnected
	end, {})

	if v21 then
		return (React.createElement(GamepadNavigationDialogShowCounter, {
			selectButtonDismissesGamepadNavigationDialog = false,
			appStorageKey = "GamepadMenuVirtualCursorPromptShown",
			maxShownCount = 1,
			isGamepadNavigationDialogEnabled = FFlagAlwaysShowGamepadNavigationDialog,
			isGamepadNavigationDialogOpen = v21,
			SetGamepadNavigationDialogOpen = v22
		}))
	end

	return nil
end

local v18 = GetFStringGamepadNavigationDialogABTestLayerName()
local v19 = RoactAppExperiment.connectUserLayer({ v18 }, function(p2, _) -- line: 72
	-- upvalues: v18 (copy), FFlagAlwaysShowGamepadNavigationDialog (copy)
	local v25 = p2[v18] or {}

	return {
		appStorageKey = "GamepadMenuVirtualCursorPromptShown",
		maxShownCount = 1,
		isGamepadNavigationDialogEnabled = FFlagAlwaysShowGamepadNavigationDialog or v25.isGamepadNavigationDialogEnabled,
		selectButtonDismissesGamepadNavigationDialog = v25.selectButtonDismissesGamepadNavigationDialog
	}
end)(GamepadNavigationDialogShowCounter)

if FFlagTopBarDeprecateGamepadNavigationDialogRodux then
	return GamepadNavigationDialogContainer
end

return RoactRodux.connect(function(p4) -- line: 87
	return {
		isGamepadNavigationDialogOpen = p4.displayOptions.isGamepadNavigationDialogOpen
	}
end, function(p5) -- line: 91
	-- upvalues: SetGamepadNavigationDialogOpen (copy)
	return {
		SetGamepadNavigationDialogOpen = function(p6) -- line: 93
			-- upvalues: p5 (copy), SetGamepadNavigationDialogOpen (copy)
			return p5(SetGamepadNavigationDialogOpen(p6))
		end
	}
end)(v19)
