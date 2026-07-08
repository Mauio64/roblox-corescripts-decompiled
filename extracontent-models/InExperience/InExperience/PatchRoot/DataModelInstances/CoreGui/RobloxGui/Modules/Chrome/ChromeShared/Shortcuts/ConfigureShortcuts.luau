local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local CorePackages = game:GetService("CorePackages")
local GamepadService = game:GetService("GamepadService")
local GameSettings = UserSettings().GameSettings
local Chrome = script:FindFirstAncestor("Chrome")
local ChromeShared = script:FindFirstAncestor("ChromeShared")
local FocusSelectExpChat = require(ChromeShared.Utility.FocusSelectExpChat)
local Service = require(ChromeShared.Service)
local GuiService = game:GetService("GuiService")
local Constants = require(ChromeShared.Unibar.Constants)
local RespawnUtils = require(Chrome.Integrations.RespawnUtils)
local FocusUtils = require(CorePackages.Workspace.Packages.Chrome).FocusUtils
local v13 = require(CorePackages.Workspace.Packages.ExpChat).Stores.GetFocusNavigationStore(false)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local FFlagChromeShortcutAddRespawnLeaveToIEM = SharedFlags.FFlagChromeShortcutAddRespawnLeaveToIEM
local FFlagChromeShortcutRemoveLeaveOnRespawnPage = SharedFlags.FFlagChromeShortcutRemoveLeaveOnRespawnPage
local FFlagChromeShortcutRemoveRespawnOnLeavePage = SharedFlags.FFlagChromeShortcutRemoveRespawnOnLeavePage
local FFlagConsoleChatUseChromeFocusUtils = SharedFlags.FFlagConsoleChatUseChromeFocusUtils
local FFlagChromeShortcutChatOpenKeyboard = SharedFlags.FFlagChromeShortcutChatOpenKeyboard
local FFlagAddSwitchTabHintsToIEM = SharedFlags.FFlagAddSwitchTabHintsToIEM
local Flags = Chrome.Flags
local FFlagRespawnChromeShortcutTelemetry = require(Flags.FFlagRespawnChromeShortcutTelemetry)
local FFlagLeaveActionChromeShortcutTelemetry = require(Flags.FFlagLeaveActionChromeShortcutTelemetry)
local FFlagLeaveChromeShortcutTelemetry = require(Flags.FFlagLeaveChromeShortcutTelemetry)
local FFlagRespawnActionChromeShortcutTelemetry = require(Flags.FFlagRespawnActionChromeShortcutTelemetry)
local Flags2 = require(ChromeShared.Flags)
local FFlagRemoveLeaveShortcutFromLeaveConfirm = Flags2.FFlagRemoveLeaveShortcutFromLeaveConfirm
local FFlagRemoveRespawnShortcutFromRespawnConfirmation = Flags2.FFlagRemoveRespawnShortcutFromRespawnConfirmation
local v30 = if not FFlagEnableConsoleExpControls then nil else require(RobloxGui.Modules.ChatSelector)
local leaveGame = require(RobloxGui.Modules.Settings.leaveGame)
local FFlagShowUnibarOnVirtualCursor = SharedFlags.FFlagShowUnibarOnVirtualCursor
local t4 = {
	keyCode = Enum.KeyCode.ButtonX,
	activated = function() -- line: 45
		-- upvalues: RobloxGui (copy), FFlagLeaveActionChromeShortcutTelemetry (copy), leaveGame (copy), FFlagLeaveChromeShortcutTelemetry (copy), FFlagConsoleChatUseChromeFocusUtils (copy), v13 (copy), FFlagRespawnChromeShortcutTelemetry (copy)
		local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)
		local LeaveGamePage = SettingsHub.Instance.LeaveGamePage

		local function switchToLeavePage() -- line: 48
			-- upvalues: SettingsHub (copy), LeaveGamePage (copy)
			local t1 = {
				used_shortcut = true
			}

			SettingsHub.Instance:SwitchToPage(LeaveGamePage, true, nil, nil, nil, t1)
		end

		if SettingsHub:GetVisibility() then
			if LeaveGamePage == SettingsHub.Instance.Pages.CurrentPage then
				if FFlagLeaveActionChromeShortcutTelemetry then
					leaveGame(true, {
						telemetryFields = {
							used_shortcut = true
						}
					})

					return
				end

				leaveGame(true)

				return
			end

			if FFlagLeaveChromeShortcutTelemetry then
				local t2 = {
					used_shortcut = true
				}

				SettingsHub.Instance:SwitchToPage(LeaveGamePage, true, nil, nil, nil, t2)

				return
			end

			SettingsHub:SwitchToPage(LeaveGamePage, true)

			return
		end

		if FFlagConsoleChatUseChromeFocusUtils and v13.getChatInputBarFocused(false) then
			v13.unfocusChatInputBar()
		end

		if FFlagRespawnChromeShortcutTelemetry then
			SettingsHub:SetVisibility(true)

			local t3 = {
				used_shortcut = true
			}

			SettingsHub.Instance:SwitchToPage(LeaveGamePage, true, nil, nil, nil, t3)

			return
		end

		SettingsHub:SetVisibility(true, false, LeaveGamePage)
	end
}
local t5 = {
	integration = "respawn",
	keyCode = Enum.KeyCode.ButtonY,
	activated = function() -- line: 92
		-- upvalues: RobloxGui (copy), FFlagRespawnActionChromeShortcutTelemetry (copy), FFlagConsoleChatUseChromeFocusUtils (copy), v13 (copy), FFlagRespawnChromeShortcutTelemetry (copy), RespawnUtils (copy), Service (copy)
		local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)

		if SettingsHub:GetVisibility() and SettingsHub.Instance.Pages.CurrentPage == SettingsHub.Instance.ResetCharacterPage then
			if FFlagRespawnActionChromeShortcutTelemetry then
				SettingsHub.Instance.ResetCharacterPage.ResetFunction({
					resetTelemetryFields = {
						used_shortcut = true
					}
				})

				return
			end

			SettingsHub.Instance.ResetCharacterPage.ResetFunction()

			return
		end

		if FFlagConsoleChatUseChromeFocusUtils and v13.getChatInputBarFocused(false) then
			v13.unfocusChatInputBar()
		end

		if FFlagRespawnChromeShortcutTelemetry then
			RespawnUtils.respawnPage({
				usedShortcut = true
			})

			return
		end

		Service:activate("respawn")
	end
}

