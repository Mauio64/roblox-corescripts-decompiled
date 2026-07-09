local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ExpChat = script:FindFirstAncestor("ExpChat")
local GetTransparencyStore = require(ExpChat.Stores.GetTransparencyStore)
local Localization = require(ExpChat.Localization)
local LocalizationService = game:GetService("LocalizationService")
local ExpChatParent = ExpChat.Parent
local ExpChatShared = require(ExpChatParent.ExpChatShared)
local Roact = require(ExpChatParent.Roact)
local React = require(ExpChatParent.React)
local RoactRodux = require(ExpChatParent.RoactRodux)
local Config = require(ExpChat.Config)
local InputType = require(ExpChatParent.InputType)
local getInputGroup = require(ExpChatParent.InputType).getInputGroup
local SharedFlags = require(ExpChatParent.SharedFlags)
local FocusChatHotKeyActivated = require(ExpChat.Actions.FocusChatHotKeyActivated)
local AutocompleteDropdownActivated = require(ExpChat.Actions.AutocompleteDropdownActivated)
local AutocompleteDropdownResultsChanged = require(ExpChat.Actions.AutocompleteDropdownResultsChanged)
local AutocompleteDropdownSelectionChanged = require(ExpChat.Actions.AutocompleteDropdownSelectionChanged)
local AutocompleteDropdownTypeChanged = require(ExpChat.Actions.AutocompleteDropdownTypeChanged)
local AutocompleteDropdownDeactivated = require(ExpChat.Actions.AutocompleteDropdownDeactivated)
local v22 = game:DefineFastFlag("MemoizeChatInputApp", false)
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs
local Flags = ExpChat.Flags
local getFFlagUnreduxLastInputTypeChanged = require(Flags.getFFlagUnreduxLastInputTypeChanged)
local FFlagExpChatDictationFadeOverride = require(Flags.FFlagExpChatDictationFadeOverride)
local selectSelectedTabName = require(ExpChat.selectSelectedTabName)
local UI = script.Parent.UI
local ChatInputBar = require(UI.ChatInputBar)
local Localization2 = require(ExpChatParent.InExperienceLocales).Localization
local Cryo = require(ExpChatParent.Cryo)
local v33 = ((if not getFFlagUnreduxLastInputTypeChanged() then Roact.Component else Roact.PureComponent)):extend("ChatInputBarApp")

v33.defaultProps = {
	addTopPadding = true,
	LayoutOrder = 1,
	onSendChat = nil,
	transparencyValue = Roact.createBinding(0.3)
}

if getFFlagUnreduxLastInputTypeChanged() then
	function v33.init(p1) -- line: 53
		-- upvalues: UserInputService (copy), getInputGroup (copy), InputType (copy)
		p1:setState({
			isUsingTouch = UserInputService.TouchEnabled,
			isUsingGamepad = UserInputService.PreferredInput == Enum.PreferredInput.Gamepad
		})
		p1.connection = UserInputService.LastInputTypeChanged:Connect(function(p2) -- line: 58
			-- upvalues: getInputGroup (copy), p1 (copy), InputType (copy)
			local v52 = getInputGroup(p2)

			p1:setState({
				isUsingTouch = v52 == InputType.InputTypeConstants.Touch,
				isUsingGamepad = v52 == InputType.InputTypeConstants.Gamepad
			})
		end)
	end
	function v33.getPlaceholderText(p3) -- line: 68
		if p3.state.isUsingGamepad then
			return p3.props.placeholderGamepadText
		end

		if p3.state.isUsingTouch then
			return p3.props.placeholderTouchText
		end

		return p3.props.placeholderKeyboardText
	end
	function v33.willUnmount(p4) -- line: 78
		if p4.connection then
			p4.connection:Disconnect()
		end
	end
else
	function v33.getPlaceholderText(p5) -- line: 84
		if p5.props.isUsingGamepad then
			return p5.props.placeholderGamepadText
		end

		if p5.props.isUsingTouch then
			return p5.props.placeholderTouchText
		end

		return p5.props.placeholderKeyboardText
	end
end

