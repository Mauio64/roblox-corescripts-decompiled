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
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local Localization = require(CorePackages.Workspace.Packages.Localization)
local useLocalization = Localization.Hooks.useLocalization

local MenuButton = require(script.Parent.MenuButton)

local useSignalState = SignalsReact.useSignalState
local useLastInput = Responsive.useLastInput

local View = Foundation.View

local FIntRelocateMobileMenuButtonsVariant = require(RobloxGui.Modules.Settings.Flags.FIntRelocateMobileMenuButtonsVariant)
local FFlagAddTraversalHistoryReactMenuButtons = require(RobloxGui.Modules.Settings.Flags.FFlagAddTraversalHistoryReactMenuButtons)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagGamepadIconSupportCheck = SharedFlags.FFlagGamepadIconSupportCheck

local defineFastFlag = game:DefineFastFlag("MenuButtonsDisconnectGamepadConnected", false)
local defineFastFlag2 = game:DefineFastFlag("MenuButtonsUseGreyResumeButton", false)
local FFlagIEMFocusNavSupportNewButtons = require(RobloxGui.Modules.Settings.Flags.FFlagIEMFocusNavSupportNewButtons)

local function createMenuButtons(list, lastInput: string, state: boolean)
	local children = {}

	for i = 1, #list do
		local v = "MenuButtonContainer" .. i
		local createElement = React.createElement

		local createElement2 = React.createElement
		local v2 = {
			text = list[i].text,
			lastInput = lastInput,
			keyboardButtonImageHint = list[i].hint.keyboardButtonImage,
			gamepadButton = 0,
			gamepadButtonImageHint = 0,
			onActivated = 0,
			layoutOrder = 1,
			isEmphasized = 0,
			isSmall = 0,
			isDisabled = 0,
			addTraversalHistoryMenu = 0,
			currentPageChangeSignal = 0,
			buttonRef = 0
		}
		local gamepadButton

		if FFlagGamepadIconSupportCheck then
			gamepadButton = list[i].hint.gamepadButton
		end

		v2.gamepadButton = gamepadButton
		v2.gamepadButtonImageHint = list[i].hint.gamepadButtonImage
		v2.onActivated = list[i].onActivated

		v2.isEmphasized = list[i].isEmphasized
		v2.isSmall = state
		v2.isDisabled = list[i].getIsDisabled()
		local addTraversalHistoryMenu

		if FFlagAddTraversalHistoryReactMenuButtons then
			addTraversalHistoryMenu = list[i].addTraversalHistoryMenu
		end

		v2.addTraversalHistoryMenu = addTraversalHistoryMenu
		local currentPageChangeSignal

		if FFlagAddTraversalHistoryReactMenuButtons then
			currentPageChangeSignal = list[i].currentPageChangeSignal
		end

		v2.currentPageChangeSignal = currentPageChangeSignal
		local buttonRef

		if FFlagIEMFocusNavSupportNewButtons then
			buttonRef = list[i].buttonRef
		end

		v2.buttonRef = buttonRef
		children[v] = createElement(View, {
			tag = "fill row align-y-center",
			LayoutOrder = i,
			SelectionGroup = FFlagIEMFocusNavSupportNewButtons and true or nil
		}, { MenuButton = createElement2(MenuButton, v2) })
	end

	return children
end

