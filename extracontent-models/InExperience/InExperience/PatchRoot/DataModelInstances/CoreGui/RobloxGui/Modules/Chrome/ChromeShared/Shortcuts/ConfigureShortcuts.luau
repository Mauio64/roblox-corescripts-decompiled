local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local CorePackages = game:GetService("CorePackages")
local GamepadService = game:GetService("GamepadService")
local gameSettings = UserSettings().GameSettings

local Chrome = script:FindFirstAncestor("Chrome")
local ChromeShared = script:FindFirstAncestor("ChromeShared")
local FocusSelectExpChat = require(ChromeShared.Utility.FocusSelectExpChat)
local Service = require(ChromeShared.Service)
local GuiService = game:GetService("GuiService")
local Constants = require(ChromeShared.Unibar.Constants)
local RespawnUtils = require(Chrome.Integrations.RespawnUtils)
local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local FocusUtils = Chrome2.FocusUtils

local ExpChat = require(CorePackages.Workspace.Packages.ExpChat)
local focusNavigationStore = ExpChat.Stores.GetFocusNavigationStore(false)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local FFlagChromeShortcutAddRespawnLeaveToIEM = SharedFlags.FFlagChromeShortcutAddRespawnLeaveToIEM
local FFlagChromeShortcutRemoveLeaveOnRespawnPage = SharedFlags.FFlagChromeShortcutRemoveLeaveOnRespawnPage
local FFlagChromeShortcutRemoveRespawnOnLeavePage = SharedFlags.FFlagChromeShortcutRemoveRespawnOnLeavePage
local FFlagConsoleChatUseChromeFocusUtils = SharedFlags.FFlagConsoleChatUseChromeFocusUtils
local FFlagChromeShortcutChatOpenKeyboard = SharedFlags.FFlagChromeShortcutChatOpenKeyboard
local FFlagAddSwitchTabHintsToIEM = SharedFlags.FFlagAddSwitchTabHintsToIEM
local isSideSheetEnabled = require(CorePackages.Workspace.Packages.InExperienceSideSheetUtils.isSideSheetEnabled)
local FFlagSideSheetFocusNav = SharedFlags.FFlagSideSheetFocusNav

local Flags = Chrome.Flags
local FFlagRespawnChromeShortcutTelemetry = require(Flags.FFlagRespawnChromeShortcutTelemetry)
local FFlagLeaveActionChromeShortcutTelemetry = require(Flags.FFlagLeaveActionChromeShortcutTelemetry)
local FFlagLeaveChromeShortcutTelemetry = require(Flags.FFlagLeaveChromeShortcutTelemetry)
local FFlagRespawnActionChromeShortcutTelemetry = require(Flags.FFlagRespawnActionChromeShortcutTelemetry)
local Flags2 = require(ChromeShared.Flags)
local FFlagRemoveLeaveShortcutFromLeaveConfirm = Flags2.FFlagRemoveLeaveShortcutFromLeaveConfirm

local FFlagRemoveRespawnShortcutFromRespawnConfirmation = Flags2.FFlagRemoveRespawnShortcutFromRespawnConfirmation
local ChatSelector

if FFlagEnableConsoleExpControls then
	ChatSelector = require(RobloxGui.Modules.ChatSelector)
else
	ChatSelector = nil
end

local leaveGame = require(RobloxGui.Modules.Settings.leaveGame)
local PioneerUtils = require(CorePackages.Workspace.Packages.PioneerUtils)
local FFlagPioneerLeaveLogsOut = SharedFlags.FFlagPioneerLeaveLogsOut

local InExperienceSideSheet = require(CorePackages.Workspace.Packages.InExperienceSideSheet)
local getSideSheetVisibility = InExperienceSideSheet.getSideSheetVisibility
local toggleSideSheet = InExperienceSideSheet.toggleSideSheet

local FFlagShowUnibarOnVirtualCursor = SharedFlags.FFlagShowUnibarOnVirtualCursor