function v33.render(p6) -- line: 95
	-- upvalues: React (copy), ChatInputBar (copy), UserInputService (copy), Config (copy)
	return React.createElement(ChatInputBar, {
		userInputService = UserInputService,
		contextActionService = game:GetService("ContextActionService"),
		messageCharacterLimit = Config.MessageCharacterLimit,
		sendButtonContainerWidth = 30,
		addTopPadding = p6.props.addTopPadding,
		LayoutOrder = p6.props.LayoutOrder,
		placeholderText = p6:getPlaceholderText(),
		disabledChatPlaceholderText = p6.props.disabledChatPlaceholderText,
		size = UDim2.fromScale(1, 0),
		chatIntervention = p6.props.chatIntervention,
		onSendChat = p6.props.onSendChat,
		onSendGlobalChat = p6.props.onSendGlobalChat,
		transparencyValue = p6.props.transparencyValue,
		canLocalUserChat = p6.props.canLocalUserChat,
		targetTextChannel = p6.props.targetTextChannel,
		localTeam = p6.props.localTeam,
		localPlayer = p6.props.localPlayer,
		defaultSystemTextChannel = p6.props.defaultSystemTextChannel,
		shouldFocusChatInputBar = p6.props.shouldFocusChatInputBar,
		resetTargetChannel = p6.props.resetTargetChannel,
		focusChatHotKeyActivated = p6.props.focusChatHotKeyActivated,
		devDefinedFocusKeyCode = p6.props.devDefinedFocusKeyCode,
		visible = p6.props.visible,
		onFocus = p6.props.onFocus,
		onUnfocus = p6.props.onUnfocus,
		onHovered = p6.props.onHovered,
		onUnhovered = p6.props.onUnhovered,
		onAbsoluteSizeChanged = p6.props.onAbsoluteSizeChanged,
		onAbsolutePositionChanged = p6.props.onAbsolutePositionChanged,
		chatWindowSettings = p6.props.chatWindowSettings,
		chatInputBarSettings = p6.props.chatInputBarSettings,
		isChatHotkeyEnabled = p6.props.isChatHotkeyEnabled,
		autocompleteDropdownReducer = p6.props.autocompleteDropdownReducer,
		autocompleteDropdownActivated = p6.props.autocompleteDropdownActivated,
		autocompleteDropdownResultsChanged = p6.props.autocompleteDropdownResultsChanged,
		autocompleteDropdownSelectionChanged = p6.props.autocompleteDropdownSelectionChanged,
		autocompleteDropdownTypeChanged = p6.props.autocompleteDropdownTypeChanged,
		autocompleteDropdownDeactivated = p6.props.autocompleteDropdownDeactivated,
		autocompleteEnabled = p6.props.autocompleteEnabled,
		isChannelBarVisible = p6.props.isChannelBarVisible,
		isGlobalChatTabActive = p6.props.isGlobalChatTabActive,
		developerChannelTabsEnabled = p6.props.developerChannelTabsEnabled,
		onDictationActivityChanged = p6.props.onDictationActivityChanged
	})
end

