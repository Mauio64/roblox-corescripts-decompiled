local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Utility = require(RobloxGui.Modules.Settings.Utility)
local Constants = require(RobloxGui.Modules:WaitForChild("InGameMenu"):WaitForChild("Resources"):WaitForChild("Constants"))
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)

require(CorePackages.Packages.Signals)

local SignalsReact = require(CorePackages.Packages.SignalsReact)
local CoreScriptsRoactCommon = require(CorePackages.Workspace.Packages.CoreScriptsRoactCommon)
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local MenuButton = require(script.Parent.MenuButton)
local useSignalState = SignalsReact.useSignalState
local useLastInput = Responsive.useLastInput
local Traversal = CoreScriptsRoactCommon.Traversal
local View = Foundation.View
local FIntRelocateMobileMenuButtonsVariant = require(RobloxGui.Modules.Settings.Flags.FIntRelocateMobileMenuButtonsVariant)
local FFlagAddTraversalHistoryReactMenuButtons = require(RobloxGui.Modules.Settings.Flags.FFlagAddTraversalHistoryReactMenuButtons)
local FFlagGamepadIconSupportCheck = require(CorePackages.Workspace.Packages.SharedFlags).FFlagGamepadIconSupportCheck
local FFlagFixTraversalHistoryMenuFixesV3 = Traversal.Flags.FFlagFixTraversalHistoryMenuFixesV3
local v23 = game:DefineFastFlag("MenuButtonsDisconnectGamepadConnected", false)
local v24 = game:DefineFastFlag("MenuButtonsUseGreyResumeButton", false)
local FFlagIEMFocusNavSupportNewButtons = require(RobloxGui.Modules.Settings.Flags.FFlagIEMFocusNavSupportNewButtons)

local function createMenuButtons(t1: {[any]: any}, s1: string, b1: boolean) -- line: 40
	-- upvalues: React (copy), View (copy), FFlagIEMFocusNavSupportNewButtons (copy), MenuButton (copy), FFlagGamepadIconSupportCheck (copy), FFlagAddTraversalHistoryReactMenuButtons (copy)
	local t2 = {}

	for i = 1, #t1 do
		t2["MenuButtonContainer" .. i] = React.createElement(View, {
			tag = "fill row align-y-center",
			LayoutOrder = i,
			SelectionGroup = not not FFlagIEMFocusNavSupportNewButtons or nil
		}, {
			MenuButton = React.createElement(MenuButton, {
				layoutOrder = 1,
				text = t1[i].text,
				lastInput = s1,
				keyboardButtonImageHint = t1[i].hint.keyboardButtonImage,
				gamepadButton = if not FFlagGamepadIconSupportCheck then nil else t1[i].hint.gamepadButton,
				gamepadButtonImageHint = t1[i].hint.gamepadButtonImage,
				onActivated = t1[i].onActivated,
				isEmphasized = t1[i].isEmphasized,
				isSmall = b1,
				isDisabled = t1[i].getIsDisabled(),
				addTraversalHistoryMenu = if not FFlagAddTraversalHistoryReactMenuButtons then nil else t1[i].addTraversalHistoryMenu,
				currentPageChangeSignal = if not FFlagAddTraversalHistoryReactMenuButtons then nil else t1[i].currentPageChangeSignal,
				buttonRef = if not FFlagIEMFocusNavSupportNewButtons then nil else t1[i].buttonRef
			})
		})
	end

	return t2
