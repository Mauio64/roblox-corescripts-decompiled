local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local ExpChat = script:FindFirstAncestor("ExpChat")
local GetTransparencyStore = require(ExpChat.Stores.GetTransparencyStore)
local Localization = require(ExpChat.Localization)
local LocalizationService = game:GetService("LocalizationService")

local parent = ExpChat.Parent
local ExpChatShared = require(parent.ExpChatShared)
local Roact = require(parent.Roact)
local React = require(parent.React)
local RoactRodux = require(parent.RoactRodux)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local tutils = require(parent.tutils)
local Config = require(ExpChat.Config)
local InputType = require(parent.InputType)
local InputType2 = require(parent.InputType)
local getInputGroup = InputType2.getInputGroup
local SharedFlags = require(parent.SharedFlags)

local FocusChatHotKeyActivated = require(ExpChat.Actions.FocusChatHotKeyActivated)
local AutocompleteDropdownActivated = require(ExpChat.Actions.AutocompleteDropdownActivated)
local AutocompleteDropdownResultsChanged = require(ExpChat.Actions.AutocompleteDropdownResultsChanged)
local AutocompleteDropdownSelectionChanged = require(ExpChat.Actions.AutocompleteDropdownSelectionChanged)
local AutocompleteDropdownTypeChanged = require(ExpChat.Actions.AutocompleteDropdownTypeChanged)
local AutocompleteDropdownDeactivated = require(ExpChat.Actions.AutocompleteDropdownDeactivated)
local defineFastFlag = game:DefineFastFlag("MemoizeChatInputApp", false)

local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local FFlagLuaSupportMicroGamepadPreferredInput = SharedFlags.FFlagLuaSupportMicroGamepadPreferredInput
local FFlagExpChatUseChannelTabsStore = SharedFlags.FFlagExpChatUseChannelTabsStore
local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs
local GetChannelTabsStore

if FFlagExpChatUseChannelTabsStore then
	GetChannelTabsStore = require(ExpChat.Stores.GetChannelTabsStore)
else
	GetChannelTabsStore = nil
end

local Flags = ExpChat.Flags
local getFFlagUnreduxLastInputTypeChanged = require(Flags.getFFlagUnreduxLastInputTypeChanged)
local FFlagExpChatDictationFadeOverride = require(Flags.FFlagExpChatDictationFadeOverride)
local FFlagExpChatContinuousDictationIdleFade = require(Flags.FFlagExpChatContinuousDictationIdleFade)

local selectSelectedTabName = require(ExpChat.selectSelectedTabName)

local ui = script.Parent.UI
local ChatInputBar = require(ui.ChatInputBar)
local DictationState = require(ui.ChatInputBar.Dictation.DictationState)

local InExperienceLocales = require(parent.InExperienceLocales)
local localization = InExperienceLocales.Localization
local Cryo = require(parent.Cryo)
local v

if getFFlagUnreduxLastInputTypeChanged() then
	v = Roact.PureComponent
else
	v = Roact.Component
end

local extended = v:extend("ChatInputBarApp")

extended.defaultProps = {
	addTopPadding = true,
	LayoutOrder = 1,
	onSendChat = nil,
	transparencyValue = Roact.createBinding(0.3)
}

if getFFlagUnreduxLastInputTypeChanged() then
	function extended:init()
		self:setState({
			isUsingTouch = UserInputService.TouchEnabled,
			isUsingGamepad = UserInputService.PreferredInput == Enum.PreferredInput.Gamepad or FFlagLuaSupportMicroGamepadPreferredInput and UserInputService.PreferredInput == Enum.PreferredInput.MicroGamepad
		})

		self.connection = UserInputService.LastInputTypeChanged:Connect(function(p)
			local inputGroup = getInputGroup(p)

			self:setState({
				isUsingTouch = inputGroup == InputType.InputTypeConstants.Touch,
				isUsingGamepad = inputGroup == InputType.InputTypeConstants.Gamepad
			})
		end)
	end

	function extended:getPlaceholderText()
		if self.state.isUsingGamepad then
			return self.props.placeholderGamepadText
		end

		if self.state.isUsingTouch then
			return self.props.placeholderTouchText
		end

		return self.props.placeholderKeyboardText
	end

	function extended.willUnmount(p)
		if p.connection then
			p.connection:Disconnect()
		end
	end
else
	function extended:getPlaceholderText()
		if self.props.isUsingGamepad then
			return self.props.placeholderGamepadText
		end

		if self.props.isUsingTouch then
			return self.props.placeholderTouchText
		end

		return self.props.placeholderKeyboardText
	end
end

