local UserInputService = game:GetService("UserInputService")
local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")
local InExperienceSideSheetParent = InExperienceSideSheet.Parent
local Signals = require(InExperienceSideSheetParent.Signals)
local Responsive = require(InExperienceSideSheetParent.Responsive)
local GetInputModeStore = Responsive.GetInputModeStore
local Input = Responsive.Input
local IconName = require(InExperienceSideSheetParent.Foundation).Enums.IconName
local Enums = require(InExperienceSideSheet.Common.Enums)
local Constants = require(InExperienceSideSheet.Common.Constants)
local FFlagDebugEnablePioneerUX = require(InExperienceSideSheetParent.SharedFlags).FFlagDebugEnablePioneerUX
local GetActionBindingsStore = require(InExperienceSideSheet.Stores.GetActionBindingsStore)
local t1 = {
	["rbxasset://textures/ui/Controls/DefaultController/ButtonX@2x.png"] = IconName.XboxX,
	["rbxasset://textures/ui/Controls/DefaultController/ButtonY@2x.png"] = IconName.XboxY,
	["rbxasset://textures/ui/Controls/XboxController/ButtonX@2x.png"] = IconName.XboxX,
	["rbxasset://textures/ui/Controls/XboxController/ButtonY@2x.png"] = IconName.XboxY,
	["rbxasset://textures/ui/Controls/PlayStationController/ButtonSquare@2x.png"] = IconName.PsSquare,
	["rbxasset://textures/ui/Controls/PlayStationController/ButtonTriangle@2x.png"] = IconName.PsTriagle
}

local function createSessionActionButtonsStore() -- line: 49
	-- upvalues: GetActionBindingsStore (copy), Signals (copy), FFlagDebugEnablePioneerUX (copy), Constants (copy), Enums (copy), GetInputModeStore (copy), Input (copy), UserInputService (copy), t1 (copy)
	local sessionActionBindings = GetActionBindingsStore().sessionActionBindings
	local v16, v17 = Signals.createSignal(nil)
	local v18, v19 = Signals.createSignal(nil)
	local t2 = {
		{
			name = "LeaveButton",
			keyboardIcon = "icons/controls/keys/key_l",
			isEmphasis = true,
			label = not FFlagDebugEnablePioneerUX and "CoreScripts.InGameMenu.LeaveGame" or Constants.LocalizationKeys.LogoutButton,
			gamepadKeyCode = Enum.KeyCode.ButtonX,
			getShortcutIcon = v16,
			setShortcutIcon = v17,
			getOnActivated = sessionActionBindings[Enums.ActionBinding.Leave].getOnActivated,
			getIsEnabled = sessionActionBindings[Enums.ActionBinding.Leave].getIsEnabled
		},
		{
			name = "RespawnButton",
			label = "CoreScripts.InGameMenu.QuickActions.Respawn",
			keyboardIcon = "icons/controls/keys/key_r",
			isEmphasis = false,
			gamepadKeyCode = Enum.KeyCode.ButtonY,
			getShortcutIcon = v18,
			setShortcutIcon = v19,
			getOnActivated = sessionActionBindings[Enums.ActionBinding.Respawn].getOnActivated,
			getIsEnabled = sessionActionBindings[Enums.ActionBinding.Respawn].getIsEnabled
		}
	}
	local connection = nil
	local v22 = Signals.createEffect(function(p1) -- line: 84
		-- upvalues: GetInputModeStore (copy), connection (ref), Input (copy), t2 (copy), UserInputService (copy), t1 (copy)
		local v24 = GetInputModeStore(p1).getLastInputType(p1)

		if connection then
			connection:Disconnect()
		end

		if v24 == Input.Directional then
			local function setGamepadIcons() -- line: 92
				-- upvalues: t2 (copy), UserInputService (copy), t1 (copy)
				for _, v31 in t2 do
					local ImageForKeyCode = UserInputService:GetImageForKeyCode(v31.gamepadKeyCode)

					v31.setShortcutIcon(t1[ImageForKeyCode])
				end
			end

			connection = UserInputService.GamepadConnected:Connect(function(_) -- line: 101
				-- upvalues: setGamepadIcons (copy)
				setGamepadIcons()
			end)
			setGamepadIcons()

			return
		end

		if v24 == Input.Pointer then
			for _, v27 in t2 do
				v27.setShortcutIcon(v27.keyboardIcon)
			end

			return
		end

		for _, v29 in t2 do
			v29.setShortcutIcon(nil)
		end
	end)

	return {
		sessionActionButtonConfigs = t2,
		cleanUp = function() -- line: 117
			-- upvalues: connection (ref), v22 (copy)
			if connection then
				connection:Disconnect()
			end

			if v22 then
				v22()
			end
		end
	}
end

return createSessionActionButtonsStore
