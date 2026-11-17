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
local SharedFlags = require(parent.SharedFlags)
local FFlagPioneerLeaveLogsOut = SharedFlags.FFlagPioneerLeaveLogsOut
local getPioneerLeaveCopy = require(InExperienceSideSheet.Common.getPioneerLeaveCopy)

local SwitchServer = require(parent.SwitchServer)
local GetSwitchServerStore = SwitchServer.GetSwitchServerStore

local GetActionBindingsStore = require(InExperienceSideSheet.Stores.GetActionBindingsStore)
local Flags = require(InExperienceSideSheet.Flags)
local FFlagPioneerLogoutButtonLabel = Flags.FFlagPioneerLogoutButtonLabel
local Flags2 = require(InExperienceSideSheet.Flags)
local FFlagSideSheetEmphasizeLeave = Flags2.FFlagSideSheetEmphasizeLeave

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
		width = ButtonWidth.Full,
		testId = FFlagSideSheetEmphasizeLeave and "--in-experience-side-sheet-button-respawn" or nil
	}
end

local function createLeaveButtonConfig(sessionActionBindings, signal, setShortcutIcon, pioneerLaunch: boolean, fFlagSideSheetEmphasizeLeave: boolean)
	local label

	if FFlagPioneerLogoutButtonLabel then
		label = getPioneerLeaveCopy.getPioneerLeaveButtonKey(pioneerLaunch)
	else
		label = (not pioneerLaunch or FFlagPioneerLeaveLogsOut) and "CoreScripts.InGameMenu.LeaveGame"
			or Constants.LocalizationKeys.QuitButton
	end

	local leaveButtonConfig = {
		name = "LeaveButton",
		label = label,
		keyboardIcon = IconName.SquareTextL,
		gamepadKeyCode = Enum.KeyCode.ButtonX,
		getShortcutIcon = signal,
		setShortcutIcon = setShortcutIcon,
		getOnActivated = sessionActionBindings[Enums.ActionBinding.Leave].getOnActivated,
		getIsEnabled = sessionActionBindings[Enums.ActionBinding.Leave].getIsEnabled,
		width = 0,
		isEmphasized = 0,
		testId = 0
	}
	local width

	if pioneerLaunch then
		width = ButtonWidth.Half
	else
		width = ButtonWidth.Full
	end

	leaveButtonConfig.width = width
	leaveButtonConfig.isEmphasized = fFlagSideSheetEmphasizeLeave
	leaveButtonConfig.testId = FFlagSideSheetEmphasizeLeave and "--in-experience-side-sheet-button-leave" or nil
	return leaveButtonConfig
end

local function createSwitchServerButtonConfig(sessionActionBindings)
	return {
		name = Constants.SessionActionButtonNames.SwitchServer,
		label = "CoreScripts.InGameMenu.PeoplePage.SwitchServer",
		getOnActivated = sessionActionBindings[Enums.ActionBinding.SwitchServer].getOnActivated,
		getIsEnabled = sessionActionBindings[Enums.ActionBinding.SwitchServer].getIsEnabled,
		getIsHidden = getIsSwitchServerButtonHidden,
		width = ButtonWidth.Half,
		testId = FFlagSideSheetEmphasizeLeave and "--in-experience-side-sheet-button-switch-server" or nil
	}
end

local function createSessionActionButtonsStore()
	local sessionActionBindings = GetActionBindingsStore().sessionActionBindings
	local pioneerLaunch = isPioneerLaunch()

	local signal, setShortcutIcon = Signals.createSignal(nil)
	local signal2, setShortcutIcon2 = Signals.createSignal(nil)

	local leaveButtonConfig = createLeaveButtonConfig(
		sessionActionBindings,
		signal,
		setShortcutIcon,
		pioneerLaunch,
		FFlagSideSheetEmphasizeLeave
	)

	local respawnButtonConfig = createRespawnButtonConfig(sessionActionBindings, signal2, setShortcutIcon2)

	local sessionActionButtonConfigs = {}

	if FFlagSideSheetEmphasizeLeave then
		table.insert(sessionActionButtonConfigs, leaveButtonConfig)
	else
		table.insert(sessionActionButtonConfigs, respawnButtonConfig)
	end

	if pioneerLaunch then
		table.insert(sessionActionButtonConfigs, createSwitchServerButtonConfig(sessionActionBindings))
	end

	if FFlagSideSheetEmphasizeLeave then
		table.insert(sessionActionButtonConfigs, respawnButtonConfig)
	else
		table.insert(sessionActionButtonConfigs, leaveButtonConfig)
	end

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
