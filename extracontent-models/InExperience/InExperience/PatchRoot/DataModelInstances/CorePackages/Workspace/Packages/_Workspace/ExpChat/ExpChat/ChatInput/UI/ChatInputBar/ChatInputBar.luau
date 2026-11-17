local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local React = require(parent.React)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local ExpChatShared = require(parent.ExpChatShared)
local Chrome = require(parent.Chrome)
local FocusUtils = Chrome.FocusUtils
local ChatUIPrimitives = require(parent.ChatUIPrimitives)
local useFocusInputBar = ChatUIPrimitives.Hooks.useFocusInputBar
local ChatUIPrimitives2 = require(parent.ChatUIPrimitives)
local useInputBarTabNavigation = ChatUIPrimitives2.Hooks.useInputBarTabNavigation

local GetMessagesStore = require(ExpChat.Stores.GetMessagesStore)
local IxpServiceWrapper = require(parent.IxpServiceWrapper)
local IXPServiceWrapper = IxpServiceWrapper.IXPServiceWrapper
local GetChatTooltipStore = require(ExpChat.Stores.GetChatTooltipStore)

local UIBlox = require(parent.UIBlox)
local Promise = require(parent.Promise)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local llama = require(parent.llama)
local list = llama.List
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useCursor = UIBlox.App.SelectionCursor.useCursor

local useInterpolatedClientSettings = require(ExpChat.ClientSettings.useInterpolatedClientSettings)
local Config = require(ExpChat.Config)
local GetFocusNavigationStore = require(ExpChat.Stores.GetFocusNavigationStore)
local GetPresetChatStore = require(ExpChat.Stores.GetPresetChatStore)
local v = ExpChatShared.Logger:new("ExpChat/" .. script.Name)
local autoCastCommand = ExpChatShared.Commands.autoCastCommand
local RBXWhisperCommand = ExpChatShared.Commands.Whisper.RBXWhisperCommand
local RBXTeamCommand = ExpChatShared.Commands.RBXTeamCommand

local Localization = require(ExpChat.Localization)
local getOtherDisplayNameInWhisperChannel = require(ExpChat.getOtherDisplayNameInWhisperChannel)

local ChannelChip = require(script.Parent.ChannelChip)

local AutocompleteText = require(ExpChat.Autocomplete.AutocompleteText)
local PresetEntryText = require(ExpChat.Autocomplete.PresetEntryText)
local PresetSearch = require(ExpChat.Autocomplete.PresetSearch)
local Constants = require(ExpChat.PresetChat.Constants)
local sendPreset = require(ExpChat.PresetChat.sendPreset)
local initializeEmojis = require(ExpChat.Autocomplete.Initializations.initializeEmojis)
local initializeCommands = require(ExpChat.Autocomplete.Initializations.initializeCommands)
local initializeGlobalCommands = require(ExpChat.Autocomplete.Initializations.initializeGlobalCommands)
local initialCommands = require(ExpChat.Autocomplete.Initializations.initialCommands)
local sortEmojiResultsCallback = require(ExpChat.Autocomplete.SortingCallbacks.sortEmojiResultsCallback)
local sortCommandResultsCallback = require(ExpChat.Autocomplete.SortingCallbacks.sortCommandResultsCallback)

local ChatInput = script:FindFirstAncestor("ChatInput")
local AutocompleteDropdown = require(ChatInput.UI.AutocompleteDropdown)

local ChatInputBarV2 = require(script.Parent.ChatInputBarV2)
local ChatInputBarV2Dictation = require(script.Parent.ChatInputBarV2Dictation)
local FFlagExpChatPresetChatEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatEnabled

local FFlagExpChatPresetChatAutocompleteEnabled = require(ExpChat.Flags.FFlagExpChatPresetChatAutocompleteEnabled)

local FFlagExpChatPresetChatAutocompleteAnalyticsEnabled = require(ExpChat.Flags.FFlagExpChatPresetChatAutocompleteAnalyticsEnabled)
local FFlagExpChatEmojiDropdownShowAnalytics = require(ExpChat.Flags.FFlagExpChatEmojiDropdownShowAnalytics)

local FFlagExpChatEmojiDropdownDismissAnalytics = require(ExpChat.Flags.FFlagExpChatEmojiDropdownDismissAnalytics)
local FFlagExpChatUniverseChatPresetEnabled = require(ExpChat.Flags.FFlagExpChatUniverseChatPresetEnabled)
local FFlagExpChatUseUnifiedTooltipStore = ExpChatShared.Flags.FFlagExpChatUseUnifiedTooltipStore
local FFlagExpChatNewInputBar = require(ExpChat.Flags.FFlagExpChatNewInputBar)
local FFlagExpChatAutocompleteDropdownRedesign = require(ExpChat.Flags.FFlagExpChatAutocompleteDropdownRedesign)
local FFlagExpChatNewInputBarDictation = require(ExpChat.Flags.FFlagExpChatNewInputBarDictation)
local FFlagExpChatPresetChatGamepadEnabled = require(ExpChat.Flags.FFlagExpChatPresetChatGamepadEnabled)

local defineFastFlag = game:DefineFastFlag("ExpChatPresetChatIXPExposure", false)
local defineFastString = game:DefineFastString("ExpChatPresetChatIXPLayerName", "UniverseChat.PresetChat")

local defineFastFlag2 = game:DefineFastFlag("ExpChatDictationIXPExposure", false)
local defineFastString2 = game:DefineFastString("ExpChatDictationIXPLayerName", "UniverseChat.Dictation")

local defineFastFlag3 = game:DefineFastFlag("ExpChatPresetAutocompleteIxpEnabled", false)
local defineFastString3 = game:DefineFastString("ExpChatPresetAutocompleteIxpLayer", "")

local defineFastFlag4 = game:DefineFastFlag("ExpChatPresetAutocompleteSearchVariants", false)

local FFlagExpChatPresetAutocompleteIxpGated = require(ExpChat.Flags.FFlagExpChatPresetAutocompleteIxpGated)
local fFlagExpChatPresetChatSendEnabled = FFlagExpChatPresetAutocompleteIxpGated
	and ExpChatShared.Flags.FFlagExpChatPresetChatSendEnabled

local defineFastFlag5 = game:DefineFastFlag("ExpChatMainInputBarClickAnalytics", false)

local getEnableChatInputBarConfigurationAutocompleteEnabled = require(ExpChat.Flags.getEnableChatInputBarConfigurationAutocompleteEnabled)

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local FFlagChromeChatGamepadSupportFix = SharedFlags.FFlagChromeChatGamepadSupportFix
local FFlagConsoleChatUseChromeFocusUtils = SharedFlags.FFlagConsoleChatUseChromeFocusUtils
local defineFastFlag6 = game:DefineFastFlag("ChatOptimizeCommandProcessing", false)
local defineFastFlag7 = game:DefineFastFlag("ExpChatDoNotSetCursorPosition", false)

local FFlagExpChatBackspaceExitsTargetChannelInGlobalTabs = require(ExpChat.Flags.FFlagExpChatBackspaceExitsTargetChannelInGlobalTabs)
local FFlagExpChatFixBackspaceNilTargetChannel = ExpChatShared.Flags.FFlagExpChatFixBackspaceNilTargetChannel
local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs

local FFlagExpChatDictation = SharedFlags.FFlagExpChatDictation
local FFlagExpChatContinuousDictation = SharedFlags.FFlagExpChatContinuousDictation
local FFlagExpChatTabShortcutNav = SharedFlags.FFlagExpChatTabShortcutNav
local enabled = FFlagExpChatDictation or FFlagExpChatContinuousDictation

local DictationInputBar = require(script.Parent.Dictation.DictationInputBar)
local useSendTelemetry = require(script.Parent.Dictation.useSendTelemetry)
local usePresetAutocompleteAnalytics = require(script.Parent.usePresetAutocompleteAnalytics)

local SocialExperiments = require(parent.SocialExperiments)
local ExpChatPresetChatAutocompleteExperimentation = SocialExperiments.ExpChatPresetChatAutocompleteExperimentation

local ActionBindableEvent = ExpChatShared.ActionBindableEvent
local focusNavigationStore = GetFocusNavigationStore(false)
local v2 = ExpChatShared.Flags.FIntPresetChatCooldownLuaMs / 1000

local function setTransparency(p, transparencyValue) -- 8 equivalent calls inferred from this helper
	return transparencyValue:map(function(p2: number)
		return p + p2 * (1 - p)
	end)
end

local v3 = nil
local v4 = nil
local v5 = nil
local child = nil
local child2 = nil

