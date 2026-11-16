local UserInputService = game:GetService("UserInputService")
local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")

local parent = InExperienceSideSheet.Parent

local Signals = require(parent.Signals)

local Responsive = require(parent.Responsive)
local GetInputModeStore = Responsive.GetInputModeStore
local Input = Responsive.Input

local Foundation = require(parent.Foundation)
local IconName = Foundation.Enums.IconName

local Enums = require(InExperienceSideSheet.Common.Enums)
local Constants = require(InExperienceSideSheet.Common.Constants)
require(InExperienceSideSheet.Common.Types)

local PioneerUtils = require(parent.PioneerUtils)
local isPioneerLaunch = PioneerUtils.isPioneerLaunch

local SwitchServer = require(parent.SwitchServer)
local GetSwitchServerStore = SwitchServer.GetSwitchServerStore

local GetActionBindingsStore = require(InExperienceSideSheet.Stores.GetActionBindingsStore)

local ButtonWidth = Enums.ButtonWidth

local v = {
	["rbxasset://textures/ui/Controls/DefaultController/ButtonX@2x.png"] = IconName.XboxX,
	["rbxasset://textures/ui/Controls/DefaultController/ButtonY@2x.png"] = IconName.XboxY,
	["rbxasset://textures/ui/Controls/XboxController/ButtonX@2x.png"] = IconName.XboxX,
	["rbxasset://textures/ui/Controls/XboxController/ButtonY@2x.png"] = IconName.XboxY,
	["rbxasset://textures/ui/Controls/PlayStationController/ButtonSquare@2x.png"] = IconName.PsSquare,
	["rbxasset://textures/ui/Controls/PlayStationController/ButtonTriangle@2x.png"] = IconName.PsTriagle
}

local function getIsSwitchServerButtonHidden(p): boolean
	return not GetSwitchServerStore(p).shouldEnableSwitchServer(p)
end

local function createRespawnButtonConfig(sessionActionBindings, signal, setShortcutIcon)
	return {
		name = "RespawnButton",
		label = "CoreScripts.InGameMenu.QuickActions.Respawn",
		keyboardIcon = IconName.SquareTextR,
		gamepadKeyCode = Enum.KeyCode.ButtonY,
		getShortcutIcon = signal,
		setShortcutIcon = setShortcutIcon,
		getOnActivated = sessionActionBindings[Enums.ActionBinding.Respawn].getOnActivated,
		getIsEnabled = sessionActionBindings[Enums.ActionBinding.Respawn].getIsEnabled,
		width = ButtonWidth.Full
	}
end

local function createLeaveButtonConfig(sessionActionBindings, signal, setShortcutIcon, pioneerLaunch: boolean)
	local leaveButtonConfig = {
		name = "LeaveButton",
		label = not pioneerLaunch and "CoreScripts.InGameMenu.LeaveGame" or Constants.LocalizationKeys.QuitButton,
		keyboardIcon = IconName.SquareTextL,
		gamepadKeyCode = Enum.KeyCode.ButtonX,
		getShortcutIcon = signal,
		setShortcutIcon = setShortcutIcon,
		getOnActivated = sessionActionBindings[Enums.ActionBinding.Leave].getOnActivated,
		getIsEnabled = sessionActionBindings[Enums.ActionBinding.Leave].getIsEnabled,
		width = 0
	}
	local width

	if pioneerLaunch then
		width = ButtonWidth.Half
	else
		width = ButtonWidth.Full
	end

	leaveButtonConfig.width = width
	return leaveButtonConfig
end

local function createSwitchServerButtonConfig(sessionActionBindings) -- 1 equivalent call inferred from this helper
	return {
		name = Constants.SessionActionButtonNames.SwitchServer,
		label = "CoreScripts.InGameMenu.PeoplePage.SwitchServer",
		getOnActivated = sessionActionBindings[Enums.ActionBinding.SwitchServer].getOnActivated,
		getIsEnabled = sessionActionBindings[Enums.ActionBinding.SwitchServer].getIsEnabled,
		getIsHidden = getIsSwitchServerButtonHidden,
		width = ButtonWidth.Half
	}
end

local function createSessionActionButtonsStore()
	local sessionActionBindings = GetActionBindingsStore().sessionActionBindings
	local pioneerLaunch = isPioneerLaunch()

	local signal, setShortcutIcon = Signals.createSignal(nil)
	local signal2, setShortcutIcon2 = Signals.createSignal(nil)

	local sessionActionButtonConfigs = { createRespawnButtonConfig(sessionActionBindings, signal2, setShortcutIcon2) }

	if pioneerLaunch then
		table.insert(sessionActionButtonConfigs, createSwitchServerButtonConfig(sessionActionBindings)) -- inferred equivalent call
	end

	table.insert(
		sessionActionButtonConfigs,
		createLeaveButtonConfig(sessionActionBindings, signal, setShortcutIcon, pioneerLaunch)
	)

	local gamepadConnectedConnection = nil
	local effect = Signals.createEffect(function(p)
		local lastInputType = GetInputModeStore(p).getLastInputType(p)

		if gamepadConnectedConnection then
			gamepadConnectedConnection:Disconnect()
		end

		if lastInputType == Input.Directional then
			local function setGamepadIcons()
				for _, v2 in sessionActionButtonConfigs do
					if not (v2.setShortcutIcon and v2.gamepadKeyCode) then
						continue
					end

					local imageForKeyCode = UserInputService:GetImageForKeyCode(v2.gamepadKeyCode)
					v2.setShortcutIcon(v[imageForKeyCode])
				end
			end

			gamepadConnectedConnection = UserInputService.GamepadConnected:Connect(function(_)
				setGamepadIcons()
			end)

			setGamepadIcons()
		elseif lastInputType == Input.Pointer then
			for _, v2 in sessionActionButtonConfigs do
				if v2.keyboardIcon and v2.setShortcutIcon then
					v2.setShortcutIcon(v2.keyboardIcon)
				end
			end
		else
			for _, v2 in sessionActionButtonConfigs do
				if v2.setShortcutIcon then
					v2.setShortcutIcon(nil)
				end
			end
		end
	end)

	local function cleanUp()
		if gamepadConnectedConnection then
			gamepadConnectedConnection:Disconnect()
		end

		if effect then
			effect()
		end
	end

	return { sessionActionButtonConfigs = sessionActionButtonConfigs, cleanUp = cleanUp }
end

return createSessionActionButtonsStore