end
local function MenuButtons(t3: {[any]: any}) -- line: 80
	-- upvalues: React (copy), Utility (copy), useSignalState (copy), FFlagFixTraversalHistoryMenuFixesV3 (copy), FFlagIEMFocusNavSupportNewButtons (copy), useLocalization (copy), Constants (copy), useLastInput (copy), FFlagAddTraversalHistoryReactMenuButtons (copy), v24 (copy), FIntRelocateMobileMenuButtonsVariant (copy), ContextActionService (copy), UserInputService (copy), v23 (copy), View (copy), createMenuButtons (copy)
	local v34, _ = React.useState(Utility:IsSmallTouchScreen())

	useSignalState(t3.getCanRespawn)

	local v36 = if not FFlagFixTraversalHistoryMenuFixesV3 then nil else React.useRef(nil)
	local v37 = React.useRef(nil)

	if FFlagIEMFocusNavSupportNewButtons then
		React.useEffect(function() -- line: 89
			-- upvalues: t3 (copy), v37 (copy)
			if t3.setResumeMenuButton then
				t3.setResumeMenuButton(v37.current)
			end
		end, { t3.setResumeMenuButton })
	end

	local v38, v39 = React.useBinding("")
	local v40, v41 = React.useBinding("")
	local v42, v43 = React.useBinding("")
	local v44 = useLocalization({
		LeaveGame = Constants.LeaveGameLocalizedKey,
		Respawn = Constants.RespawnLocalizedKey,
		Resume = Constants.ResumeLocalizedKey
	})
	local v45 = useLastInput()
	local v46 = React.useMemo(function() -- line: 107
		-- upvalues: v44 (copy), v38 (copy), v39 (copy), t3 (copy), Constants (copy), FFlagAddTraversalHistoryReactMenuButtons (copy), FFlagFixTraversalHistoryMenuFixesV3 (copy), v36 (copy), v40 (copy), v41 (copy), v42 (copy), v43 (copy), v24 (copy), FIntRelocateMobileMenuButtonsVariant (copy), FFlagIEMFocusNavSupportNewButtons (copy), v37 (copy)
		return {
			{
				name = "LeaveGameButton",
				isEmphasized = false,
				text = v44.LeaveGame,
				hint = {
					keyboard = "L",
					keyboardButtonImage = "icons/controls/keys/key_l",
					gamepadButton = Enum.KeyCode.ButtonX,
					gamepadButtonImage = v38,
					setGamepadButtonImage = v39
				},
				getIsDisabled = function() -- line: 120
					return false
				end,
				onActivated = function() -- line: 123
					-- upvalues: t3 (copy), Constants (copy)
					t3.onLeaveGame(Constants.AnalyticsMenuButtonSource)
				end,
				hotkeys = {
					Enum.KeyCode.L,
					Enum.KeyCode.ButtonX
				},
				hotkeyFunc = function() -- line: 127
					-- upvalues: t3 (copy), Constants (copy)
					t3.onLeaveGame(Constants.AnalyticsMenuHotkeySource)
				end,
				addTraversalHistoryMenu = not not FFlagAddTraversalHistoryReactMenuButtons or nil,
				currentPageChangeSignal = if not FFlagAddTraversalHistoryReactMenuButtons then nil else t3.currentPageChangeSignal,
				buttonRef = if not FFlagFixTraversalHistoryMenuFixesV3 then nil else v36
			},
			{
				name = "ResetButton",
				isEmphasized = false,
				text = v44.Respawn,
				hint = {
					keyboard = "R",
					keyboardButtonImage = "icons/controls/keys/key_r",
					gamepadButton = Enum.KeyCode.ButtonY,
					gamepadButtonImage = v40,
					setGamepadButtonImage = v41
				},
				getIsDisabled = function() -- line: 145
					-- upvalues: t3 (copy)
					return not t3.getCanRespawn(false)
				end,
				onActivated = function() -- line: 148
					-- upvalues: t3 (copy), Constants (copy)
					t3.onRespawn(Constants.AnalyticsMenuButtonSource)
				end,
				hotkeys = {
					Enum.KeyCode.R,
					Enum.KeyCode.ButtonY
				},
				hotkeyFunc = function() -- line: 152
					-- upvalues: t3 (copy), Constants (copy)
					t3.onRespawn(Constants.AnalyticsMenuHotkeySource)
				end
			},
			{
				name = "ResumeButton",
				text = v44.Resume,
				hint = {
					keyboard = "ESC",
					keyboardButtonImage = "icons/controls/keys/key_esc",
					gamepadButton = Enum.KeyCode.ButtonStart,
					gamepadButtonImage = v42,
					setGamepadButtonImage = v43
				},
				isEmphasized = not v24 and FIntRelocateMobileMenuButtonsVariant ~= 1,
				getIsDisabled = function() -- line: 167
					return false
				end,
				onActivated = function() -- line: 170
					-- upvalues: t3 (copy), Constants (copy)
					t3.onResume(Constants.AnalyticsMenuButtonSource)
				end,
				hotkeyFunc = function() -- line: 173
					-- upvalues: t3 (copy), Constants (copy)
					t3.onResume(Constants.AnalyticsMenuHotkeySource)
				end,
				hotkeys = {
					Enum.KeyCode.ButtonB,
					Enum.KeyCode.ButtonStart
				},
				buttonRef = if not FFlagIEMFocusNavSupportNewButtons then nil else v37
			}
		}
	end, {
		v44,
		t3.onLeaveGame,
		t3.onRespawn,
		t3.onResume,
		t3.getCanRespawn
	})
	local v47 = React.useCallback(function(t4: {[any]: any}) -- line: 182
		-- upvalues: t3 (copy), ContextActionService (copy)
		if not t3.getVisibility() then
			return
		end

		for i = 1, #t4 do
			if t4[i].hotkeyFunc ~= nil then
				ContextActionService:BindCoreAction(t4[i].name, t4[i].hotkeyFunc, false, unpack(t4[i].hotkeys))
			end
		end
	end, {})
	local v48 = React.useCallback(function(t5: {[any]: any}) -- line: 199
		-- upvalues: ContextActionService (copy)
		for i = 1, #t5 do
			ContextActionService:UnbindCoreAction(t5[i].name)
		end
	end, {})
	local v49 = React.useCallback(function(t6: {[any]: any}) -- line: 205
		-- upvalues: v48 (copy), UserInputService (copy), t3 (copy), v47 (copy)
		for i = 1, #t6 do
			local v57 = t6[i]
			local onActivated = t6[i].onActivated
			local getIsDisabled = t6[i].getIsDisabled

			function v57.onActivated() -- line: 207
				-- upvalues: getIsDisabled (copy), v48 (copy), t6 (copy), onActivated (copy)
				if not getIsDisabled() then
					v48(t6)
					onActivated()
				end
			end

			local v60 = t6[i]
			local hotkeyFunc = t6[i].hotkeyFunc
			local getIsDisabled2 = t6[i].getIsDisabled

			function v60.hotkeyFunc(_, p2, _) -- line: 216
				-- upvalues: hotkeyFunc (copy), getIsDisabled2 (copy), v48 (copy), t6 (copy)
				if p2 == Enum.UserInputState.Begin then
					local v71 = hotkeyFunc
					local v72 = getIsDisabled2;

					(function() -- line: 207
						-- upvalues: v72 (copy), v48 (copy), t6 (copy), v71 (copy)
						if not v72() then
							v48(t6)
							v71()
						end
					end)()
				end
			end

			t6[i].hint.setGamepadButtonImage(UserInputService:GetImageForKeyCode(t6[i].hint.gamepadButton))
		end

		t3.setAddMenuKeyBindings(function() -- line: 231
			-- upvalues: v47 (copy), t6 (copy)
			v47(t6)
		end)
		t3.setRemoveMenuKeyBindings(function() -- line: 234
			-- upvalues: v48 (copy), t6 (copy)
			v48(t6)
		end)

		return t6
	end, {})
	local v50 = React.useMemo(function() -- line: 241
		-- upvalues: v49 (copy), v46 (copy)
		return v49(v46)
	end, { v46 })

	React.useEffect(function() -- line: 245
		-- upvalues: UserInputService (copy), v50 (copy), v23 (copy)
		local connection = UserInputService.GamepadConnected:Connect(function() -- line: 246
			-- upvalues: v50 (copy), UserInputService (copy)
			for i = 1, #v50 do
				v50[i].hint.setGamepadButtonImage(UserInputService:GetImageForKeyCode(v50[i].hint.gamepadButton))
			end
		end)

		return function() -- line: 254
			-- upvalues: v23 (copy), connection (copy)
			if v23 then
				connection:Disconnect()
			end
		end
	end, { v50 })

	return React.createElement(View, {
		tag = {
			["size-full row align-y-center"] = true,
			["gap-small"] = not v34,
			["gap-xsmall"] = v34
		}
	}, (createMenuButtons(v50, v45, v34)))
end

return MenuButtons