local function onChatInputBarFocusLost(onSelectionLost, keybinds, callback)
	local v6 = { Enum.KeyCode.ButtonB }
	local v7 = keybinds or v6
	local inputBeganConnection = nil
	inputBeganConnection = UserInputService.InputBegan:Connect(function(input)
		local keyCode

		if input then
			keyCode = input.KeyCode
		end

		for _, v8 in v7 do
			if keyCode == v8 then
				GuiService:SetMenuIsOpen(false, "ExperienceChat")
				callback()

				if onSelectionLost then
					onSelectionLost()
				else
					GuiService.SelectedCoreObject = nil
				end

				if not inputBeganConnection then
					break
				end

				inputBeganConnection:Disconnect()
				inputBeganConnection = nil
				break
			end
		end
	end)

	return inputBeganConnection
end

local function useEffectChatInputBarFocus(ref, ref2, ref3, callback, callback2)
	if FFlagConsoleChatUseChromeFocusUtils then
		React.useEffect(function()
			local v6 = {}
			local inputBeganConnection = nil

			local effect = Signals.createEffect(function(p)
				local chatInputBarFocused = focusNavigationStore.getChatInputBarFocused(p)
				local v7

				if ref2.current then
					v7 = ref2.current
				else
					v7 = ref.current
				end

				local selectedCoreObject = v7 or ref3.current

				if not selectedCoreObject then
					return
				end

				if chatInputBarFocused then
					GuiService:SetMenuIsOpen(true, "ExperienceChat")
					callback()
					GuiService.SelectedCoreObject = selectedCoreObject

					if not inputBeganConnection then
						inputBeganConnection = UserInputService.InputBegan:Connect(function(input)
							if input and v6[input.KeyCode] then
								FocusUtils.FocusOnChrome(function()
									focusNavigationStore.unfocusChatInputBar()
								end, "chat")
							end
						end)
					end
				elseif GuiService.MenuIsOpen then
					GuiService:SetMenuIsOpen(false, "ExperienceChat")
					callback2()

					if inputBeganConnection then
						inputBeganConnection:Disconnect()
						inputBeganConnection = nil
					end
				end
			end)

			return function()
				effect()

				if inputBeganConnection then
					inputBeganConnection:Disconnect()
					inputBeganConnection = nil
				end
			end
		end, {})
	elseif FFlagChromeChatGamepadSupportFix then
		React.useEffect(function()
			local connection = nil
			local thread = nil

			local function onEvent(data)
				local current

				if ref2.current then
					current = ref2.current
				else
					current = ref.current
				end

				if FFlagEnableConsoleExpControls and data.type == "ChatTopBarFocusSelect" and current then
					GuiService:SetMenuIsOpen(true, "ExperienceChat")
					callback()
					GuiService.SelectedCoreObject = current

					thread = task.delay(0, function()
						thread = nil

						if connection then
							connection:Disconnect()
						end

						connection = onChatInputBarFocusLost(data.onSelectionLost, data.keybinds, callback2)
					end)
				end
			end

			local eventConnection = ActionBindableEvent.Event:Connect(onEvent)

			return function()
				eventConnection:disconnect()

				if thread then
					task.cancel(thread)
					thread = nil
				end

				if connection then
					connection:Disconnect()
					connection = nil
				end
			end
		end, { ref.current, ref2.current })
	end
end