local v = {
	keyCode = Enum.KeyCode.ButtonX,
	activated = function()
		local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)
		local leaveGamePage = SettingsHub.Instance.LeaveGamePage
		local function switchToLeavePage() -- 2 equivalent calls inferred from this helper
			SettingsHub.Instance:SwitchToPage(leaveGamePage, true, nil, nil, nil, {
				used_shortcut = true
			})
		end

		if SettingsHub:GetVisibility() then
			if SettingsHub.Instance.Pages.CurrentPage == leaveGamePage then
				if FFlagPioneerLeaveLogsOut and PioneerUtils.isPioneerLaunch() then
					leaveGame(false, {
						leaveReason = PioneerUtils.PioneerLeaveReason.Logout,
						inhibitAppRating = true,
						telemetryFields = FFlagLeaveActionChromeShortcutTelemetry and {
							used_shortcut = true
						} or nil
					})
				elseif FFlagLeaveActionChromeShortcutTelemetry then
					leaveGame(true, {
						telemetryFields = { used_shortcut = true }
					})
				else
					leaveGame(true)
				end
			elseif FFlagLeaveChromeShortcutTelemetry then
				switchToLeavePage() -- inferred equivalent call
			else
				SettingsHub:SwitchToPage(leaveGamePage, true)
			end
		else
			if FFlagConsoleChatUseChromeFocusUtils and focusNavigationStore.getChatInputBarFocused(false) then
				focusNavigationStore.unfocusChatInputBar()
			end

			if not FFlagRespawnChromeShortcutTelemetry then
				SettingsHub:SetVisibility(true, false, leaveGamePage)

				return
			end

			SettingsHub:SetVisibility(true)
			switchToLeavePage() -- inferred equivalent call
		end
	end
}

local v2 = {
	keyCode = Enum.KeyCode.ButtonY,
	integration = "respawn",
	activated = function()
		local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)

		if
			SettingsHub:GetVisibility()
			and SettingsHub.Instance.Pages.CurrentPage == SettingsHub.Instance.ResetCharacterPage
		then
			if FFlagRespawnActionChromeShortcutTelemetry then
				SettingsHub.Instance.ResetCharacterPage.ResetFunction({
					resetTelemetryFields = { used_shortcut = true }
				})
			else
				SettingsHub.Instance.ResetCharacterPage.ResetFunction()
			end
		else
			if FFlagConsoleChatUseChromeFocusUtils and focusNavigationStore.getChatInputBarFocused(false) then
				focusNavigationStore.unfocusChatInputBar()
			end

			if FFlagRespawnChromeShortcutTelemetry then
				RespawnUtils.respawnPage({ usedShortcut = true })
			else
				Service:activate("respawn")
			end
		end
	end
}

local function activateBack()
	local v3 = FFlagEnableConsoleExpControls and FocusUtils.MenuIconSelectedSignal:get()
	local v4 = not FFlagConsoleChatUseChromeFocusUtils or Service:inFocusNav():get()
	local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)

	if SettingsHub:GetVisibility() then
		SettingsHub.Instance:PopMenu(false, true)

		if not SettingsHub:GetVisibility() then
			Service:selectMenuIcon()
		end

		return Enum.ContextActionResult.Sink
	elseif v4 or v3 then
		local v5 = Service:currentSubMenu():get()

		if v5 then
			Service:toggleSubMenu(v5)
			Service:setSelected(v5)
		else
			Service:disableFocusNav()
			Service:setShortcutBar(nil)
			GuiService.SelectedCoreObject = nil

			if FFlagEnableConsoleExpControls then
				FocusUtils.MenuIconSelectedSignal:set(false)
			end
		end

		return Enum.ContextActionResult.Sink
	elseif FFlagConsoleChatUseChromeFocusUtils and focusNavigationStore.getChatInputBarFocused(false) then
		FocusUtils.FocusOnChrome(function()
			focusNavigationStore.unfocusChatInputBar()
		end, "chat")
		return Enum.ContextActionResult.Sink
	end