local function activateBack() -- line: 124
	-- upvalues: FFlagEnableConsoleExpControls (copy), FocusUtils (copy), FFlagConsoleChatUseChromeFocusUtils (copy), Service (copy), RobloxGui (copy), GuiService (copy), v13 (copy)
	local v42 = FFlagEnableConsoleExpControls and FocusUtils.MenuIconSelectedSignal:get()
	local v43 = not FFlagConsoleChatUseChromeFocusUtils or Service:inFocusNav():get()
	local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)

	if SettingsHub:GetVisibility() then
		SettingsHub.Instance:PopMenu(false, true)

		if not SettingsHub:GetVisibility() then
			Service:selectMenuIcon()
		end

		return Enum.ContextActionResult.Sink
	end

	if v43 or v42 then
		local v45 = Service:currentSubMenu():get()

		if v45 then
			Service:toggleSubMenu(v45)
			Service:setSelected(v45)
		else
			Service:disableFocusNav()
			Service:setShortcutBar(nil)
			GuiService.SelectedCoreObject = nil

			if FFlagEnableConsoleExpControls then
				FocusUtils.MenuIconSelectedSignal:set(false)
			end
		end

		return Enum.ContextActionResult.Sink
	end

	if FFlagConsoleChatUseChromeFocusUtils and v13.getChatInputBarFocused(false) then
		FocusUtils.FocusOnChrome(function() -- line: 149
			-- upvalues: v13 (copy)
			v13.unfocusChatInputBar()
		end, "chat")

		return Enum.ContextActionResult.Sink
	end
end