local function ChatInputBar(props)
	local ref = React.useRef("")

	if FFlagExpChatUseUnifiedTooltipStore then
		local setIsChatInputBarVisible = GetChatTooltipStore(false).setIsChatInputBarVisible

		React.useEffect(function()
			if props.visible == nil then
				setIsChatInputBarVisible(true)
			else
				setIsChatInputBarVisible(props.visible)
			end

			return function()
				setIsChatInputBarVisible(false)
			end
		end, { props.visible, setIsChatInputBarVisible })
	end

	local state, setState = React.useState("")
	local state2, setState2 = React.useState(0)
	local state3, setState3 = React.useState(0)
	local ref2

	if defineFastFlag5 then
		ref2 = React.useRef(false)
	else
		ref2 = nil
	end

	local state4, setState4 = React.useState(false)
	local state5, _ = React.useState(true)
	local targetChannelWidth, v6 = React.useBinding(0)
	local ref3 = React.useRef(false)
	local ref4 = React.useRef(nil)
	local ref5 = React.useRef(nil)
	local v7

	if enabled then
		v7 = useSendTelemetry({ enabled = enabled, textBoxRef = ref4, customTextBoxRef = ref5 })
	else
		v7 = nil
	end

	local ref6 = React.useRef(nil)
	local ref7 = React.useRef(nil)
	local ref8

	if FFlagExpChatEmojiDropdownDismissAnalytics then
		ref8 = React.useRef(nil)
	else
		ref8 = nil
	end

	local ref9 = React.useRef(nil)
	local ref10 = React.useRef(nil)
	local ref11 = React.useRef(false)
	local v8 = ReactFocusNavigation.useFocusGuiObject()

	local v9 = SignalsReact.useSignalState(focusNavigationStore.getChatInputBarFocused)

	local messagesStore = GetMessagesStore(false)
	local canLocalUserChatDerived = SignalsReact.useSignalState(messagesStore.getCanLocalUserChat)
	local v10

	if FFlagExpChatPresetChatEnabled then
		v10 = SignalsReact.useSignalState(GetPresetChatStore(false).getIsTrayOpen)
	else
		v10 = nil
	end

	local shouldTruncatePlaceholder

	if FFlagExpChatPresetChatEnabled then
		shouldTruncatePlaceholder = SignalsReact.useSignalState(GetPresetChatStore(false).getIsEnabled)
	end

	local ref12 = React.useRef(false)

	React.useEffect(function()
		ref5.current = props.chatInputBarSettings.TextBox
	end, { props.chatInputBarSettings.TextBox == nil and "nil" or props.chatInputBarSettings.TextBox })
	local focus

	if FFlagExpChatTabShortcutNav then
		local v11

		if props.chatInputBarSettings.TextBox == nil then
			v11 = ref4
		else
			v11 = ref5
		end

		focus = useFocusInputBar(v11).focus
		useInputBarTabNavigation(v11, props.userInputService)
	else
		focus = nil
	end

	React.useEffect(function()
		if FFlagExpChatTabShortcutNav then
			return Signals.createEffect(function(p)
				local chatInputBarFocusRequestTime = focusNavigationStore.getChatInputBarFocusRequestTime(p)

				if chatInputBarFocusRequestTime == nil then
					return
				end

				if os.clock() - chatInputBarFocusRequestTime <= 5 then
					focus()
				end

				focusNavigationStore.clearChatInputBarFocusRequest()
			end)
		end
	end, { focus })

	React.useEffect(function()
		if not props.autocompleteEnabled then
			return
		end

		local v11 = {}
		local descendantAddedConnection = TextChatService.DescendantAdded:Connect(function(textChatCommand)
			if textChatCommand:IsA("TextChatCommand") and string.sub(textChatCommand.PrimaryAlias, 1, 1) == "/" then
				v4 = AutocompleteText.new(initializeCommands)

				local autocompleteVisibleChangedConnection = textChatCommand:GetPropertyChangedSignal("AutocompleteVisible"):Connect(function()
					v4 = AutocompleteText.new(initializeCommands)
				end)
				table.insert(v11, autocompleteVisibleChangedConnection)
			end
		end)

		local descendantRemovingConnection = TextChatService.DescendantRemoving:Connect(function(textChatCommand)
			if textChatCommand:IsA("TextChatCommand") and string.sub(textChatCommand.PrimaryAlias, 1, 1) == "/" then
				v4 = AutocompleteText.new(initializeCommands)
			end
		end)

		if getEnableChatInputBarConfigurationAutocompleteEnabled() then
			v4 = AutocompleteText.new(initializeCommands)
			v3 = AutocompleteText.new(initializeEmojis)

			if GetFFlagTextChatEnableUniverseChatTabs() then
				v5 = AutocompleteText.new(initializeGlobalCommands)
			end

			local v12 = initialCommands()

			if v12 then
				for _, v13 in v12 do
					table.insert(v11, (v13:GetPropertyChangedSignal("AutocompleteVisible"):Connect(function()
						v4 = AutocompleteText.new(initializeCommands)
					end)))
				end
			end
		end

		return function()
			if descendantRemovingConnection then
				descendantRemovingConnection:Disconnect()
			end

			descendantAddedConnection:Disconnect()

			for _, connection in ipairs(v11) do
				connection:Disconnect()
			end

			table.clear(v11)
		end
	end, {})

	local useCallback = React.useCallback
	local function fn()
		v:trace("onSendActivated with input text: '{}'", state)

		local canLocalUserChatDerived2 = canLocalUserChatDerived

		if not (ref3.current and canLocalUserChatDerived2) then
			v:debug(
				"onSendActivated could not send message. isMounted: {} canLocalUserChat: {}",
				tostring(ref3.current),
				canLocalUserChatDerived2
			)
		elseif ref4.current or ref5.current then
			local text

			if ref5.current then
				text = ref5.current.Text
			else
				text = ref4.current.Text
			end

			local v11

			if v7 then
				v11 = v7.consumeOnSend(text)
			end

			local v12

			if GetFFlagTextChatEnableUniverseChatTabs() and props.isGlobalChatTabActive and props.onSendGlobalChat then
				v12 = props.onSendGlobalChat
			else
				v12 = props.onSendChat
			end

			if v12 and string.find(text, "%S") ~= nil then
				if FFlagExpChatDictation then
					v12(text, v11, v11 ~= nil)
				else
					v12(text)
				end
			else
				v:debug(
					"onSendActivated could not send message. text: '{}' canLocalUserChat: {}",
					text,
					canLocalUserChatDerived2
				)
			end

			if ref5.current then
				ref5.current.Text = ""
				ref5.current:ReleaseFocus()
			end

			if ref4.current then
				ref4.current.Text = ""
				ref4.current:ReleaseFocus()
			end

			setState("")

			local current = FFlagExpChatPresetChatGamepadEnabled and (ref5.current or ref4.current)

			if current then
				GuiService.SelectedCoreObject = current
			end

			if props.targetTextChannel and props.targetTextChannelDisplayName ~= "" then
				ref11.current = true
			end
		else
			v:debug("onSendActivated could not send message because textBoxRef.current was nil")
		end
	end

	local current = ref5.current

	local canLocalUserChat = props.canLocalUserChat
	local isGlobalChatTabActive = props.isGlobalChatTabActive
	local onSendChat = props.onSendChat or false
	local onSendGlobalChat = props.onSendGlobalChat or false
	local targetTextChannel = props.targetTextChannel or false
	local targetTextChannelDisplayName = props.targetTextChannelDisplayName
	local v11 = if v7 then v7.consumeOnSend else false
	local onSendActivated = useCallback(fn, {
		state,
		current,
		canLocalUserChatDerived,
		canLocalUserChat,
		isGlobalChatTabActive,
		onSendChat,
		onSendGlobalChat,
		targetTextChannel,
		targetTextChannelDisplayName,
		v11
	})
	local onSendRecordingTap

	if enabled then
		onSendRecordingTap = React.useCallback(function(p)
			if not (ref3.current and canLocalUserChatDerived) then
				return
			end

			local textSent = p and p.textSent or ""
			local v12

			if GetFFlagTextChatEnableUniverseChatTabs() and props.isGlobalChatTabActive and props.onSendGlobalChat then
				v12 = props.onSendGlobalChat
			else
				v12 = props.onSendChat
			end

			if v12 and string.find(textSent, "%S") ~= nil then
				v12(textSent, p, true)
			end

			if ref5.current then
				ref5.current.Text = ""
				ref5.current:ReleaseFocus()
			end

			if ref4.current then
				ref4.current.Text = ""
				ref4.current:ReleaseFocus()
			end

			setState("")

			local current2 = FFlagExpChatPresetChatGamepadEnabled and (ref5.current or ref4.current)

			if current2 then
				GuiService.SelectedCoreObject = current2
			end

			if props.targetTextChannel and props.targetTextChannelDisplayName ~= "" then
				ref11.current = true
			end
		end, {
			ref5.current,
			canLocalUserChatDerived,
			props.canLocalUserChat,
			props.isGlobalChatTabActive,
			props.onSendChat or false,
			props.onSendGlobalChat or false,
			props.targetTextChannel or false,
			props.targetTextChannelDisplayName
		})
	end

	local recordPresetChosen

	if FFlagExpChatPresetChatAutocompleteAnalyticsEnabled then
		recordPresetChosen = usePresetAutocompleteAnalytics({
			isFocused = state4,
			autocompleteEnabled = props.autocompleteEnabled,
			autocompleteDropdownReducer = props.autocompleteDropdownReducer
		}).recordPresetChosen
	else
		recordPresetChosen = nil
	end

	local function sendSelectedPreset(p: string)
		local presetChatStore = GetPresetChatStore(false)
		local presetIdForValue = PresetSearch.getPresetIdForValue(presetChatStore, p)

		if presetIdForValue == nil then
			v:warning("Could not resolve a preset id for autocomplete entry '{}'; skipping send.", p)
			return
		end

		presetChatStore.setPresetCooldownEndsAt(os.clock() + v2)

		local v12 = sendPreset(presetIdForValue, props.targetTextChannel)

		if v12 == "Sent" then
			local analytics = ExpChatShared.Analytics
			local expChatPresetActionConfig = ExpChatShared.Analytics.ExpChatPresetActionConfig
			local v13 = {
				event_type = Constants.Analytics.EventTypes.Click,
				component = 0,
				preset_id = 0
			}
			local component

			if FFlagExpChatPresetChatAutocompleteAnalyticsEnabled then
				component = Constants.Analytics.Components.AutocompleteDropdown
			else
				component = Constants.Analytics.Components.PresetAutocomplete
			end

			v13.component = component

			v13.preset_id = presetIdForValue
			local v14

			if FFlagExpChatPresetChatAutocompleteAnalyticsEnabled then
				v14 = Constants.Analytics.ExtendedStandardizedFields
			else
				v14 = ExpChatShared.Analytics.DefaultStandardizedFields
			end

			analytics:TelemetryLogEvent(expChatPresetActionConfig, v13, v14)
		else
			presetChatStore.setPresetCooldownEndsAt(nil)
			v:warning("Could not send preset {} from autocomplete: {}", presetIdForValue, v12)
		end
	end

	local useCallback2 = React.useCallback
	local function fn2(data)
		local v12

		if FFlagExpChatAutocompleteDropdownRedesign then
			v12 = props.autocompleteDropdownReducer.results[data.Parent.LayoutOrder]
		end

		local v13

		if
			FFlagExpChatPresetChatAutocompleteEnabled
			and props.autocompleteDropdownReducer.autocompleteType == "presets"
		then
			if FFlagExpChatAutocompleteDropdownRedesign then
				v13 = v12
			else
				v13 = PresetEntryText.undecorate(data.TextLabel.Text, props.chatInputBarSettings.TextSize)
			end
		end

		if FFlagExpChatPresetChatAutocompleteAnalyticsEnabled and recordPresetChosen ~= nil and v13 ~= nil then
			recordPresetChosen(v13)
		end

		if
			FFlagExpChatEmojiDropdownDismissAnalytics
			and ref8
			and props.autocompleteDropdownReducer.autocompleteType == "emojis"
		then
			local v14 = ref8
			local current2

			if FFlagExpChatAutocompleteDropdownRedesign then
				current2 = v12
			else
				current2 = data.TextLabel.Text
			end

			v14.current = current2
		end

		props.autocompleteDropdownActivated(false)
		props.autocompleteDropdownResultsChanged({})
		local current2

		if ref5.current then
			current2 = ref5.current
		else
			current2 = ref4.current
		end

		if current2 then
			local text = current2.Text

			local v14 = string.sub(text, 1, state2 - 1)
			local v15 = string.sub(text, state2, #text)
			local v16 = FFlagExpChatPresetChatAutocompleteEnabled and v13 ~= nil and "" or v15
			local text3 = ""

			if props.autocompleteDropdownReducer.autocompleteType == "emojis" then
				local text2 = data.EmojiLabel.Text

				text3 = string.gsub(v14, ":[^:]*$", text2)
			elseif props.autocompleteDropdownReducer.autocompleteType == "commands" then
				if not FFlagExpChatAutocompleteDropdownRedesign then
					v12 = data.TextLabel.Text
				end

				text3 = string.gsub(v14, "(/.*)", v12)
			end

			if v16 ~= "" then
				text3 ..= v16
			end

			current2.Text = text3
			setState(text3)

			if ref3.current then
				if defineFastFlag5 and ref2 and not current2:IsFocused() then
					ref2.current = true
				end

				current2:CaptureFocus()

				if v9 then
					v8(current2)
				end

				if v16 ~= "" and not defineFastFlag7 then
					current2.CursorPosition = #text3 - #v16 + 1
				end
			end

			props.autocompleteDropdownDeactivated()

			if FFlagExpChatPresetChatAutocompleteEnabled and v13 ~= nil then
				sendSelectedPreset(v13)
			end
		else
			v:error("Could not find textBox")
		end
	end

	local autocompleteDropdownActivated = props.autocompleteDropdownActivated
	local autocompleteDropdownDeactivated = props.autocompleteDropdownDeactivated
	local autocompleteType = props.autocompleteDropdownReducer and props.autocompleteDropdownReducer.autocompleteType
	local autocompleteDropdownResultsChanged = props.autocompleteDropdownResultsChanged
	local targetTextChannel2

	if FFlagExpChatPresetChatAutocompleteEnabled then
		targetTextChannel2 = props.targetTextChannel or false
	end

	local textSize

	if FFlagExpChatPresetChatAutocompleteEnabled then
		textSize = props.chatInputBarSettings.TextSize
	end

	local v12

	if FFlagExpChatPresetChatAutocompleteAnalyticsEnabled then
		v12 = recordPresetChosen
	end

	local v13

	if FFlagExpChatEmojiDropdownDismissAnalytics then
		v13 = ref8
	end

	local v14

	if FFlagExpChatAutocompleteDropdownRedesign then
		v14 = props.autocompleteDropdownReducer and props.autocompleteDropdownReducer.results
	end

	local onAutocompleteSelected = useCallback2(fn2, {
		v9,
		v8,
		state5,
		state2,
		autocompleteDropdownActivated,
		autocompleteDropdownDeactivated,
		autocompleteType,
		autocompleteDropdownResultsChanged,
		targetTextChannel2,
		textSize,
		v12,
		v13,
		v14
	})

	React.useEffect(function()
		if ref3.current then
			local current2

			if ref5.current then
				current2 = ref5.current
			else
				current2 = ref4.current
			end

			if current2 then
				current2:CaptureFocus()
			else
				v:error("Could not focus chat input bar because textBox not found")
			end
		end
	end, { props.shouldFocusChatInputBar, ref5.current })

	if FFlagExpChatPresetChatEnabled then
		React.useEffect(function()
			if not v10 then
				return
			end

			local current2

			if ref5.current then
				current2 = ref5.current
			else
				current2 = ref4.current
			end

			if current2 and current2:IsFocused() then
				current2:ReleaseFocus()
			end
		end, { v10 })
	end

	React.useEffect(function()
		v:trace("Mounted")
		ref3.current = true

		if defineFastFlag then
			IXPServiceWrapper:LogUserLayerExposure(defineFastString)
		end

		return function()
			v:trace("Unmounting")
			ref3.current = false
		end
	end, {})

	React.useEffect(function()
		local cursorPositionChangedConnection = nil

		if props.autocompleteEnabled then
			local current2

			if ref5.current then
				current2 = ref5.current
			else
				current2 = ref4.current
			end

			if current2 then
				cursorPositionChangedConnection = current2:GetPropertyChangedSignal("CursorPosition"):Connect(function()
					local cursorPosition = current2.CursorPosition

					if cursorPosition and cursorPosition ~= -1 then
						setState2(cursorPosition)
					end
				end)
			end
		end

		return function()
			if cursorPositionChangedConnection then
				cursorPositionChangedConnection:Disconnect()
			end
		end
	end, { ref5.current })

	React.useEffect(function()
		if not props.autocompleteEnabled then
			return function() end
		end

		ref10.current = props.userInputService.InputBegan:connect(function(p, _)
			if props.autocompleteDropdownReducer.activated and (Enum.KeyCode.Up or Enum.KeyCode.Down) then
				if p and p.KeyCode == Enum.KeyCode.Up and props.autocompleteDropdownReducer.selectedIndex > 1 then
					props.autocompleteDropdownSelectionChanged(props.autocompleteDropdownReducer.selectedIndex - 1)
				end

				if
					p
					and p.KeyCode == Enum.KeyCode.Down
					and props.autocompleteDropdownReducer.selectedIndex < #props.autocompleteDropdownReducer.results
				then
					props.autocompleteDropdownSelectionChanged(props.autocompleteDropdownReducer.selectedIndex + 1)
				end
			end
		end)

		return function()
			local current2 = ref10.current

			if current2 and current2.Connected then
				current2:Disconnect()
			end

			ref10.current = nil
		end
	end, { props.userInputService, props.autocompleteDropdownReducer })

	local useEffect = React.useEffect
	local function fn3()
		local v15 = GetFFlagTextChatEnableUniverseChatTabs() and not props.developerChannelTabsEnabled
		local v16

		if FFlagExpChatBackspaceExitsTargetChannelInGlobalTabs then
			v16 = not props.isChannelBarVisible or v15
		else
			v16 = not props.isChannelBarVisible
		end

		ref9.current = props.userInputService.InputEnded:connect(function(p, _)
			local v17

			if ref5.current then
				v17 = ref5.current and ref5.current:IsFocused() and p and p.KeyCode == Enum.KeyCode.Backspace
			else
				v17 = ref4.current and ref4.current:IsFocused() and p and p.KeyCode == Enum.KeyCode.Backspace
			end

			if v17 then
				local v18 = (props.targetTextChannelDisplayName or "") ~= ""

				if ref11.current and v16 and (not FFlagExpChatFixBackspaceNilTargetChannel or v18) then
					local resetTargetChannel = props.resetTargetChannel
					local v19

					if FFlagExpChatFixBackspaceNilTargetChannel then
						v19 = props.isGlobalChatTabActive
					end

					resetTargetChannel(v19)

					v:debug("ChatInputBar ChatInputBarResetTargetChannel()")
					ref11.current = false
				elseif state == "" then
					if not FFlagExpChatFixBackspaceNilTargetChannel then
						v18 = props.targetTextChannelDisplayName ~= ""
					end

					if v18 then
						ref11.current = true
					end
				end
			end
		end)

		return function()
			local current2 = ref9.current

			if current2 and current2.Connected then
				current2:Disconnect()
			end

			ref9.current = nil
		end
	end

	local userInputService = props.userInputService
	local current2 = ref5.current
	local isChannelBarVisible = props.isChannelBarVisible
	local targetTextChannelDisplayName2 = props.targetTextChannelDisplayName
	local resetTargetChannel = props.resetTargetChannel
	local developerChannelTabsEnabled

	if FFlagExpChatBackspaceExitsTargetChannelInGlobalTabs then
		developerChannelTabsEnabled = props.developerChannelTabsEnabled
	end

	local v15

	if FFlagExpChatFixBackspaceNilTargetChannel then
		v15 = props.isGlobalChatTabActive
	end

	useEffect(fn3, {
		userInputService,
		current2,
		isChannelBarVisible,
		targetTextChannelDisplayName2,
		resetTargetChannel,
		developerChannelTabsEnabled,
		v15
	})

	React.useEffect(function()
		local function handleAction(_: string, p, p2)
			if
				not props.isChatHotkeyEnabled
				or not p2
				or p2.KeyCode ~= Config.ChatInputBarDefaultFocusKeyCode and p2.KeyCode ~= props.devDefinedFocusKeyCode
			then
				return Enum.ContextActionResult.Pass
			end

			local current3

			if ref5.current then
				current3 = ref5.current
			else
				current3 = ref4.current
			end

			if not (current3 and p == Enum.UserInputState.Begin and current3 and not current3:IsFocused()) then
				return Enum.ContextActionResult.Pass
			end

			task.delay(0, function()
				current3:CaptureFocus()
			end)

			props.focusChatHotKeyActivated()

			ref12.current = true

			return Enum.ContextActionResult.Sink
		end

		props.contextActionService:BindCoreAction("FocusChat", handleAction, false, Enum.UserInputType.Keyboard)

		return function()
			props.contextActionService:UnbindCoreAction("FocusChat")
		end
	end, { props.isChatHotkeyEnabled, props.devDefinedFocusKeyCode, ref12.current, ref5.current })

	local function fn4(isFocusedWrite: boolean) -- 2 equivalent calls inferred from this helper
		local chatInputBarConfiguration = TextChatService:FindFirstChildOfClass("ChatInputBarConfiguration")

		if chatInputBarConfiguration then
			chatInputBarConfiguration.IsFocusedWrite = isFocusedWrite
		end
	end

	local onFocused = React.useCallback(function()
		setState4(true)
		props.onFocus()
		fn4(true) -- inferred equivalent call

		if defineFastFlag5 and ref2 then
			if ref2.current then
				ref2.current = false
			else
				ExpChatShared.Analytics:TelemetryLogEvent(
					ExpChatShared.Analytics.ExpChatPresetActionConfig,
					{
						event_type = Constants.Analytics.EventTypes.Click,
						component = Constants.Analytics.Components.MainInputBar
					},
					Constants.Analytics.ExtendedStandardizedFields
				)
			end
		end
	end, { props.onFocus })

	local onFocusLost = React.useCallback(function(_, flag: boolean, p)
		v:debug("Focus lost with enter: {}", (tostring(flag)))

		local current3 = ref7.current

		if flag or p and (p.KeyCode == Enum.KeyCode.Return or p.KeyCode == Enum.KeyCode.KeypadEnter) then
			if
				props.autocompleteEnabled
				and current3
				and props.autocompleteDropdownReducer.activated
				and #props.autocompleteDropdownReducer.results > 0
				and (not FFlagExpChatPresetChatAutocompleteEnabled or props.autocompleteDropdownReducer.selectedIndex > 0)
			then
				local offsetFrame = current3.ScrollBarFrame.ScrollViewFrame.ScrollView.OffsetFrame

				for _, child3 in ipairs(offsetFrame:GetChildren()) do
					if
						child3.ClassName == "Frame"
						and child3.LayoutOrder == props.autocompleteDropdownReducer.selectedIndex
					then
						onAutocompleteSelected(child3.TextLabelButton)
						return
					end
				end
			else
				onSendActivated()

				if
					FFlagExpChatPresetChatAutocompleteEnabled
					and props.autocompleteEnabled
					and props.autocompleteDropdownReducer.autocompleteType == "presets"
				then
					props.autocompleteDropdownDeactivated()
				end
			end
		end

		if ref3.current then
			if props.autocompleteEnabled and current3 and props.autocompleteDropdownReducer.activated then
				if p then
					if p.KeyCode == Enum.KeyCode.Escape then
						props.autocompleteDropdownActivated(false)
						local current4

						if ref5.current then
							current4 = ref5.current
						else
							current4 = ref4.current
						end

						if current4 then
							if defineFastFlag5 and ref2 and not current4:IsFocused() then
								ref2.current = true
							end

							current4:CaptureFocus()

							if not defineFastFlag7 then
								current4.CursorPosition = state2
							end

							return
						end

						v:error("Could not focus chat input bar because textBox not found")
					else
						local x = p.Position.X
						local y = p.Position.Y
						local x2 = current3.AbsolutePosition.X

						local v16 = x2 + current3.AbsoluteSize.X
						local y2 = current3.AbsolutePosition.Y

						local v17 = y2 + current3.AbsoluteSize.Y

						if x < x2 or v16 < x or y < y2 or v17 < y then
							props.autocompleteDropdownActivated(false)
						end
					end
				end
			else
				setState4(false)
			end
		end

		props.onUnfocus()
		fn4(false) -- inferred equivalent call

		if ref12.current then
			local localPlayer = Players.LocalPlayer

			if localPlayer then
				local textBox = Instance.new("TextBox")
				textBox.Visible = false
				textBox.Parent = localPlayer:FindFirstChildOfClass("PlayerGui")
				textBox:CaptureFocus()
				textBox:ReleaseFocus()
				textBox:Destroy()
			end

			ref12.current = false
		end
	end)

	React.useEffect(function()
		local connection = nil
		local thread = nil

		local function onEvent(data)
			local current3

			if FFlagEnableConsoleExpControls then
				if ref5.current then
					current3 = ref5.current
				else
					current3 = ref4.current
				end
			else
				current3 = nil
			end

			if data.type == "ChatTopBarFocusActivated" then
				if not FFlagEnableConsoleExpControls then
					if ref5.current then
						current3 = ref5.current
					else
						current3 = ref4.current
					end
				end

				if current3 then
					task.delay(0, function()
						current3:CaptureFocus()
					end)
				end
			elseif
				not FFlagChromeChatGamepadSupportFix
				and FFlagEnableConsoleExpControls
				and data.type == "ChatTopBarFocusSelect"
				and current3
			then
				GuiService:SetMenuIsOpen(true, "ExperienceChat")
				onFocused()
				GuiService.SelectedCoreObject = current3

				thread = task.delay(0, function()
					thread = nil

					if connection then
						connection:Disconnect()
					end

					connection = onChatInputBarFocusLost(data.onSelectionLost, data.keybinds, onFocusLost)
				end)
			end
		end

		local eventConnection = ActionBindableEvent.Event:Connect(onEvent)

		return function()
			eventConnection:disconnect()

			if thread then
				task.cancel(thread)
				thread = nil
			end

			if connection then
				connection:Disconnect()
				connection = nil
			end
		end
	end, { ref4.current, ref5.current })

	useEffectChatInputBarFocus(ref4, ref5, ref6, onFocused, onFocusLost)

	local function handlePresetAutocomplete(value: string, cursorPosition: number)
		if cursorPosition < 1 then
			return
		end

		local v16 = string.sub(value, 1, cursorPosition - 1)
		local v17

		if props.targetTextChannel == nil and not FFlagExpChatUniverseChatPresetEnabled then
			v17 = {}
		else
			local findMatchingPresets = PresetSearch.findMatchingPresets
			local presetChatStore = GetPresetChatStore(false)
			local v18

			if defineFastFlag4 then
				v18 = ExpChatPresetChatAutocompleteExperimentation.getSearchVariant()
			end

			v17 = findMatchingPresets(presetChatStore, v16, v18)
		end

		if #v17 == 0 then
			if props.autocompleteDropdownReducer.autocompleteType == "presets" then
				props.autocompleteDropdownDeactivated()
			end
		else
			props.autocompleteDropdownTypeChanged("presets")
			props.autocompleteDropdownActivated(true)
			local autocompleteDropdownResultsChanged2 = props.autocompleteDropdownResultsChanged

			if not FFlagExpChatAutocompleteDropdownRedesign then
				v16 = nil
			end

			autocompleteDropdownResultsChanged2(v17, v16)

			props.autocompleteDropdownSelectionChanged(0)
		end
	end

	local function handleAutocomplete(state6, text, p)
		if
			p == "/" and state6.CursorPosition == 2
			or props.autocompleteDropdownReducer.autocompleteType == "commands" and p ~= ":"
		then
			props.autocompleteDropdownTypeChanged("commands")
			props.autocompleteDropdownActivated(true)

			if p == "" or p == " " then
				props.autocompleteDropdownDeactivated()
			else
				local lower = string.sub(text, 1, state6.CursorPosition - 1):lower()
				local v16
				v16 = props.isGlobalChatTabActive and v5 or v4

				local results = v16:getResults(lower, sortCommandResultsCallback)
				local autocompleteDropdownResultsChanged2 = props.autocompleteDropdownResultsChanged
				local v17

				if FFlagExpChatAutocompleteDropdownRedesign then
					v17 = lower
				end

				autocompleteDropdownResultsChanged2(results, v17)

				if lower == results[1] then
					props.autocompleteDropdownActivated(false)
					props.autocompleteDropdownResultsChanged({})
				end
			end
		elseif
			(props.autocompleteDropdownReducer.activated or #props.autocompleteDropdownReducer.results > 0)
			and props.autocompleteDropdownReducer.autocompleteType == "emojis"
		then
			props.autocompleteDropdownActivated(true)
			local v16 = string.sub(text, 1, state6.CursorPosition - 1)
			local v17 = string.find(v16, ":[^:]*$")

			if p == "" or p == ":" or p == " " or not v17 then
				if p == ":" then
					if v17 == state3 then
						props.autocompleteDropdownResultsChanged({})
						return
					end

					local lower = string.sub(text, state3 + 1, state6.CursorPosition - 2):lower()

					if list.includes(props.autocompleteDropdownReducer.results, lower) then
						local v18 = string.sub(text, state6.CursorPosition, #text)
						local text2 = string.sub(text, 1, state6.CursorPosition - 2) .. v18
						state6.Text = text2
						setState(text2)

						if not defineFastFlag7 then
							state6.CursorPosition -= 1
						end

						local current3 = ref7.current

						if current3 then
							local offsetFrame = current3.ScrollBarFrame.ScrollViewFrame.ScrollView.OffsetFrame

							for _, child3 in ipairs(offsetFrame:GetChildren()) do
								if FFlagExpChatAutocompleteDropdownRedesign then
									if
										child3.ClassName == "Frame"
										and props.autocompleteDropdownReducer.results[child3.LayoutOrder] == lower
									then
										local textLabelButton = child3:FindFirstChild("TextLabelButton")

										if textLabelButton then
											onAutocompleteSelected(textLabelButton)
											return
										end
									end
								elseif child3.ClassName == "Frame" then
									local textLabelButton = child3:FindFirstChild("TextLabelButton")

									if textLabelButton then
										local textLabel = textLabelButton:FindFirstChild("TextLabel")

										if textLabel and textLabel.Text and textLabel.Text == lower then
											onAutocompleteSelected(textLabelButton)
											return
										end
									end
								end
							end
						end
					else
						props.autocompleteDropdownActivated(false)
						props.autocompleteDropdownResultsChanged({})
					end
				elseif p == " " then
					props.autocompleteDropdownActivated(false)
					props.autocompleteDropdownResultsChanged({})
				else
					props.autocompleteDropdownDeactivated()
					setState3(0)
				end
			else
				local lower = string.sub(text, v17 + 1, state6.CursorPosition - 1):lower()
				local v18 = not (lower and string.len(lower) > 1) and {}
					or v3:getResults(lower, sortEmojiResultsCallback)

				local autocompleteDropdownResultsChanged2 = props.autocompleteDropdownResultsChanged

				if not FFlagExpChatAutocompleteDropdownRedesign then
					lower = nil
				end

				autocompleteDropdownResultsChanged2(v18, lower)
			end
		else
			local v16 = string.find(text, ":[^:]*$")

			if p == ":" then
				props.autocompleteDropdownTypeChanged("emojis")
				props.autocompleteDropdownActivated(true)
				props.autocompleteDropdownResultsChanged({})
				setState3(v16)
			elseif FFlagExpChatPresetChatAutocompleteEnabled then
				handlePresetAutocomplete(text, state6.CursorPosition)
			end
		end
	end
	React.useEffect(function()
		if TextChatService.CreateDefaultCommands then
			child = TextChatService:FindFirstChild(RBXTeamCommand.name, true)
			child2 = TextChatService:FindFirstChild(RBXWhisperCommand.name, true)
		end
	end, {})

	local onTextChanged = React.useCallback(function(state6)
		local text = state6.Text

		if props.autocompleteEnabled then
			local v16 = string.find(text, "\r")
			local v17 = state6.CursorPosition < #text + 1

			if v16 then
				local text2 = string.gsub(text, "\r", "")
				state6.Text = text2
				setState(text2)

				if v17 then
					state6.CursorPosition -= 1
				end

				return
			end
		end

		local v16 = string.sub(text, state6.CursorPosition - 1, state6.CursorPosition - 1)
		v:trace("Input: {}", text)
		local v17

		if utf8.len(text) then
			v17 = utf8.len(utf8.nfcnormalize(text))
		else
			v17 = string.len(text)
		end

		if v17 and props.messageCharacterLimit < v17 then
			v:debug("Message is over the character limit of {}", (tostring(props.messageCharacterLimit)))
			state6.Text = state
		else
			setState(text)

			if getEnableChatInputBarConfigurationAutocompleteEnabled() and props.autocompleteEnabled then
				handleAutocomplete(state6, text, v16)
			end

			ref11.current = #text == 0 and ref11.current

			if defineFastFlag6 then
				if string.sub(text, 1, 1) == "/" and props.localPlayer and text ~= ref.current then
					ref.current = text

					local userId = props.localPlayer.UserId
					local v18 = {}

					if child and child.Enabled then
						table.insert(v18, autoCastCommand(RBXTeamCommand, userId, text))
					end

					if child2 and child2.Enabled then
						table.insert(v18, autoCastCommand(RBXWhisperCommand, userId, text))
					end

					local v19 = #v18 == 0 and { Promise.reject() } or v18

					Promise.any(v19):andThen(function()
						state6.Text = ""
						setState("")

						ref11.current = true
					end):catch(function(p)
						v:trace("Could not send autoCastCommand. Error: {}", p)
					end)
				elseif string.sub(text, 1, 1) ~= "/" then
					ref.current = ""
				end
			elseif props.localPlayer then
				local userId = props.localPlayer.UserId

				local v18 = {}

				if child and child.Enabled then
					table.insert(v18, autoCastCommand(RBXTeamCommand, userId, text))
				end

				if child2 and child2.Enabled then
					table.insert(v18, autoCastCommand(RBXWhisperCommand, userId, text))
				end

				local v19 = #v18 == 0 and { Promise.reject() } or v18

				Promise.any(v19):andThen(function()
					state6.Text = ""
					setState("")

					ref11.current = true
				end):catch(function(p)
					v:trace("Could not send autoCastCommand. Error: {}", p)
				end)
			end
		end
	end)

	local onReturnPressedFromOnScreenKeyboard = React.useCallback(function()
		local current3

		if ref5.current then
			current3 = ref5.current
		else
			current3 = ref4.current
		end

		if current3 then
			current3:ReleaseFocus(true)
		end
	end, { ref4.current, ref5.current })

	local v16 = React.useCallback(function(p)
		v6(p.Visible and p.AbsoluteSize.X or 0)
	end)

	local v17 = useCursor()

	local onAutocompleteDropdownHover = React.useCallback(function(p)
		props.autocompleteDropdownSelectionChanged(p.LayoutOrder)
	end)
	local hasEmptyInputText = state == ""
	local showPlaceholderText = hasEmptyInputText and not state4
	local chatInputBarSettings = props.chatInputBarSettings
	local chatWindowSettings = props.chatWindowSettings
	local canLocalUserChat2

	if canLocalUserChatDerived == nil then
		canLocalUserChat2 = props.canLocalUserChat
	else
		canLocalUserChat2 = canLocalUserChatDerived
	end

	React.useEffect(function()
		if defineFastFlag2 and canLocalUserChat2 then
			IXPServiceWrapper:LogUserLayerExposure(defineFastString2)
		end
	end, { canLocalUserChat2 })

	React.useEffect(function()
		if not (defineFastFlag3 and state4 and (getEnableChatInputBarConfigurationAutocompleteEnabled() and props.autocompleteEnabled)) then
			return
		end

		local presetChatStore = GetPresetChatStore(false)

		if
			not presetChatStore.getIsEnabled(false)
			or presetChatStore.getAccessLevel(false) ~= Constants.AccessLevel.Enabled
		then
			return
		end

		IXPServiceWrapper:LogFlagLinkedUserLayerExposure(defineFastString3)
	end, { state4, props.autocompleteEnabled, shouldTruncatePlaceholder })

	React.useEffect(function()
		if not (fFlagExpChatPresetChatSendEnabled and state4 and (getEnableChatInputBarConfigurationAutocompleteEnabled() and props.autocompleteEnabled)) then
			return
		end

		local presetChatStore = GetPresetChatStore(false)

		if
			not presetChatStore.getIsEnabled(false)
			or presetChatStore.getAccessLevel(false) ~= Constants.AccessLevel.Enabled
		then
			return
		end

		ExpChatPresetChatAutocompleteExperimentation.logExposure()
	end, { state4, props.autocompleteEnabled, shouldTruncatePlaceholder })

	local backgroundTransparency = useInterpolatedClientSettings(chatInputBarSettings).BackgroundTransparency
	local backgroundTransparency2 = useInterpolatedClientSettings(chatWindowSettings).BackgroundTransparency
	local backgroundColor3 = useInterpolatedClientSettings(chatWindowSettings).BackgroundColor3

	local isSpatialUIEnabled = props.isSpatialUIEnabled

	local createElement = React.createElement
	local v18 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = backgroundColor3,
		BackgroundTransparency = FFlagExpChatNewInputBar and 1 or setTransparency( -- inferred equivalent call
			backgroundTransparency2,
			props.transparencyValue
		),
		BorderSizePixel = 0,
		LayoutOrder = props.LayoutOrder,
		Size = props.size,
		Visible = props.visible,
		ZIndex = 2,
		[React.Event.MouseEnter] = props.onHovered,
		[React.Event.MouseLeave] = props.onUnhovered,
		[React.Change.AbsoluteSize] = React.useCallback(function(p)
			local chatInputBarConfiguration = TextChatService:FindFirstChildOfClass("ChatInputBarConfiguration")

			if chatInputBarConfiguration and props.onAbsoluteSizeChanged then
				props.onAbsoluteSizeChanged(p, chatInputBarConfiguration)
			end
		end),
		[React.Change.AbsolutePosition] = React.useCallback(function(p)
			local chatInputBarConfiguration = TextChatService:FindFirstChildOfClass("ChatInputBarConfiguration")

			if chatInputBarConfiguration and props.onAbsolutePositionChanged then
				props.onAbsolutePositionChanged(p, chatInputBarConfiguration)
			end
		end)
	}
	local autocompleteDropdown

	if getEnableChatInputBarConfigurationAutocompleteEnabled() and props.autocompleteEnabled then
		local createElement2 = React.createElement
		local v19 = {
			chatInputBarSettings = chatInputBarSettings,
			chatWindowSettings = chatWindowSettings,
			setTransparency = setTransparency,
			transparencyValue = props.transparencyValue,
			activated = props.autocompleteDropdownReducer.activated and state4,
			isChatInputBarVisible = 0,
			chosenEmojiForAnalyticsRef = 0,
			results = 0,
			query = 0,
			selectedIndex = 0,
			autocompleteType = 0,
			onAutocompleteDropdownHover = 0,
			onAutocompleteSelected = 0,
			autocompleteDropdownRef = 0,
			textBoxRef = 0
		}
		local isChatInputBarVisible

		if FFlagExpChatEmojiDropdownShowAnalytics then
			isChatInputBarVisible = props.visible
		end

		v19.isChatInputBarVisible = isChatInputBarVisible
		local chosenEmojiForAnalyticsRef

		if FFlagExpChatEmojiDropdownDismissAnalytics then
			chosenEmojiForAnalyticsRef = ref8
		end

		v19.chosenEmojiForAnalyticsRef = chosenEmojiForAnalyticsRef

		v19.results = props.autocompleteDropdownReducer.results
		local query

		if FFlagExpChatAutocompleteDropdownRedesign then
			query = props.autocompleteDropdownReducer.query
		end

		v19.query = query

		v19.selectedIndex = props.autocompleteDropdownReducer.selectedIndex
		v19.autocompleteType = props.autocompleteDropdownReducer.autocompleteType
		v19.onAutocompleteDropdownHover = onAutocompleteDropdownHover
		v19.onAutocompleteSelected = onAutocompleteSelected
		v19.autocompleteDropdownRef = ref7
		local textBoxRef

		if chatInputBarSettings.TextBox then
			textBoxRef = ref5
		else
			textBoxRef = ref4
		end

		v19.textBoxRef = textBoxRef
		autocompleteDropdown = createElement2(AutocompleteDropdown, v19) or nil
	end

	local children = {
		AutocompleteDropdown = autocompleteDropdown,
		UISizeConstraint = React.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(Config.ChatWindowMaxWidth, 1e999)
		}),
		UIPadding = 0,
		ChatInputBarV2 = 0,
		Background = 0
	}

	local createElement2 = React.createElement
	local paddingLeft

	if not FFlagExpChatNewInputBar then
		paddingLeft = UDim.new(0, 8)
	end

	local paddingRight

	if not FFlagExpChatNewInputBar then
		paddingRight = UDim.new(0, 8)
	end

	children.UIPadding = createElement2("UIPadding", {
		PaddingLeft = paddingLeft,
		PaddingRight = paddingRight,
		PaddingTop = props.addTopPadding and UDim.new(0, 8) or UDim.new(0, 0),
		PaddingBottom = UDim.new(0, 1)
	})
	local chatInputBarV

	if FFlagExpChatNewInputBar then
		if FFlagExpChatNewInputBarDictation and enabled and canLocalUserChat2 then
			local createElement3 = React.createElement
			local v19 = {}
			v19.transparencyValue = props.transparencyValue
			v19.sendButtonContainerWidth = props.sendButtonContainerWidth
			v19.resetTargetChannel = props.resetTargetChannel
			v19.targetTextChannel = props.targetTextChannel
			v19.targetTextChannelDisplayName = props.targetTextChannelDisplayName
			v19.isChannelBarVisible = props.isChannelBarVisible
			v19.developerChannelTabsEnabled = props.developerChannelTabsEnabled
			v19.canLocalUserChat = props.canLocalUserChat
			v19.disabledChatPlaceholderText = props.disabledChatPlaceholderText
			v19.placeholderText = props.placeholderText
			v19.setTransparency = setTransparency
			v19.chatInputBarSettings = chatInputBarSettings
			v19.chatInputBarBackgroundTransparency = backgroundTransparency
			v19.isSpatialUIEnabled = isSpatialUIEnabled
			v19.canLocalUserChatDerived = canLocalUserChatDerived
			v19.targetChannelWidth = targetChannelWidth
			v19.showPlaceholderText = showPlaceholderText
			v19.hasEmptyInputText = hasEmptyInputText

			if not FFlagExpChatPresetChatEnabled then
				shouldTruncatePlaceholder = nil
			end

			v19.shouldTruncatePlaceholder = shouldTruncatePlaceholder
			v19.cursor = v17
			v19.placeholderRef = ref6
			v19.textBoxRef = ref4
			v19.customTextBoxRef = ref5
			v19.onAbsoluteSizeChanged = v16
			v19.onFocused = onFocused
			v19.onFocusLost = onFocusLost
			v19.onTextChanged = onTextChanged
			v19.onReturnPressedFromOnScreenKeyboard = onReturnPressedFromOnScreenKeyboard
			v19.onSendActivated = onSendActivated
			v19.onSendRecordingTap = onSendRecordingTap
			local onTranscriptionStaged

			if v7 then
				onTranscriptionStaged = v7.stageTranscription
			end

			v19.onTranscriptionStaged = onTranscriptionStaged
			v19.inputText = state
			v19.setInputText = setState
			v19.isGlobalChatTabActive = props.isGlobalChatTabActive
			v19.onDictationActivityChanged = props.onDictationActivityChanged
			v19.onDictationStateChanged = props.onDictationStateChanged
			chatInputBarV = createElement3(ChatInputBarV2Dictation, v19)
		else
			local createElement3 = React.createElement
			local v19 = {
				transparencyValue = props.transparencyValue,
				sendButtonContainerWidth = props.sendButtonContainerWidth,
				resetTargetChannel = props.resetTargetChannel,
				targetTextChannel = props.targetTextChannel,
				targetTextChannelDisplayName = props.targetTextChannelDisplayName,
				isChannelBarVisible = props.isChannelBarVisible,
				developerChannelTabsEnabled = props.developerChannelTabsEnabled,
				canLocalUserChat = props.canLocalUserChat,
				disabledChatPlaceholderText = props.disabledChatPlaceholderText,
				placeholderText = props.placeholderText,
				setTransparency = setTransparency,
				chatInputBarSettings = chatInputBarSettings,
				chatInputBarBackgroundTransparency = backgroundTransparency,
				isSpatialUIEnabled = isSpatialUIEnabled,
				canLocalUserChatDerived = canLocalUserChatDerived,
				targetChannelWidth = targetChannelWidth,
				showPlaceholderText = showPlaceholderText,
				hasEmptyInputText = hasEmptyInputText,
				shouldTruncatePlaceholder = 0,
				cursor = 0,
				placeholderRef = 0,
				textBoxRef = 0,
				customTextBoxRef = 0,
				onAbsoluteSizeChanged = 0,
				onFocused = 0,
				onFocusLost = 0,
				onTextChanged = 0,
				onReturnPressedFromOnScreenKeyboard = 0,
				onSendActivated = 0,
				isGlobalChatTabActive = 0
			}

			if not FFlagExpChatPresetChatEnabled then
				shouldTruncatePlaceholder = nil
			end

			v19.shouldTruncatePlaceholder = shouldTruncatePlaceholder
			v19.cursor = v17
			v19.placeholderRef = ref6
			v19.textBoxRef = ref4
			v19.customTextBoxRef = ref5
			v19.onAbsoluteSizeChanged = v16
			v19.onFocused = onFocused
			v19.onFocusLost = onFocusLost
			v19.onTextChanged = onTextChanged
			v19.onReturnPressedFromOnScreenKeyboard = onReturnPressedFromOnScreenKeyboard
			v19.onSendActivated = onSendActivated
			local isGlobalChatTabActive2

			if FFlagExpChatFixBackspaceNilTargetChannel then
				isGlobalChatTabActive2 = props.isGlobalChatTabActive
			end

			v19.isGlobalChatTabActive = isGlobalChatTabActive2
			chatInputBarV = createElement3(ChatInputBarV2, v19)
		end
	end

	children.ChatInputBarV2 = chatInputBarV
	local background

	if not FFlagExpChatNewInputBar then
		if enabled and canLocalUserChat2 then
			local createElement3 = React.createElement
			local v19 = {}
			v19.chatInputBarSettings = chatInputBarSettings
			v19.transparencyValue = props.transparencyValue
			v19.chatInputBarBackgroundTransparency = backgroundTransparency
			v19.inputText = state
			v19.setInputText = setState
			v19.canLocalUserChat = canLocalUserChat2
			v19.disabledChatPlaceholderText = props.disabledChatPlaceholderText
			v19.targetChannelWidth = targetChannelWidth
			v19.showPlaceholderText = showPlaceholderText
			v19.placeholderText = props.placeholderText
			v19.cursor = v17
			v19.placeholderRef = ref6
			v19.textBoxRef = ref4
			v19.customTextBoxRef = ref5
			v19.onFocused = onFocused
			v19.onFocusLost = onFocusLost
			v19.onTextChanged = onTextChanged
			v19.onReturnPressedFromOnScreenKeyboard = onReturnPressedFromOnScreenKeyboard
			v19.onChannelChipAbsoluteSizeChanged = v16
			v19.onChannelChipActivated = FFlagExpChatFixBackspaceNilTargetChannel and function()
				props.resetTargetChannel(props.isGlobalChatTabActive)
			end or props.resetTargetChannel
			v19.targetTextChannel = props.targetTextChannel
			v19.targetTextChannelDisplayName = props.targetTextChannelDisplayName or ""
			v19.isChannelBarVisible = props.isChannelBarVisible
			v19.isGlobalChatTabActive = props.isGlobalChatTabActive
			v19.developerChannelTabsEnabled = props.developerChannelTabsEnabled
			v19.onDictationActivityChanged = props.onDictationActivityChanged
			v19.onDictationStateChanged = props.onDictationStateChanged
			v19.onSendActivated = onSendActivated
			v19.onSendRecordingTap = onSendRecordingTap
			local onTranscriptionStaged

			if v7 then
				onTranscriptionStaged = v7.stageTranscription
			end

			v19.onTranscriptionStaged = onTranscriptionStaged
			v19.isSpatialUIEnabled = isSpatialUIEnabled
			v19.isTextBoxSelectable = FFlagEnableConsoleExpControls and true or nil
			v19.isPlaceholderSelectable = true
			v19.placeholderSelectionImageObject = v17
			background = createElement3(DictationInputBar, v19)
		else
			local createElement3 = React.createElement
			local v19 = {
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundColor3 = chatInputBarSettings.BackgroundColor3,
				BackgroundTransparency = FFlagExpChatNewInputBar and 1 or setTransparency( -- inferred equivalent call
					backgroundTransparency,
					props.transparencyValue
				),
				Size = UDim2.new(1, 0, 0, 0)
			}
			local children2 = {
				Border = React.createElement("UIStroke", {
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = Config.ChatInputBarBorderColor3,
					Transparency = setTransparency(Config.ChatInputBarBorderTransparency, props.transparencyValue) -- inferred equivalent call
				}),
				Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 3) }),
				Container = 0
			}

			local createElement4 = React.createElement
			local v20 = {
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.fromScale(1, 0),
				BackgroundTransparency = 1
			}

			local createElement5 = React.createElement
			local v21 = {
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -props.sendButtonContainerWidth, 0, 0)
			}
			local children3 = {
				TargetChannelChip = React.createElement(ChannelChip, {
					transparency = setTransparency(0, props.transparencyValue), -- inferred equivalent call
					onAbsoluteSizeChanged = v16,
					onChannelChipActivated = FFlagExpChatFixBackspaceNilTargetChannel and function()
						props.resetTargetChannel(props.isGlobalChatTabActive)
					end or props.resetTargetChannel,
					targetTextChannelDisplayName = props.targetTextChannelDisplayName or "",
					isChannelBarVisible = props.isChannelBarVisible,
					developerChannelTabsEnabled = props.developerChannelTabsEnabled
				}),
				DisabledPlaceholderLabel = 0,
				TextBoxContainer = 0,
				UIPadding = 0
			}

			local disabledPlaceholderLabel = not canLocalUserChatDerived

			if disabledPlaceholderLabel then
				local createElement6 = React.createElement
				local v22 = {
					AnchorPoint = Vector2.new(1, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					Font = Config.ChatInputBarFont,
					Text = props.disabledChatPlaceholderText,
					Position = UDim2.fromScale(1, 0),
					Size = targetChannelWidth:map(function(p: number)
						return UDim2.new(1, -(p + 8), 0, 0)
					end),
					TextColor3 = showPlaceholderText and chatInputBarSettings.PlaceholderColor3 or chatInputBarSettings.TextColor3,
					TextSize = 0,
					TextTransparency = 0,
					Selectable = true,
					SelectionImageObject = 0,
					TextWrapped = true,
					TextXAlignment = 0,
					TextYAlignment = 0,
					ref = 0
				}
				local textSize2

				if isSpatialUIEnabled then
					textSize2 = chatInputBarSettings.SpatialPanelTextSize
				else
					textSize2 = chatInputBarSettings.TextSize
				end

				v22.TextSize = textSize2

				v22.TextTransparency = setTransparency(showPlaceholderText and 0.5 or 0, props.transparencyValue) -- inferred equivalent call

				v22.SelectionImageObject = v17

				v22.TextXAlignment = Enum.TextXAlignment.Left
				v22.TextYAlignment = Enum.TextYAlignment.Top
				v22.ref = ref6
				disabledPlaceholderLabel = createElement6("TextLabel", v22)
			end

			children3.DisabledPlaceholderLabel = disabledPlaceholderLabel
			local textBoxContainer

			if canLocalUserChatDerived then
				local createElement6 = React.createElement
				local v22 = {
					AnchorPoint = Vector2.new(1, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					Position = UDim2.fromScale(1, 0),
					Size = targetChannelWidth:map(function(p: number)
						return UDim2.new(1, -(p + 8), 0, 0)
					end)
				}
				local textBox

				if canLocalUserChatDerived then
					local createElement7 = React.createElement
					local v23 = {}
					v23.AnchorPoint = Vector2.new(0, 0)
					v23.AutomaticSize = Enum.AutomaticSize.XY
					v23.BackgroundTransparency = 1
					v23.ClearTextOnFocus = false
					v23.FontFace = chatInputBarSettings.FontFace
					v23.PlaceholderText = showPlaceholderText and props.placeholderText or ""
					v23.Selectable = FFlagEnableConsoleExpControls and true or nil
					v23.SelectionImageObject = v17
					v23.Size = UDim2.fromScale(1, 0)
					v23.Text = ""
					v23.PlaceholderColor3 = chatInputBarSettings.PlaceholderColor3
					v23.TextColor3 = chatInputBarSettings.TextColor3
					local textSize2

					if isSpatialUIEnabled then
						textSize2 = chatInputBarSettings.SpatialPanelTextSize
					else
						textSize2 = chatInputBarSettings.TextSize
					end

					v23.TextSize = textSize2

					v23.TextTransparency = setTransparency(showPlaceholderText and 0.5 or 0, props.transparencyValue) -- inferred equivalent call

					v23.TextStrokeTransparency = setTransparency( -- inferred equivalent call
						chatInputBarSettings.TextStrokeTransparency,
						props.transparencyValue
					)

					v23.TextStrokeColor3 = chatInputBarSettings.TextStrokeColor3
					v23.TextWrapped = true
					v23.TextXAlignment = Enum.TextXAlignment.Left
					v23.TextYAlignment = Enum.TextYAlignment.Top
					v23.ZIndex = 2

					v23[React.Event.Focused] = onFocused
					v23[React.Event.FocusLost] = onFocusLost
					v23[React.Change.Text] = onTextChanged
					v23[React.Event.ReturnPressedFromOnScreenKeyboard] = onReturnPressedFromOnScreenKeyboard
					local ref13

					if chatInputBarSettings.TextBox then
						ref13 = ref5
					else
						ref13 = ref4
					end

					v23.ref = ref13
					textBox = createElement7("TextBox", v23)
				else
					textBox = canLocalUserChatDerived
				end

				textBoxContainer = createElement6("Frame", v22, { TextBox = textBox })
			else
				textBoxContainer = canLocalUserChatDerived
			end

			children3.TextBoxContainer = textBoxContainer

			children3.UIPadding = React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, 10),
				PaddingLeft = UDim.new(0, 10),
				PaddingRight = UDim.new(0, 10),
				PaddingTop = UDim.new(0, 10)
			})
			children2.Container = createElement4("Frame", v20, {
				TextContainer = createElement5("Frame", v21, children3),
				SendButton = React.createElement("TextButton", {
					AnchorPoint = Vector2.new(1, 0),
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					Position = UDim2.fromScale(1, 0),
					Selectable = false,
					Size = UDim2.new(0, props.sendButtonContainerWidth, 1, 0),
					Text = "",
					[React.Event.Activated] = onSendActivated
				}, {
					Layout = React.createElement("UIListLayout", {
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center
					}),
					SendIcon = React.createElement(ImageSetLabel, {
						BackgroundTransparency = 1,
						ImageColor3 = hasEmptyInputText and chatInputBarSettings.PlaceholderColor3 or chatInputBarSettings.TextColor3,
						ImageTransparency = setTransparency(hasEmptyInputText and 0.5 or 0, props.transparencyValue), -- inferred equivalent call
						Image = Images["icons/actions/send"],
						Size = UDim2.new(0, 30, 0, 30),
						ZIndex = 2
					})
				})
			})
			background = createElement3("Frame", v19, children2)
		end
	end

	children.Background = background
	return createElement("Frame", v18, children)
end

local v6 = Localization.connect(function(p)
	local targetTextChannelDisplayName = nil

	if p.targetTextChannel then
		for k, v6 in pairs({
			RBXTeam = "CoreScripts.TextChat.TeamChat.PrefixText",
			RBXWhisper = "CoreScripts.TextChat.WhisperChat.PrefixText.Outgoing"
		}) do
			if not string.match(p.targetTextChannel.Name, k) then
				continue
			end

			if k == "RBXWhisper" then
				local otherDisplayNameInWhisperChannel = getOtherDisplayNameInWhisperChannel(
					p.targetTextChannel,
					p.localPlayer
				)

				if otherDisplayNameInWhisperChannel then
					targetTextChannelDisplayName = {
						v6,
						{ RBX_NAME = otherDisplayNameInWhisperChannel }
					}
				end
			else
				targetTextChannelDisplayName = v6
			end
		end
	end

	return { targetTextChannelDisplayName = targetTextChannelDisplayName }
end)(ChatInputBar)

return React.memo(v6)