end

function registerShortcuts()
	Service:registerShortcut({
		id = "leave",
		label = "CoreScripts.TopBar.Leave",
		keyCode = v.keyCode,
		integration = nil,
		actionName = "UnibarGamepadLeaveGame",
		activated = v.activated
	})

	Service:registerShortcut({
		id = "respawn",
		label = "CoreScripts.InGameMenu.QuickActions.Respawn",
		keyCode = v2.keyCode,
		integration = v2.integration,
		actionName = "UnibarGamepadRespawn",
		activated = v2.activated
	})

	if FFlagChromeShortcutAddRespawnLeaveToIEM then
		Service:registerShortcut({
			id = "leave_in_experience_menu",
			label = nil,
			keyCode = v.keyCode,
			integration = nil,
			actionName = "IEMGamepadLeaveGame",
			activated = v.activated
		})

		Service:registerShortcut({
			id = "respawn_in_experience_menu",
			label = nil,
			keyCode = v2.keyCode,
			integration = v2.integration,
			actionName = "IEMGamepadRespawn",
			activated = v2.activated
		})
	end

	local keyCode

	if FFlagChromeShortcutChatOpenKeyboard then
		keyCode = Enum.KeyCode.ButtonL2
	else
		keyCode = Enum.KeyCode.ButtonR1
	end

	Service:registerShortcut({
		id = "chat",
		label = "CoreScripts.TopBar.Chat",
		keyCode = keyCode,
		integration = "chat",
		actionName = "UnibarGamepadChat",
		activated = FFlagEnableConsoleExpControls and function()
			local visibility = ChatSelector:GetVisibility()

			if FFlagChromeShortcutChatOpenKeyboard then
				if FFlagConsoleChatUseChromeFocusUtils and focusNavigationStore.getChatInputBarFocused(false) then
					FocusUtils.FocusOnChrome(function()
						focusNavigationStore.unfocusChatInputBar()
					end, "chat")
					ChatSelector:SetVisible(false)
					gameSettings.ChatVisible = false
				else
					ChatSelector:SetVisible(true)
					gameSettings.ChatVisible = true
					ChatSelector:FocusChatBar()
					FocusSelectExpChat("chat")
				end
			else
				ChatSelector:SetVisible(not visibility)

				if not visibility then
					FocusSelectExpChat("chat")
				elseif FFlagConsoleChatUseChromeFocusUtils and focusNavigationStore.getChatInputBarFocused(false) then
					FocusUtils.FocusOnChrome(function()
						focusNavigationStore.unfocusChatInputBar()
					end, "chat")
				end
			end
		end or nil
	})

	Service:registerShortcut({
		id = "tiltMenu",
		label = "CoreScripts.TopBar.Menu",
		keyCode = Enum.KeyCode.ButtonR2,
		integration = nil,
		actionName = "UnibarGamepadMenu",
		activated = function()
			local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)

			if SettingsHub:GetVisibility() then
				SettingsHub:SetVisibility(false)
				return
			end

			if FFlagConsoleChatUseChromeFocusUtils and focusNavigationStore.getChatInputBarFocused(false) then
				focusNavigationStore.unfocusChatInputBar()
			end

			if isSideSheetEnabled and FFlagSideSheetFocusNav then
				if not getSideSheetVisibility() then
					toggleSideSheet(true)
				end
			else
				SettingsHub:SetVisibility(true)
			end
		end
	})

	Service:registerShortcut({
		id = "back",
		label = "CoreScripts.TopBar.Back",
		keyCode = Enum.KeyCode.ButtonB,
		displayPriority = FFlagEnableConsoleExpControls and -10 or nil,
		integration = nil,
		actionName = "UnibarGamepadBack",
		activated = activateBack
	})

	if FFlagRemoveLeaveShortcutFromLeaveConfirm or FFlagRemoveRespawnShortcutFromRespawnConfirmation then
		Service:registerShortcut({
			id = "back-invisible",
			label = nil,
			keyCode = Enum.KeyCode.ButtonB,
			actionName = "UnibarGamepadBackInvisible",
			activated = activateBack
		})
	end

	Service:registerShortcut({
		id = "close",
		label = nil,
		keyCode = Enum.KeyCode.ButtonStart,
		actionName = "UnibarGamepadClose",
		activated = function()
			local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)
			SettingsHub:SetVisibility(false)
			Service:disableFocusNav()
			Service:setShortcutBar(nil)
			GuiService.SelectedCoreObject = nil
		end
	})

	Service:registerShortcut({
		id = "virtualCursor",
		label = nil,
		keyCode = Enum.KeyCode.ButtonSelect,
		actionName = "VirtualCursorShortcut",
		activated = function()
			Service:disableFocusNav()
			Service:setShortcutBar(nil)
			GuiService.SelectedCoreObject = nil
			GamepadService.GamepadCursorEnabled = true
		end
	})

	Service:registerShortcut({
		id = "tiltMenuPreviousTab",
		label = "CoreScripts.InGameMenu.Controls.PreviousTab",
		keyCode = Enum.KeyCode.ButtonL1,
		integration = nil,
		actionName = nil,
		activated = nil
	})

	Service:registerShortcut({
		id = "tiltMenuNextTab",
		label = "CoreScripts.InGameMenu.Controls.NextTab",
		keyCode = Enum.KeyCode.ButtonR1,
		integration = nil,
		actionName = nil,
		activated = nil
	})