function registerShortcuts() -- line: 157
	-- upvalues: Service (copy), t4 (copy), t5 (copy), FFlagChromeShortcutAddRespawnLeaveToIEM (copy), FFlagChromeShortcutChatOpenKeyboard (copy), FFlagEnableConsoleExpControls (copy), v30 (copy), FFlagConsoleChatUseChromeFocusUtils (copy), v13 (copy), FocusUtils (copy), GameSettings (copy), FocusSelectExpChat (copy), RobloxGui (copy), activateBack (copy), FFlagRemoveLeaveShortcutFromLeaveConfirm (copy), FFlagRemoveRespawnShortcutFromRespawnConfirmation (copy), GuiService (copy), GamepadService (copy)
	Service:registerShortcut({
		id = "leave",
		label = "CoreScripts.TopBar.Leave",
		integration = nil,
		actionName = "UnibarGamepadLeaveGame",
		keyCode = t4.keyCode,
		activated = t4.activated
	})
	Service:registerShortcut({
		id = "respawn",
		label = "CoreScripts.InGameMenu.QuickActions.Respawn",
		actionName = "UnibarGamepadRespawn",
		keyCode = t5.keyCode,
		integration = t5.integration,
		activated = t5.activated
	})

	if FFlagChromeShortcutAddRespawnLeaveToIEM then
		Service:registerShortcut({
			id = "leave_in_experience_menu",
			label = nil,
			integration = nil,
			actionName = "IEMGamepadLeaveGame",
			keyCode = t4.keyCode,
			activated = t4.activated
		})
		Service:registerShortcut({
			id = "respawn_in_experience_menu",
			label = nil,
			actionName = "IEMGamepadRespawn",
			keyCode = t5.keyCode,
			integration = t5.integration,
			activated = t5.activated
		})
	end

	Service:registerShortcut({
		id = "chat",
		label = "CoreScripts.TopBar.Chat",
		integration = "chat",
		actionName = "UnibarGamepadChat",
		keyCode = if not FFlagChromeShortcutChatOpenKeyboard then Enum.KeyCode.ButtonR1 else Enum.KeyCode.ButtonL2,
		activated = if not FFlagEnableConsoleExpControls then nil else function() -- line: 203
			-- upvalues: v30 (copy), FFlagChromeShortcutChatOpenKeyboard (copy), FFlagConsoleChatUseChromeFocusUtils (copy), v13 (copy), FocusUtils (copy), GameSettings (copy), FocusSelectExpChat (copy)
			local Visibility = v30:GetVisibility()

			if FFlagChromeShortcutChatOpenKeyboard then
				if FFlagConsoleChatUseChromeFocusUtils and v13.getChatInputBarFocused(false) then
					FocusUtils.FocusOnChrome(function() -- line: 210
						-- upvalues: v13 (copy)
						v13.unfocusChatInputBar()
					end, "chat")
					v30:SetVisible(false)
					GameSettings.ChatVisible = false

					return
				end

				v30:SetVisible(true)
				GameSettings.ChatVisible = true
				v30:FocusChatBar()
				FocusSelectExpChat("chat")

				return
			end

			v30:SetVisible(not Visibility)

			if not Visibility then
				FocusSelectExpChat("chat")

				return
			end

			if FFlagConsoleChatUseChromeFocusUtils and v13.getChatInputBarFocused(false) then
				FocusUtils.FocusOnChrome(function() -- line: 229
					-- upvalues: v13 (copy)
					v13.unfocusChatInputBar()
				end, "chat")
			end
		end
	})
	Service:registerShortcut({
		id = "tiltMenu",
		label = "CoreScripts.TopBar.Menu",
		integration = nil,
		actionName = "UnibarGamepadMenu",
		keyCode = Enum.KeyCode.ButtonR2,
		activated = function() -- line: 245
			-- upvalues: RobloxGui (copy), FFlagConsoleChatUseChromeFocusUtils (copy), v13 (copy)
			local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)

			if SettingsHub:GetVisibility() then
				SettingsHub:SetVisibility(false)

				return
			end

			if FFlagConsoleChatUseChromeFocusUtils and v13.getChatInputBarFocused(false) then
				v13.unfocusChatInputBar()
			end

			SettingsHub:SetVisibility(true)
		end
	})
	Service:registerShortcut({
		id = "back",
		label = "CoreScripts.TopBar.Back",
		integration = nil,
		actionName = "UnibarGamepadBack",
		keyCode = Enum.KeyCode.ButtonB,
		displayPriority = if not FFlagEnableConsoleExpControls then nil else -10,
		activated = activateBack
	})

	if FFlagRemoveLeaveShortcutFromLeaveConfirm or FFlagRemoveRespawnShortcutFromRespawnConfirmation then
		Service:registerShortcut({
			id = "back-invisible",
			label = nil,
			actionName = "UnibarGamepadBackInvisible",
			keyCode = Enum.KeyCode.ButtonB,
			activated = activateBack
		})
	end

	Service:registerShortcut({
		id = "close",
		label = nil,
		actionName = "UnibarGamepadClose",
		keyCode = Enum.KeyCode.ButtonStart,
		activated = function() -- line: 287
			-- upvalues: RobloxGui (copy), Service (copy), GuiService (copy)
			require(RobloxGui.Modules.Settings.SettingsHub):SetVisibility(false)
			Service:disableFocusNav()
			Service:setShortcutBar(nil)
			GuiService.SelectedCoreObject = nil
		end
	})
	Service:registerShortcut({
		id = "virtualCursor",
		label = nil,
		actionName = "VirtualCursorShortcut",
		keyCode = Enum.KeyCode.ButtonSelect,
		activated = function() -- line: 303
			-- upvalues: Service (copy), GuiService (copy), GamepadService (copy)
			Service:disableFocusNav()
			Service:setShortcutBar(nil)
			GuiService.SelectedCoreObject = nil
			GamepadService.GamepadCursorEnabled = true
		end
	})
	Service:registerShortcut({
		id = "tiltMenuPreviousTab",
		label = "CoreScripts.InGameMenu.Controls.PreviousTab",
		integration = nil,
		actionName = nil,
		activated = nil,
		keyCode = Enum.KeyCode.ButtonL1
	})
	Service:registerShortcut({
		id = "tiltMenuNextTab",
		label = "CoreScripts.InGameMenu.Controls.NextTab",
		integration = nil,
		actionName = nil,
		activated = nil,
		keyCode = Enum.KeyCode.ButtonR1
	})