function extended:render()
	return React.createElement(ChatInputBar, {
		userInputService = UserInputService,
		contextActionService = game:GetService("ContextActionService"),
		messageCharacterLimit = Config.MessageCharacterLimit,
		sendButtonContainerWidth = 30,
		addTopPadding = self.props.addTopPadding,
		LayoutOrder = self.props.LayoutOrder,
		placeholderText = self:getPlaceholderText(),
		disabledChatPlaceholderText = self.props.disabledChatPlaceholderText,
		size = UDim2.fromScale(1, 0),
		chatIntervention = self.props.chatIntervention,
		onSendChat = self.props.onSendChat,
		onSendGlobalChat = self.props.onSendGlobalChat,
		transparencyValue = self.props.transparencyValue,
		canLocalUserChat = self.props.canLocalUserChat,
		targetTextChannel = self.props.targetTextChannel,
		localTeam = self.props.localTeam,
		localPlayer = self.props.localPlayer,
		defaultSystemTextChannel = self.props.defaultSystemTextChannel,
		shouldFocusChatInputBar = self.props.shouldFocusChatInputBar,
		resetTargetChannel = self.props.resetTargetChannel,
		focusChatHotKeyActivated = self.props.focusChatHotKeyActivated,
		devDefinedFocusKeyCode = self.props.devDefinedFocusKeyCode,
		visible = self.props.visible,
		onFocus = self.props.onFocus,
		onUnfocus = self.props.onUnfocus,
		onHovered = self.props.onHovered,
		onUnhovered = self.props.onUnhovered,
		onAbsoluteSizeChanged = self.props.onAbsoluteSizeChanged,
		onAbsolutePositionChanged = self.props.onAbsolutePositionChanged,
		chatWindowSettings = self.props.chatWindowSettings,
		chatInputBarSettings = self.props.chatInputBarSettings,
		isChatHotkeyEnabled = self.props.isChatHotkeyEnabled,
		autocompleteDropdownReducer = self.props.autocompleteDropdownReducer,
		autocompleteDropdownActivated = self.props.autocompleteDropdownActivated,
		autocompleteDropdownResultsChanged = self.props.autocompleteDropdownResultsChanged,
		autocompleteDropdownSelectionChanged = self.props.autocompleteDropdownSelectionChanged,
		autocompleteDropdownTypeChanged = self.props.autocompleteDropdownTypeChanged,
		autocompleteDropdownDeactivated = self.props.autocompleteDropdownDeactivated,
		autocompleteEnabled = self.props.autocompleteEnabled,
		isChannelBarVisible = self.props.isChannelBarVisible,
		isGlobalChatTabActive = self.props.isGlobalChatTabActive,
		developerChannelTabsEnabled = self.props.developerChannelTabsEnabled,
		onDictationActivityChanged = self.props.onDictationActivityChanged,
		onDictationStateChanged = self.props.onDictationStateChanged
	})
end