local function MenuButtons(props)
	local state, _ = React.useState(Utility:IsSmallTouchScreen())

	useSignalState(props.getCanRespawn)

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	if FFlagIEMFocusNavSupportNewButtons then
		React.useEffect(function()
			if props.setResumeMenuButton then
				props.setResumeMenuButton(ref2.current)
			end
		end, { props.setResumeMenuButton })
	end

	local gamepadButtonImage, setGamepadButtonImage = React.useBinding("")
	local gamepadButtonImage2, setGamepadButtonImage2 = React.useBinding("")
	local gamepadButtonImage3, setGamepadButtonImage3 = React.useBinding("")

	local v = useLocalization({
		LeaveGame = Constants.LeaveGameLocalizedKey,
		Respawn = Constants.RespawnLocalizedKey,
		Resume = Constants.ResumeLocalizedKey
	})

	local lastInput = useLastInput()

	local v2 = React.useMemo(function()
		local v2 = {
			name = "LeaveGameButton",
			text = v.LeaveGame,
			hint = {
				keyboard = "L",
				keyboardButtonImage = "icons/controls/keys/key_l",
				gamepadButton = Enum.KeyCode.ButtonX,
				gamepadButtonImage = gamepadButtonImage,
				setGamepadButtonImage = setGamepadButtonImage
			},
			isEmphasized = false,
			getIsDisabled = function(): boolean
				return false
			end,
			onActivated = function()
				props.onLeaveGame(Constants.AnalyticsMenuButtonSource)
			end,
			hotkeys = { Enum.KeyCode.L, Enum.KeyCode.ButtonX },
			hotkeyFunc = function()
				props.onLeaveGame(Constants.AnalyticsMenuHotkeySource)
			end,
			addTraversalHistoryMenu = FFlagAddTraversalHistoryReactMenuButtons and true or nil,
			currentPageChangeSignal = 0,
			buttonRef = 0
		}
		local currentPageChangeSignal

		if FFlagAddTraversalHistoryReactMenuButtons then
			currentPageChangeSignal = props.currentPageChangeSignal
		end

		v2.currentPageChangeSignal = currentPageChangeSignal
		v2.buttonRef = ref

		local v3 = {
			name = "ResetButton",
			text = v.Respawn,
			hint = {
				keyboard = "R",
				keyboardButtonImage = "icons/controls/keys/key_r",
				gamepadButton = Enum.KeyCode.ButtonY,
				gamepadButtonImage = gamepadButtonImage2,
				setGamepadButtonImage = setGamepadButtonImage2
			},
			isEmphasized = false,
			getIsDisabled = function(): boolean
				return not props.getCanRespawn(false)
			end,
			onActivated = function()
				props.onRespawn(Constants.AnalyticsMenuButtonSource)
			end,
			hotkeys = { Enum.KeyCode.R, Enum.KeyCode.ButtonY },
			hotkeyFunc = function()
				props.onRespawn(Constants.AnalyticsMenuHotkeySource)
			end
		}

		local v4 = {
			name = "ResumeButton",
			text = v.Resume,
			hint = {
				keyboard = "ESC",
				keyboardButtonImage = "icons/controls/keys/key_esc",
				gamepadButton = Enum.KeyCode.ButtonStart,
				gamepadButtonImage = gamepadButtonImage3,
				setGamepadButtonImage = setGamepadButtonImage3
			},
			isEmphasized = 0,
			getIsDisabled = 0,
			onActivated = 0,
			hotkeyFunc = 0,
			hotkeys = 0,
			buttonRef = 0
		}
		local isEmphasized

		if defineFastFlag2 then
			isEmphasized = false
		else
			isEmphasized = FIntRelocateMobileMenuButtonsVariant ~= 1
		end

		v4.isEmphasized = isEmphasized
		function v4.getIsDisabled(): boolean
			return false
		end

		function v4.onActivated()
			props.onResume(Constants.AnalyticsMenuButtonSource)
		end
		function v4.hotkeyFunc()
			props.onResume(Constants.AnalyticsMenuHotkeySource)
		end
		v4.hotkeys = { Enum.KeyCode.ButtonB, Enum.KeyCode.ButtonStart }
		local buttonRef

		if FFlagIEMFocusNavSupportNewButtons then
			buttonRef = ref2
		end

		v4.buttonRef = buttonRef
		return { v2, v3, v4 }
	end, { v, props.onLeaveGame, props.onRespawn, props.onResume, props.getCanRespawn })

	local v3 = React.useCallback(function(list)
		if not props.getVisibility() then
			return
		end

		for i = 1, #list do
			if list[i].hotkeyFunc ~= nil then
				ContextActionService:BindCoreAction(list[i].name, list[i].hotkeyFunc, false, unpack(list[i].hotkeys))
			end
		end
	end, {})

	local v4 = React.useCallback(function(list)
		for i = 1, #list do
			ContextActionService:UnbindCoreAction(list[i].name)
		end
	end, {})

	local v5 = React.useCallback(function(list)
		for i = 1, #list do
			local item = list[i]
			local onActivated = list[i].onActivated
			local getIsDisabled = list[i].getIsDisabled

			function item.onActivated()
				if not getIsDisabled() then
					v4(list)
					onActivated()
				end
			end
			local item2 = list[i]
			local hotkeyFunc = list[i].hotkeyFunc
			local getIsDisabled2 = list[i].getIsDisabled

			function item2.hotkeyFunc(_, p, _)
				if p == Enum.UserInputState.Begin then
					local hotkeyFunc2 = hotkeyFunc
					local getIsDisabled3 = getIsDisabled2;
					(function()
						if not getIsDisabled3() then
							v4(list)
							hotkeyFunc2()
						end
					end)()
				end
			end
			list[i].hint.setGamepadButtonImage(UserInputService:GetImageForKeyCode(list[i].hint.gamepadButton))
		end

		props.setAddMenuKeyBindings(function()
			v3(list)
		end)
		props.setRemoveMenuKeyBindings(function()
			v4(list)
		end)

		return list
	end, {})

	local v6 = React.useMemo(function()
		return v5(v2)
	end, { v2 })

	React.useEffect(function()
		local gamepadConnectedConnection = UserInputService.GamepadConnected:Connect(function()
			for i = 1, #v6 do
				v6[i].hint.setGamepadButtonImage(UserInputService:GetImageForKeyCode(v6[i].hint.gamepadButton))
			end
		end)

		return function()
			if defineFastFlag then
				gamepadConnectedConnection:Disconnect()
			end
		end
	end, { v6 })

	return React.createElement(View, {
		tag = {
			["size-full row align-y-center"] = true,
			["gap-small"] = not state,
			["gap-xsmall"] = state
		}
	}, createMenuButtons(v6, lastInput, state))
end

return MenuButtons