local v34 = RoactRodux.connect(function(p7) -- line: 143
	-- upvalues: GetFFlagTextChatEnableUniverseChatTabs (copy), Players (copy), getFFlagUnreduxLastInputTypeChanged (copy), selectSelectedTabName (copy)
	local ChannelTabs = p7.ChannelTabs
	local v43 = not not GetFFlagTextChatEnableUniverseChatTabs() and (not not ChannelTabs and ChannelTabs.channelTabsConfigurationEnabled)

	return {
		targetTextChannel = p7.TextChannels.targetTextChannel,
		localPlayer = Players.LocalPlayer,
		localTeam = p7.LocalTeam,
		isUsingTouch = if getFFlagUnreduxLastInputTypeChanged() then nil else p7.isUsingTouch,
		isUsingGamepad = if getFFlagUnreduxLastInputTypeChanged() then nil else p7.isUsingGamepad,
		devDefinedFocusKeyCode = p7.ChatLayout.ChatInputBarSettings.KeyboardKeyCode,
		defaultSystemTextChannel = p7.TextChannels.allTextChannels.RBXSystem,
		shouldFocusChatInputBar = p7.shouldFocusChatInputBar,
		chatInputBarSettings = p7.ChatLayout.ChatInputBarSettings,
		chatIntervention = p7.ChatIntervention,
		isChatHotkeyEnabled = p7.ChatVisibility.isChatHotkeyEnabled.value,
		autocompleteDropdownReducer = p7.AutocompleteDropdown,
		autocompleteEnabled = p7.ChatLayout.ChatInputBarSettings.AutocompleteEnabled,
		isGlobalChatTabActive = GetFFlagTextChatEnableUniverseChatTabs() and selectSelectedTabName(p7) == "RBXGlobal",
		developerChannelTabsEnabled = v43
	}
end, function(p8) -- line: 167
	-- upvalues: GetTransparencyStore (copy), FocusChatHotKeyActivated (copy), FFlagExpChatDictationFadeOverride (copy), AutocompleteDropdownActivated (copy), AutocompleteDropdownResultsChanged (copy), AutocompleteDropdownSelectionChanged (copy), AutocompleteDropdownTypeChanged (copy), AutocompleteDropdownDeactivated (copy)
	local v45 = GetTransparencyStore(false)

	return {
		focusChatHotKeyActivated = function() -- line: 170
			-- upvalues: p8 (copy), FocusChatHotKeyActivated (copy)
			return p8(FocusChatHotKeyActivated())
		end,
		onFocus = function() -- line: 174
			-- upvalues: v45 (copy)
			return v45.setTextboxFocus()
		end,
		onUnfocus = function() -- line: 178
			-- upvalues: v45 (copy)
			return v45.clearTextboxFocus()
		end,
		onHovered = function() -- line: 182
			-- upvalues: v45 (copy)
			return v45.resetAllTransparency()
		end,
		onUnhovered = function() -- line: 186
			-- upvalues: v45 (copy)
			return v45.resetAllTransparency()
		end,
		onDictationActivityChanged = if not FFlagExpChatDictationFadeOverride then nil else function(b1: boolean) -- line: 192
			-- upvalues: v45 (copy)
			if b1 then
				v45.setDictationActive()

				return
			end

			v45.clearDictationActive()
		end,
		autocompleteDropdownActivated = function(p9) -- line: 201
			-- upvalues: p8 (copy), AutocompleteDropdownActivated (copy)
			return p8(AutocompleteDropdownActivated(p9))
		end,
		autocompleteDropdownResultsChanged = function(p10) -- line: 205
			-- upvalues: p8 (copy), AutocompleteDropdownResultsChanged (copy)
			return p8(AutocompleteDropdownResultsChanged(p10))
		end,
		autocompleteDropdownSelectionChanged = function(p11) -- line: 209
			-- upvalues: p8 (copy), AutocompleteDropdownSelectionChanged (copy)
			return p8(AutocompleteDropdownSelectionChanged(p11))
		end,
		autocompleteDropdownTypeChanged = function(p12) -- line: 213
			-- upvalues: p8 (copy), AutocompleteDropdownTypeChanged (copy)
			return p8(AutocompleteDropdownTypeChanged(p12))
		end,
		autocompleteDropdownDeactivated = function() -- line: 217
			-- upvalues: p8 (copy), AutocompleteDropdownDeactivated (copy)
			return p8(AutocompleteDropdownDeactivated())
		end
	}
end)(Localization.connect(function(p13) -- line: 221
	-- upvalues: UserInputService (copy)
	return {
		placeholderTouchText = "CoreScripts.TextChat.InputBar.Hint.Touch",
		disabledChatPlaceholderText = "CoreScripts.TextChat.InputBar.Hint.PrivacySettingsDisabled",
		placeholderKeyboardText = {
			"CoreScripts.TextChat.InputBar.Hint.MouseKeyboard",
			{
				KEY = UserInputService:GetStringForKeyCode(p13.devDefinedFocusKeyCode)
			}
		}
	}
end)(v33))

local function v35(p14) -- line: 233
	-- upvalues: Localization2 (copy), LocalizationService (copy), FFlagEnableConsoleExpControls (copy), Cryo (copy), React (copy), v34 (copy)
	local v48 = Localization2.new(LocalizationService.RobloxLocaleId)
	local v49 = if not FFlagEnableConsoleExpControls then v48:Format("CoreScripts.TextChat.InputBar.Hint.Gamepad", {
		CHAT_BUTTON = v48:Format("CoreScripts.TopBar.Chat")
	}) else v48:Format("CoreScripts.TextChat.InputBar.Hint.GamepadConnected", {
		CONFIRM_KEY = v48:Format("CoreScripts.TextChat.InputBar.Hint.GamepadConnectedConfirm")
	})
	local v50 = Cryo.Dictionary.join(p14, {
		placeholderGamepadText = v49
	})

	return React.createElement(v34, v50)
end

if v22 then
	return (React.memo(v35))
end

return v35