end

function configureShortcutBars()
	Service:configureShortcutBar(
		Constants.UNIBAR_SHORTCUTBAR_ID,
		FFlagShowUnibarOnVirtualCursor and {
			"leave",
			"respawn",
			"chat",
			"tiltMenu",
			"back",
			"virtualCursor"
		} or { "leave", "respawn", "chat", "tiltMenu", "back" }
	)

	Service:configureShortcutBar(
		Constants.TILTMENU_SHORTCUTBAR_ID,
		FFlagAddSwitchTabHintsToIEM and {
			"leave_in_experience_menu",
			"respawn_in_experience_menu",
			"back-invisible",
			"close"
		} or FFlagChromeShortcutAddRespawnLeaveToIEM and {
			"leave_in_experience_menu",
			"respawn_in_experience_menu",
			"tiltMenuPreviousTab",
			"tiltMenuNextTab",
			"back",
			"close"
		} or { "tiltMenuPreviousTab", "tiltMenuNextTab", "back", "close" }
	)

	if not (FFlagChromeShortcutRemoveRespawnOnLeavePage and FFlagChromeShortcutRemoveLeaveOnRespawnPage) then
		Service:configureShortcutBar(Constants.TILTMENU_DIALOG_SHORTCUTBAR_ID, {
			"leave",
			"respawn",
			"back",
			"close"
		})
	end

	if FFlagRemoveLeaveShortcutFromLeaveConfirm then
		Service:configureShortcutBar(Constants.TILTMENU_LEAVE_DIALOG_SHORTCUTBAR_ID, { "back-invisible", "close" })
	elseif FFlagChromeShortcutRemoveRespawnOnLeavePage then
		Service:configureShortcutBar(Constants.TILTMENU_LEAVE_DIALOG_SHORTCUTBAR_ID, { "leave", "back", "close" })
	end

	if FFlagRemoveRespawnShortcutFromRespawnConfirmation then
		Service:configureShortcutBar(Constants.TILTMENU_RESPAWN_DIALOG_SHORTCUTBAR_ID, { "back-invisible", "close" })
	elseif FFlagChromeShortcutRemoveLeaveOnRespawnPage then
		Service:configureShortcutBar(Constants.TILTMENU_RESPAWN_DIALOG_SHORTCUTBAR_ID, { "respawn", "back", "close" })
	end
end

return function()
	registerShortcuts()
	configureShortcutBars()
end