end
function configureShortcutBars() -- line: 333
	-- upvalues: Service (copy), Constants (copy), FFlagShowUnibarOnVirtualCursor (copy), FFlagAddSwitchTabHintsToIEM (copy), FFlagChromeShortcutAddRespawnLeaveToIEM (copy), FFlagChromeShortcutRemoveRespawnOnLeavePage (copy), FFlagChromeShortcutRemoveLeaveOnRespawnPage (copy), FFlagRemoveLeaveShortcutFromLeaveConfirm (copy), FFlagRemoveRespawnShortcutFromRespawnConfirmation (copy)
	Service:configureShortcutBar(Constants.UNIBAR_SHORTCUTBAR_ID, if not FFlagShowUnibarOnVirtualCursor then {
		"leave",
		"respawn",
		"chat",
		"tiltMenu",
		"back"
	} else {
		"leave",
		"respawn",
		"chat",
		"tiltMenu",
		"back",
		"virtualCursor"
	})
	Service:configureShortcutBar(Constants.TILTMENU_SHORTCUTBAR_ID, if not FFlagAddSwitchTabHintsToIEM then if not FFlagChromeShortcutAddRespawnLeaveToIEM then {
		"tiltMenuPreviousTab",
		"tiltMenuNextTab",
		"back",
		"close"
	} else {
		"leave_in_experience_menu",
		"respawn_in_experience_menu",
		"tiltMenuPreviousTab",
		"tiltMenuNextTab",
		"back",
		"close"
	} else {
		"leave_in_experience_menu",
		"respawn_in_experience_menu",
		"back-invisible",
		"close"
	})

	if not FFlagChromeShortcutRemoveRespawnOnLeavePage or not FFlagChromeShortcutRemoveLeaveOnRespawnPage then
		Service:configureShortcutBar(Constants.TILTMENU_DIALOG_SHORTCUTBAR_ID, {
			"leave",
			"respawn",
			"back",
			"close"
		})
	end

	if FFlagRemoveLeaveShortcutFromLeaveConfirm then
		Service:configureShortcutBar(Constants.TILTMENU_LEAVE_DIALOG_SHORTCUTBAR_ID, {
			"back-invisible",
			"close"
		})
	elseif FFlagChromeShortcutRemoveRespawnOnLeavePage then
		Service:configureShortcutBar(Constants.TILTMENU_LEAVE_DIALOG_SHORTCUTBAR_ID, {
			"leave",
			"back",
			"close"
		})
	end

	if FFlagRemoveRespawnShortcutFromRespawnConfirmation then
		Service:configureShortcutBar(Constants.TILTMENU_RESPAWN_DIALOG_SHORTCUTBAR_ID, {
			"back-invisible",
			"close"
		})

		return
	end

	if FFlagChromeShortcutRemoveLeaveOnRespawnPage then
		Service:configureShortcutBar(Constants.TILTMENU_RESPAWN_DIALOG_SHORTCUTBAR_ID, {
			"respawn",
			"back",
			"close"
		})
	end
end

return function() -- line: 391
	registerShortcuts()
	configureShortcutBars()
end