local v2 = RoactRodux.connect(function(data)
	local isGlobalChatTabActive, developerChannelTabsEnabled

	if not FFlagExpChatUseChannelTabsStore then
		local channelTabs = data.ChannelTabs
		isGlobalChatTabActive = GetFFlagTextChatEnableUniverseChatTabs() and selectSelectedTabName(data) == "RBXGlobal"

		if GetFFlagTextChatEnableUniverseChatTabs() and channelTabs then
			developerChannelTabsEnabled = channelTabs.channelTabsConfigurationEnabled
		else
			developerChannelTabsEnabled = false
		end
	end

	local v2 = {
		targetTextChannel = data.TextChannels.targetTextChannel,
		localPlayer = Players.LocalPlayer,
		localTeam = data.LocalTeam,
		isUsingTouch = 0,
		isUsingGamepad = 0,
		devDefinedFocusKeyCode = 0,
		defaultSystemTextChannel = 0,
		shouldFocusChatInputBar = 0,
		chatInputBarSettings = 0,
		chatIntervention = 0,
		isChatHotkeyEnabled = 0,
		autocompleteDropdownReducer = 0,
		autocompleteEnabled = 0,
		isGlobalChatTabActive = 0,
		developerChannelTabsEnabled = 0
	}
	local isUsingTouch

	if not getFFlagUnreduxLastInputTypeChanged() then
		isUsingTouch = data.isUsingTouch
	end

	v2.isUsingTouch = isUsingTouch
	local isUsingGamepad

	if not getFFlagUnreduxLastInputTypeChanged() then
		isUsingGamepad = data.isUsingGamepad
	end

	v2.isUsingGamepad = isUsingGamepad
	v2.devDefinedFocusKeyCode = data.ChatLayout.ChatInputBarSettings.KeyboardKeyCode
	v2.defaultSystemTextChannel = data.TextChannels.allTextChannels.RBXSystem
	v2.shouldFocusChatInputBar = data.shouldFocusChatInputBar
	v2.chatInputBarSettings = data.ChatLayout.ChatInputBarSettings
	v2.chatIntervention = data.ChatIntervention
	v2.isChatHotkeyEnabled = data.ChatVisibility.isChatHotkeyEnabled.value
	v2.autocompleteDropdownReducer = data.AutocompleteDropdown
	v2.autocompleteEnabled = data.ChatLayout.ChatInputBarSettings.AutocompleteEnabled
	v2.isGlobalChatTabActive = isGlobalChatTabActive
	v2.developerChannelTabsEnabled = developerChannelTabsEnabled
	return v2
end, function(callback)
	local transparencyStore = GetTransparencyStore(false)
	local v2 = FFlagExpChatDictationFadeOverride and FFlagExpChatContinuousDictationIdleFade

	local function setDictationHold(flag: boolean)
		if flag then
			transparencyStore.setDictationActive()
		else
			transparencyStore.clearDictationActive()
		end
	end

	local v3 = {
		focusChatHotKeyActivated = function()
			return callback(FocusChatHotKeyActivated())
		end,
		onFocus = function()
			return transparencyStore.setTextboxFocus()
		end,
		onUnfocus = function()
			return transparencyStore.clearTextboxFocus()
		end,
		onHovered = function()
			return transparencyStore.resetAllTransparency()
		end,
		onUnhovered = function()
			return transparencyStore.resetAllTransparency()
		end,
		onDictationActivityChanged = 0,
		onDictationStateChanged = 0,
		autocompleteDropdownActivated = 0,
		autocompleteDropdownResultsChanged = 0,
		autocompleteDropdownSelectionChanged = 0,
		autocompleteDropdownTypeChanged = 0,
		autocompleteDropdownDeactivated = 0
	}

	if not FFlagExpChatDictationFadeOverride or v2 then
		setDictationHold = nil
	end

	v3.onDictationActivityChanged = setDictationHold

	v3.onDictationStateChanged = v2 and function(p)
		if p == DictationState.Recording or p == DictationState.Transcribing then
			transparencyStore.setDictationActive()
		else
			transparencyStore.clearDictationActive()
		end
	end or nil

	function v3.autocompleteDropdownActivated(p)
		return callback(AutocompleteDropdownActivated(p))
	end

	function v3.autocompleteDropdownResultsChanged(p, p2)
		return callback(AutocompleteDropdownResultsChanged(p, p2))
	end

	function v3.autocompleteDropdownSelectionChanged(p)
		return callback(AutocompleteDropdownSelectionChanged(p))
	end

	function v3.autocompleteDropdownTypeChanged(p)
		return callback(AutocompleteDropdownTypeChanged(p))
	end

	function v3.autocompleteDropdownDeactivated()
		return callback(AutocompleteDropdownDeactivated())
	end

	return v3
end)(Localization.connect(function(p)
	return {
		placeholderKeyboardText = {
			"CoreScripts.TextChat.InputBar.Hint.MouseKeyboard",
			{
				KEY = UserInputService:GetStringForKeyCode(p.devDefinedFocusKeyCode)
			}
		},
		placeholderTouchText = "CoreScripts.TextChat.InputBar.Hint.Touch",
		disabledChatPlaceholderText = "CoreScripts.TextChat.InputBar.Hint.PrivacySettingsDisabled"
	}
end)(extended))

local function ResultComponentWithSignals(p)
	local v3 = React.useMemo(function()
		return Signals.createComputed(function(p2)
			local channelTabsState = GetChannelTabsStore(false).getChannelTabsState(p2)
			local developerChannelTabsEnabled

			if GetFFlagTextChatEnableUniverseChatTabs() then
				developerChannelTabsEnabled = channelTabsState.channelTabsConfigurationEnabled
			else
				developerChannelTabsEnabled = false
			end

			return {
				developerChannelTabsEnabled = developerChannelTabsEnabled,
				isGlobalChatTabActive = GetFFlagTextChatEnableUniverseChatTabs() and channelTabsState.selectedTabName == "RBXGlobal"
			}
		end, tutils.deepEqual)
	end, {})
	local v4 = SignalsReact.useSignalState(v3)
	return React.createElement(v2, Cryo.Dictionary.union(p, v4))
end

if not FFlagExpChatUseChannelTabsStore then
	ResultComponentWithSignals = v2
end

local function fn(p)
	local v3 = localization.new(LocalizationService.RobloxLocaleId)
	local placeholderGamepadText

	if FFlagEnableConsoleExpControls then
		placeholderGamepadText = v3:Format("CoreScripts.TextChat.InputBar.Hint.GamepadConnected", {
			CONFIRM_KEY = v3:Format("CoreScripts.TextChat.InputBar.Hint.GamepadConnectedConfirm")
		})
	else
		placeholderGamepadText = v3:Format("CoreScripts.TextChat.InputBar.Hint.Gamepad", {
			CHAT_BUTTON = v3:Format("CoreScripts.TopBar.Chat")
		})
	end

	local joined = Cryo.Dictionary.join(p, { placeholderGamepadText = placeholderGamepadText })

	return React.createElement(ResultComponentWithSignals, joined)
end

if defineFastFlag then
	return (React.memo(fn))
end

return fn
