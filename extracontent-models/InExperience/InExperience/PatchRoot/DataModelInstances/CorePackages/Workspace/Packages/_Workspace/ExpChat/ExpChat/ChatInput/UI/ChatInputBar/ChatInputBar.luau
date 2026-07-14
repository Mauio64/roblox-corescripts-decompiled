local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local FocusNavigationUtils = require(ExpChatParent.FocusNavigationUtils)
local React = require(ExpChatParent.React)
local ReactFocusNavigation = require(ExpChatParent.ReactFocusNavigation)
local ExpChatShared = require(ExpChatParent.ExpChatShared)
local FocusUtils = require(ExpChatParent.Chrome).FocusUtils
local GetMessagesStore = require(ExpChat.Stores.GetMessagesStore)
local IXPServiceWrapper = require(ExpChat.IXPServiceWrapper)
local GetChatTooltipStore = require(ExpChat.Stores.GetChatTooltipStore)
local UIBlox = require(ExpChatParent.UIBlox)
local Promise = require(ExpChatParent.Promise)
local Signals = require(ExpChatParent.Signals)
local SignalsReact = require(ExpChatParent.SignalsReact)
local List = require(ExpChatParent.llama).List
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useCursor = UIBlox.App.SelectionCursor.useCursor
local useInterpolatedClientSettings = require(ExpChat.ClientSettings.useInterpolatedClientSettings)
local Config = require(ExpChat.Config)
local GetFocusNavigationStore = require(ExpChat.Stores.GetFocusNavigationStore)
local GetPresetChatStore = require(ExpChat.Stores.GetPresetChatStore)
local v27 = ExpChatShared.Logger:new("ExpChat/" .. script.Name)
local autoCastCommand = ExpChatShared.Commands.autoCastCommand
local RBXWhisperCommand = ExpChatShared.Commands.Whisper.RBXWhisperCommand
local RBXTeamCommand = ExpChatShared.Commands.RBXTeamCommand
local Localization = require(ExpChat.Localization)
local getOtherDisplayNameInWhisperChannel = require(ExpChat.getOtherDisplayNameInWhisperChannel)
local ChannelChip = require(script.Parent.ChannelChip)
local AutocompleteText = require(ExpChat.Autocomplete.AutocompleteText)
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
local FFlagExpChatUseUnifiedTooltipStore = ExpChatShared.Flags.FFlagExpChatUseUnifiedTooltipStore
local FFlagExpChatNewInputBar = require(ExpChat.Flags.FFlagExpChatNewInputBar)
local FFlagExpChatNewInputBarDictation = require(ExpChat.Flags.FFlagExpChatNewInputBarDictation)
local FFlagExpChatPresetChatGamepadEnabled = require(ExpChat.Flags.FFlagExpChatPresetChatGamepadEnabled)
local v50 = game:DefineFastFlag("ExpChatPresetChatIXPExposure", false)
local v51 = game:DefineFastString("ExpChatPresetChatIXPLayerName", "UniverseChat.PresetChat")
local v52 = game:DefineFastFlag("ExpChatDictationIXPExposure", false)
local v53 = game:DefineFastString("ExpChatDictationIXPLayerName", "UniverseChat.Dictation")
local getEnableChatInputBarConfigurationAutocompleteEnabled = require(ExpChat.Flags.getEnableChatInputBarConfigurationAutocompleteEnabled)
local SharedFlags = require(ExpChatParent.SharedFlags)
local FFlagExpChatUseMessagesStore = SharedFlags.FFlagExpChatUseMessagesStore
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local FFlagChromeChatGamepadSupportFix = SharedFlags.FFlagChromeChatGamepadSupportFix
local FFlagConsoleChatUseChromeFocusUtils = SharedFlags.FFlagConsoleChatUseChromeFocusUtils
local FFlagExpChatEnableFocusNavigation = require(ExpChat.Flags.FFlagExpChatEnableFocusNavigation)
local FFlagExpChatFocusViaLastModeFix = require(ExpChat.Flags.FFlagExpChatFocusViaLastModeFix)
local v62 = game:DefineFastFlag("ChatOptimizeCommandProcessing", false)
local v63 = game:DefineFastFlag("ExpChatFocusablePlaceholderText", false)
local v64 = game:DefineFastFlag("ExpChatDoNotSetCursorPosition", false)
local FFlagExpChatBackspaceExitsTargetChannelInGlobalTabs = require(ExpChat.Flags.FFlagExpChatBackspaceExitsTargetChannelInGlobalTabs)
local FFlagExpChatFixBackspaceNilTargetChannel = ExpChatShared.Flags.FFlagExpChatFixBackspaceNilTargetChannel
local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs
local FFlagExpChatDictation = SharedFlags.FFlagExpChatDictation
local FFlagExpChatContinuousDictation = SharedFlags.FFlagExpChatContinuousDictation
local v70 = FFlagExpChatDictation or FFlagExpChatContinuousDictation
local DictationInputBar = require(script.Parent.Dictation.DictationInputBar)
local useSendTelemetry = require(script.Parent.Dictation.useSendTelemetry)
local ActionBindableEvent = ExpChatShared.ActionBindableEvent
local v74 = GetFocusNavigationStore(false)

local function setTransparency(p1, p2) -- line: 99
	return p2:map(function(n1: number) -- line: 100
		-- upvalues: p1 (copy)
		return p1 + n1 * (1 - p1)
	end)
end

local u76 = nil
local u77 = nil
local u78 = nil
local RBXTeamCommandname = nil
local RBXWhisperCommandname = nil

local function onChatInputBarFocusLost(p3: ((...any) -> ...any)?, t1: {[any]: any}?, p4) -- line: 111
	-- upvalues: UserInputService (copy), GuiService (copy)
	local t2 = { Enum.KeyCode.ButtonB }
	local v91 = t1 or t2
	local u92 = nil

	u92 = UserInputService.InputBegan:Connect(function(input) -- line: 115
		-- upvalues: v91 (copy), GuiService (copy), p4 (copy), p3 (copy), u92 (ref)
		local v202 = if not input then nil else input.KeyCode

		for _, v204 in v91 do
			if v202 == v204 then
				GuiService:SetMenuIsOpen(false, "ExperienceChat")
				p4()

				if p3 then
					p3()
				else
					GuiService.SelectedCoreObject = nil
				end

				if not u92 then
					return
				end

				u92:Disconnect()
				u92 = nil

				return
			end
		end
	end)

	return u92
end
local function useEffectChatInputBarFocus(p5, p6, p7, p8, p9) -- line: 139
	-- upvalues: FFlagConsoleChatUseChromeFocusUtils (copy), React (copy), FFlagExpChatEnableFocusNavigation (copy), Signals (copy), v74 (copy), v63 (copy), GuiService (copy), UserInputService (copy), FocusUtils (copy), FFlagChromeChatGamepadSupportFix (copy), FFlagEnableConsoleExpControls (copy), onChatInputBarFocusLost (copy), ActionBindableEvent (copy)
	if FFlagConsoleChatUseChromeFocusUtils then
		React.useEffect(function() -- line: 141
			-- upvalues: FFlagExpChatEnableFocusNavigation (copy), Signals (copy), v74 (copy), p6 (copy), p5 (copy), v63 (copy), p7 (copy), GuiService (copy), p8 (copy), UserInputService (copy), FocusUtils (copy), p9 (copy)
			local t3 = {
				[Enum.KeyCode.DPadUp] = not FFlagExpChatEnableFocusNavigation or nil
			}
			local connection = nil
			local v207 = Signals.createEffect(function(p10) -- line: 147
				-- upvalues: v74 (copy), p6 (copy), p5 (copy), v63 (copy), p7 (copy), GuiService (copy), p8 (copy), connection (ref), UserInputService (copy), t3 (copy), FocusUtils (copy), p9 (copy)
				local v314 = v74.getChatInputBarFocused(p10)
				local v315 = if not p6.current then p5.current else p6.current

				if v63 then
					v315 = v315 or p7.current
				end

				if not v315 then
					return
				end

				if v314 then
					GuiService:SetMenuIsOpen(true, "ExperienceChat")
					p8()
					GuiService.SelectedCoreObject = v315

					if not connection then
						connection = UserInputService.InputBegan:Connect(function(input) -- line: 169
							-- upvalues: t3 (copy), FocusUtils (copy), v74 (copy)
							if input and t3[input.KeyCode] then
								FocusUtils.FocusOnChrome(function() -- line: 172
									-- upvalues: v74 (copy)
									v74.unfocusChatInputBar()
								end, "chat")
							end
						end)

						return
					end
				elseif GuiService.MenuIsOpen then
					GuiService:SetMenuIsOpen(false, "ExperienceChat")
					p9()

					if connection then
						connection:Disconnect()
						connection = nil
					end
				end
			end)

			return function() -- line: 188
				-- upvalues: v207 (copy), connection (ref)
				v207()

				if connection then
					connection:Disconnect()
					connection = nil
				end
			end
		end, {})

		return
	end

	if FFlagChromeChatGamepadSupportFix then
		React.useEffect(function() -- line: 198
			-- upvalues: p6 (copy), p5 (copy), FFlagEnableConsoleExpControls (copy), GuiService (copy), p8 (copy), onChatInputBarFocusLost (copy), p9 (copy), ActionBindableEvent (copy)
			local u208 = nil
			local u209 = nil
			local connection = ActionBindableEvent.Event:Connect(function(p11) -- line: 202
				-- upvalues: p6 (copy), p5 (copy), FFlagEnableConsoleExpControls (copy), GuiService (copy), p8 (copy), u209 (ref), u208 (ref), onChatInputBarFocusLost (copy), p9 (copy)
				local v317 = if not p6.current then p5.current else p6.current

				if FFlagEnableConsoleExpControls and (p11.type == "ChatTopBarFocusSelect" and v317) then
					GuiService:SetMenuIsOpen(true, "ExperienceChat")
					p8()
					GuiService.SelectedCoreObject = v317
					u209 = task.delay(0, function() -- line: 214
						-- upvalues: u209 (ref), u208 (ref), onChatInputBarFocusLost (copy), p11 (copy), p9 (copy)
						u209 = nil

						if u208 then
							u208:Disconnect()
						end

						u208 = onChatInputBarFocusLost(p11.onSelectionLost, p11.keybinds, p9)
					end)
				end
			end)

			return function() -- line: 228
				-- upvalues: connection (copy), u209 (ref), u208 (ref)
				connection:disconnect()

				if u209 then
					task.cancel(u209)
					u209 = nil
				end

				if u208 then
					u208:Disconnect()
					u208 = nil
				end
			end
		end, {
			p5.current,
			p6.current
		})
	end
end
local function ChatInputBar(p12) -- line: 244
	-- upvalues: React (copy), FFlagExpChatUseUnifiedTooltipStore (copy), GetChatTooltipStore (copy), v70 (copy), useSendTelemetry (copy), FFlagExpChatEnableFocusNavigation (copy), ReactFocusNavigation (copy), FFlagExpChatFocusViaLastModeFix (copy), FocusNavigationUtils (copy), SignalsReact (copy), v74 (copy), FFlagExpChatUseMessagesStore (copy), GetMessagesStore (copy), FFlagExpChatPresetChatEnabled (copy), GetPresetChatStore (copy), TextChatService (copy), u77 (ref), AutocompleteText (copy), initializeCommands (copy), getEnableChatInputBarConfigurationAutocompleteEnabled (copy), u76 (ref), initializeEmojis (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), u78 (ref), initializeGlobalCommands (copy), initialCommands (copy), v27 (copy), FFlagExpChatDictation (copy), FFlagExpChatPresetChatGamepadEnabled (copy), GuiService (copy), v64 (copy), v50 (copy), IXPServiceWrapper (copy), v51 (copy), FFlagExpChatBackspaceExitsTargetChannelInGlobalTabs (copy), FFlagExpChatFixBackspaceNilTargetChannel (copy), Config (copy), Players (copy), FFlagEnableConsoleExpControls (copy), FFlagChromeChatGamepadSupportFix (copy), onChatInputBarFocusLost (copy), ActionBindableEvent (copy), useEffectChatInputBarFocus (copy), sortCommandResultsCallback (copy), sortEmojiResultsCallback (copy), List (copy), RBXTeamCommandname (ref), RBXTeamCommand (copy), RBXWhisperCommandname (ref), RBXWhisperCommand (copy), v62 (copy), autoCastCommand (copy), Promise (copy), useCursor (copy), v52 (copy), v53 (copy), useInterpolatedClientSettings (copy), FFlagExpChatNewInputBar (copy), AutocompleteDropdown (copy), setTransparency (copy), FFlagExpChatNewInputBarDictation (copy), ChatInputBarV2Dictation (copy), ChatInputBarV2 (copy), DictationInputBar (copy), v63 (copy), ChannelChip (copy), ImageSetLabel (copy), Images (copy)
	local v99 = React.useRef("")

	if FFlagExpChatUseUnifiedTooltipStore then
		local setIsChatInputBarVisible = GetChatTooltipStore(false).setIsChatInputBarVisible

		React.useEffect(function() -- line: 252
			-- upvalues: p12 (copy), setIsChatInputBarVisible (copy)
			if p12.visible ~= nil then
				setIsChatInputBarVisible(p12.visible)
			else
				setIsChatInputBarVisible(true)
			end

			return function() -- line: 261
				-- upvalues: setIsChatInputBarVisible (copy)
				setIsChatInputBarVisible(false)
			end
		end, {
			p12.visible,
			setIsChatInputBarVisible
		})
	end

	local v101, v102 = React.useState("")
	local v103, v104 = React.useState(0)
	local u105 = v103
	local u106 = v104
	local v107, v108 = React.useState(0)
	local u109 = v107
	local u110 = v108
	local v111, v112 = React.useState(false)
	local v113, _ = React.useState(true)
	local v115, v116 = React.useBinding(0)
	local v117 = React.useRef(false)
	local v118 = React.useRef(nil)
	local v119 = React.useRef(nil)
	local v120 = if not v70 then nil else useSendTelemetry({
		enabled = v70,
		textBoxRef = v118,
		customTextBoxRef = v119
	})
	local v121 = React.useRef(nil)
	local v122 = React.useRef(nil)
	local v123 = React.useRef(nil)
	local v124 = React.useRef(nil)
	local v125 = React.useRef(false)
	local v126 = if not FFlagExpChatEnableFocusNavigation then nil else ReactFocusNavigation.useFocusGuiObject()
	local v127 = if not FFlagExpChatEnableFocusNavigation or FFlagExpChatFocusViaLastModeFix then nil else FocusNavigationUtils.useLastInputMode()
	local v128 = if not FFlagExpChatFocusViaLastModeFix then nil else SignalsReact.useSignalState(v74.getChatInputBarFocused)
	local u129 = nil

	if FFlagExpChatUseMessagesStore then
		local v130 = GetMessagesStore(false)

		u129 = SignalsReact.useSignalState(v130.getCanLocalUserChat)
	end

	local v131 = if not FFlagExpChatPresetChatEnabled then nil else SignalsReact.useSignalState(GetPresetChatStore(false).getIsTrayOpen)
	local v132 = if not FFlagExpChatPresetChatEnabled then nil else SignalsReact.useSignalState(GetPresetChatStore(false).getIsEnabled)
	local v133 = React.useRef(false)

	React.useEffect(function() -- line: 326
		-- upvalues: v119 (copy), p12 (copy)
		v119.current = p12.chatInputBarSettings.TextBox
	end, { p12.chatInputBarSettings.TextBox == nil and "nil" or p12.chatInputBarSettings.TextBox })
	React.useEffect(function() -- line: 331
		-- upvalues: p12 (copy), TextChatService (copy), u77 (ref), AutocompleteText (copy), initializeCommands (copy), getEnableChatInputBarConfigurationAutocompleteEnabled (copy), u76 (ref), initializeEmojis (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), u78 (ref), initializeGlobalCommands (copy), initialCommands (copy)
		if not p12.autocompleteEnabled then
			return
		end

		local t4 = {}
		local connection = TextChatService.DescendantAdded:Connect(function(descendant) -- line: 336
			-- upvalues: u77 (ref), AutocompleteText (copy), initializeCommands (copy), t4 (copy)
			if descendant:IsA("TextChatCommand") and string.sub(descendant.PrimaryAlias, 1, 1) == "/" then
				u77 = AutocompleteText.new(initializeCommands)

				local connection = descendant:GetPropertyChangedSignal("AutocompleteVisible"):Connect(function() -- line: 342
					-- upvalues: u77 (ref), AutocompleteText (copy), initializeCommands (copy)
					u77 = AutocompleteText.new(initializeCommands)
				end)

				table.insert(t4, connection)
			end
		end)
		local connection2 = TextChatService.DescendantRemoving:Connect(function(descendant) -- line: 349
			-- upvalues: u77 (ref), AutocompleteText (copy), initializeCommands (copy)
			if descendant:IsA("TextChatCommand") and string.sub(descendant.PrimaryAlias, 1, 1) == "/" then
				u77 = AutocompleteText.new(initializeCommands)
			end
		end)

		if getEnableChatInputBarConfigurationAutocompleteEnabled() then
			u77 = AutocompleteText.new(initializeCommands)
			u76 = AutocompleteText.new(initializeEmojis)

			if GetFFlagTextChatEnableUniverseChatTabs() then
				u78 = AutocompleteText.new(initializeGlobalCommands)
			end

			local v214 = initialCommands()

			if v214 then
				for _, v216 in v214 do
					table.insert(t4, (v216:GetPropertyChangedSignal("AutocompleteVisible"):Connect(function() -- line: 366
						-- upvalues: u77 (ref), AutocompleteText (copy), initializeCommands (copy)
						u77 = AutocompleteText.new(initializeCommands)
					end)))
				end
			end
		end

		return function() -- line: 374
			-- upvalues: connection2 (copy), connection (copy), t4 (copy)
			if connection2 then
				connection2:Disconnect()
			end

			connection:Disconnect()

			for _, v in ipairs(t4) do
				v:Disconnect()
			end

			table.clear(t4)
		end
	end, {})

	local v134 = React.useCallback(function() -- line: 387
		-- upvalues: v27 (copy), v101 (copy), FFlagExpChatUseMessagesStore (copy), u129 (ref), p12 (copy), v117 (copy), v118 (copy), v119 (copy), v120 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), FFlagExpChatDictation (copy), v102 (copy), FFlagExpChatPresetChatGamepadEnabled (copy), GuiService (copy), v125 (copy)
		v27:trace("onSendActivated with input text: '{}'", v101)

		local v217 = if not FFlagExpChatUseMessagesStore then p12.canLocalUserChat else u129

		if not v117.current or not v217 then
			v27:debug("onSendActivated could not send message. isMounted: {} canLocalUserChat: {}", tostring(v117.current), v217)

			return
		end

		if v118.current or v119.current then
			local v218 = if not v119.current then v118.current.Text else v119.current.Text
			local v219 = if not v120 then nil else v120.consumeOnSend(v218)
			local v220 = if not GetFFlagTextChatEnableUniverseChatTabs() or (not p12.isGlobalChatTabActive or not p12.onSendGlobalChat) then p12.onSendChat else p12.onSendGlobalChat

			if v220 and string.find(v218, "%S") ~= nil then
				if FFlagExpChatDictation then
					v220(v218, v219, v219 ~= nil)
				else
					v220(v218)
				end
			else
				v27:debug("onSendActivated could not send message. text: '{}' canLocalUserChat: {}", v218, v217)
			end

			if v119.current then
				v119.current.Text = ""
				v119.current:ReleaseFocus()
			end

			if v118.current then
				v118.current.Text = ""
				v118.current:ReleaseFocus()
			end

			v102("")

			if FFlagExpChatPresetChatGamepadEnabled then
				local v221 = v119.current or v118.current

				if v221 then
					GuiService.SelectedCoreObject = v221
				end
			end

			if p12.targetTextChannel and p12.targetTextChannelDisplayName ~= "" then
				v125.current = true

				return
			end
		else
			v27:debug("onSendActivated could not send message because textBoxRef.current was nil")
		end
	end, {
		v101,
		v119.current,
		u129,
		p12.canLocalUserChat,
		p12.isGlobalChatTabActive,
		p12.onSendChat or false,
		p12.onSendGlobalChat or false,
		p12.targetTextChannel or false,
		p12.targetTextChannelDisplayName,
		not not v120 and v120.consumeOnSend
	})
	local v135 = if not v70 then nil else React.useCallback(function(t5: {[any]: any}?) -- line: 474
		-- upvalues: FFlagExpChatUseMessagesStore (copy), u129 (ref), p12 (copy), v117 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), v119 (copy), v118 (copy), v102 (copy), FFlagExpChatPresetChatGamepadEnabled (copy), GuiService (copy), v125 (copy)
		local v223 = if not FFlagExpChatUseMessagesStore then p12.canLocalUserChat else u129

		if not v117.current or not v223 then
			return
		end

		local v224 = t5 and t5.textSent or ""
		local v225 = if not GetFFlagTextChatEnableUniverseChatTabs() or (not p12.isGlobalChatTabActive or not p12.onSendGlobalChat) then p12.onSendChat else p12.onSendGlobalChat

		if v225 and string.find(v224, "%S") ~= nil then
			v225(v224, t5, true)
		end

		if v119.current then
			v119.current.Text = ""
			v119.current:ReleaseFocus()
		end

		if v118.current then
			v118.current.Text = ""
			v118.current:ReleaseFocus()
		end

		v102("")

		if FFlagExpChatPresetChatGamepadEnabled then
			local v226 = v119.current or v118.current

			if v226 then
				GuiService.SelectedCoreObject = v226
			end
		end

		if p12.targetTextChannel and p12.targetTextChannelDisplayName ~= "" then
			v125.current = true
		end
	end, {
		v119.current,
		u129,
		p12.canLocalUserChat,
		p12.isGlobalChatTabActive,
		p12.onSendChat or false,
		p12.onSendGlobalChat or false,
		p12.targetTextChannel or false,
		p12.targetTextChannelDisplayName
	})
	local v136 = React.useCallback(function(p13) -- line: 522
		-- upvalues: p12 (copy), v119 (copy), v118 (copy), u105 (ref), v102 (copy), v117 (copy), FFlagExpChatFocusViaLastModeFix (copy), v128 (copy), v126 (copy), v127 (copy), v64 (copy), v27 (copy)
		p12.autocompleteDropdownActivated(false)
		p12.autocompleteDropdownResultsChanged({})

		local v228 = if not v119.current then v118.current else v119.current

		if v228 then
			local Text = v228.Text
			local v230 = string.sub(Text, 1, u105 - 1)
			local v231 = string.sub(Text, u105, #Text)
			local s1 = ""

			if p12.autocompleteDropdownReducer.autocompleteType == "emojis" then
				local EmojiLabelText = p13.EmojiLabel.Text

				s1 = string.gsub(v230, ":[^:]*$", EmojiLabelText)
			elseif p12.autocompleteDropdownReducer.autocompleteType == "commands" then
				local TextLabelText = p13.TextLabel.Text

				s1 = string.gsub(v230, "(/.*)", TextLabelText)
			end

			if v231 ~= "" then
				s1 ..= v231
			end

			v228.Text = s1
			v102(s1)

			if v117.current then
				v228:CaptureFocus()

				if FFlagExpChatFocusViaLastModeFix then
					if v128 then
						v126(v228)
					end
				elseif v127 == "Focus" then
					v126(v228)
				end

				if v231 ~= "" and not v64 then
					v228.CursorPosition = #s1 - #v231 + 1
				end
			end

			p12.autocompleteDropdownDeactivated()

			return
		end

		v27:error("Could not find textBox")
	end, if not FFlagExpChatEnableFocusNavigation then nil else {
		if not FFlagExpChatFocusViaLastModeFix then nil else v128,
		v126,
		v113,
		u105,
		if not FFlagExpChatFocusViaLastModeFix then v127 else nil,
		p12.autocompleteDropdownActivated,
		p12.autocompleteDropdownDeactivated,
		p12.autocompleteDropdownReducer and p12.autocompleteDropdownReducer.autocompleteType,
		p12.autocompleteDropdownResultsChanged
	})

	React.useEffect(function() -- line: 593
		-- upvalues: v117 (copy), v119 (copy), v118 (copy), v27 (copy)
		if v117.current then
			local v235 = if not v119.current then v118.current else v119.current

			if v235 then
				v235:CaptureFocus()

				return
			end

			v27:error("Could not focus chat input bar because textBox not found")
		end
	end, {
		p12.shouldFocusChatInputBar,
		v119.current
	})

	if FFlagExpChatPresetChatEnabled then
		React.useEffect(function() -- line: 605
			-- upvalues: v131 (copy), v119 (copy), v118 (copy)
			if not v131 then
				return
			end

			local v236 = if not v119.current then v118.current else v119.current

			if v236 and v236:IsFocused() then
				v236:ReleaseFocus()
			end
		end, { v131 })
	end

	React.useEffect(function() -- line: 616
		-- upvalues: v27 (copy), v117 (copy), v50 (copy), IXPServiceWrapper (copy), v51 (copy)
		v27:trace("Mounted")
		v117.current = true

		if v50 then
			IXPServiceWrapper:LogUserLayerExposure(v51)
		end

		return function() -- line: 624
			-- upvalues: v27 (copy), v117 (copy)
			v27:trace("Unmounting")
			v117.current = false
		end
	end, {})
	React.useEffect(function() -- line: 630
		-- upvalues: p12 (copy), v119 (copy), v118 (copy), u106 (ref)
		local connection = nil

		if p12.autocompleteEnabled then
			local v238 = if not v119.current then v118.current else v119.current

			if v238 then
				connection = v238:GetPropertyChangedSignal("CursorPosition"):Connect(function() -- line: 635
					-- upvalues: v238 (copy), u106 (ref)
					local CursorPosition = v238.CursorPosition

					if CursorPosition and CursorPosition ~= -1 then
						u106(CursorPosition)
					end
				end)
			end
		end

		return function() -- line: 644
			-- upvalues: connection (ref)
			if connection then
				connection:Disconnect()
			end
		end
	end, { v119.current })
	React.useEffect(function() -- line: 652
		-- upvalues: p12 (copy), v124 (copy)
		if p12.autocompleteEnabled then
			v124.current = p12.userInputService.InputBegan:connect(function(p14, _) -- line: 654
				-- upvalues: p12 (copy)
				if p12.autocompleteDropdownReducer.activated and (Enum.KeyCode.Up or Enum.KeyCode.Down) then
					if p14 and p14.KeyCode == Enum.KeyCode.Up and p12.autocompleteDropdownReducer.selectedIndex > 1 then
						p12.autocompleteDropdownSelectionChanged(p12.autocompleteDropdownReducer.selectedIndex - 1)
					end

					if p14 and p14.KeyCode == Enum.KeyCode.Down and p12.autocompleteDropdownReducer.selectedIndex < #p12.autocompleteDropdownReducer.results then
						p12.autocompleteDropdownSelectionChanged(p12.autocompleteDropdownReducer.selectedIndex + 1)
					end
				end
			end)

			return function() -- line: 676
				-- upvalues: v124 (copy)
				local current = v124.current

				if current and current.Connected then
					current:Disconnect()
				end

				v124.current = nil
			end
		end

		return function() -- line: 684
		end
	end, {
		p12.userInputService,
		p12.autocompleteDropdownReducer
	})
	React.useEffect(function() -- line: 688
		-- upvalues: GetFFlagTextChatEnableUniverseChatTabs (copy), p12 (copy), FFlagExpChatBackspaceExitsTargetChannelInGlobalTabs (copy), v123 (copy), v119 (copy), v118 (copy), v125 (copy), FFlagExpChatFixBackspaceNilTargetChannel (copy), v27 (copy), v101 (copy)
		local v239 = GetFFlagTextChatEnableUniverseChatTabs() and not p12.developerChannelTabsEnabled
		local v240 = if not FFlagExpChatBackspaceExitsTargetChannelInGlobalTabs then not p12.isChannelBarVisible else not p12.isChannelBarVisible or v239

		v123.current = p12.userInputService.InputEnded:connect(function(p16, _) -- line: 696
			-- upvalues: v119 (copy), v118 (copy), p12 (copy), v125 (copy), v240 (copy), FFlagExpChatFixBackspaceNilTargetChannel (copy), v27 (copy), v101 (copy)
			if if not v119.current then v118.current and (v118.current:IsFocused() and (p16 and p16.KeyCode == Enum.KeyCode.Backspace)) else v119.current and (v119.current:IsFocused() and (p16 and p16.KeyCode == Enum.KeyCode.Backspace)) then
				local v329 = (p12.targetTextChannelDisplayName or "") ~= ""

				if v125.current and v240 and (not FFlagExpChatFixBackspaceNilTargetChannel or v329) then
					p12.resetTargetChannel(if not FFlagExpChatFixBackspaceNilTargetChannel then nil else p12.isGlobalChatTabActive)
					v27:debug("ChatInputBar ChatInputBarResetTargetChannel()")
					v125.current = false

					return
				end

				if v101 == "" and if not FFlagExpChatFixBackspaceNilTargetChannel then p12.targetTextChannelDisplayName ~= "" else v329 then
					v125.current = true
				end
			end
		end)

		return function() -- line: 737
			-- upvalues: v123 (copy)
			local current = v123.current

			if current and current.Connected then
				current:Disconnect()
			end

			v123.current = nil
		end
	end, {
		p12.userInputService,
		v119.current,
		p12.isChannelBarVisible,
		p12.targetTextChannelDisplayName,
		p12.resetTargetChannel,
		if not FFlagExpChatBackspaceExitsTargetChannelInGlobalTabs then nil else p12.developerChannelTabsEnabled,
		if not FFlagExpChatFixBackspaceNilTargetChannel then nil else p12.isGlobalChatTabActive
	})
	React.useEffect(function() -- line: 755
		-- upvalues: p12 (copy), Config (copy), v119 (copy), v118 (copy), v133 (copy)
		local function handleAction(_: string, p18, p19) -- line: 756
			-- upvalues: p12 (copy), Config (copy), v119 (copy), v118 (copy), v133 (copy)
			if p12.isChatHotkeyEnabled and p19 and (p19.KeyCode == Config.ChatInputBarDefaultFocusKeyCode or p19.KeyCode == p12.devDefinedFocusKeyCode) then
				local v334 = if not v119.current then v118.current else v119.current

				if v334 and p18 == Enum.UserInputState.Begin and v334 and not v334:IsFocused() then
					task.delay(0, function() -- line: 778
						-- upvalues: v334 (copy)
						v334:CaptureFocus()
					end)
					p12.focusChatHotKeyActivated()
					v133.current = true

					return Enum.ContextActionResult.Sink
				end
			end

			return Enum.ContextActionResult.Pass
		end

		p12.contextActionService:BindCoreAction("FocusChat", handleAction, false, Enum.UserInputType.Keyboard)

		return function() -- line: 802
			-- upvalues: p12 (copy)
			p12.contextActionService:UnbindCoreAction("FocusChat")
		end
	end, {
		p12.isChatHotkeyEnabled,
		p12.devDefinedFocusKeyCode,
		v133.current,
		v119.current
	})

	local v137 = React.useCallback(function() -- line: 816
		-- upvalues: v112 (copy), p12 (copy), TextChatService (copy)
		v112(true)
		p12.onFocus()

		local ChatInputBarConfiguration = TextChatService:FindFirstChildOfClass("ChatInputBarConfiguration")

		if ChatInputBarConfiguration then
			ChatInputBarConfiguration.IsFocusedWrite = true
		end
	end, { p12.onFocus })
	local v138 = React.useCallback(function(_, b1: boolean, p21) -- line: 822
		-- upvalues: v27 (copy), v122 (copy), FFlagExpChatEnableFocusNavigation (copy), p12 (copy), v136 (copy), v134 (copy), v117 (copy), v119 (copy), v118 (copy), u105 (ref), v64 (copy), v112 (copy), TextChatService (copy), v133 (copy), Players (copy)
		v27:debug("Focus lost with enter: {}", (tostring(b1)))

		local current = v122.current

		if b1 or FFlagExpChatEnableFocusNavigation and p21 and (p21.KeyCode == Enum.KeyCode.Return or p21.KeyCode == Enum.KeyCode.KeypadEnter) then
			if p12.autocompleteEnabled and current and p12.autocompleteDropdownReducer.activated and #p12.autocompleteDropdownReducer.results > 0 then
				local OffsetFrame = current.ScrollBarFrame.ScrollViewFrame.ScrollView.OffsetFrame

				for _, child in ipairs(OffsetFrame:GetChildren()) do
					if child.ClassName == "Frame" and child.LayoutOrder == p12.autocompleteDropdownReducer.selectedIndex then
						v136(child.TextLabelButton)

						return
					end
				end
			else
				v134()
			end
		end

		if v117.current then
			if p12.autocompleteEnabled and current and p12.autocompleteDropdownReducer.activated then
				if p21 then
					if p21.KeyCode == Enum.KeyCode.Escape then
						p12.autocompleteDropdownActivated(false)

						local v252 = if not v119.current then v118.current else v119.current

						if v252 then
							local v253 = u105

							v252:CaptureFocus()

							if not v64 then
								v252.CursorPosition = v253
							end

							return
						end

						v27:error("Could not focus chat input bar because textBox not found")
					else
						local PositionX = p21.Position.X
						local PositionY = p21.Position.Y
						local AbsolutePositionX = current.AbsolutePosition.X
						local v257 = AbsolutePositionX + current.AbsoluteSize.X
						local AbsolutePositionY = current.AbsolutePosition.Y
						local v259 = AbsolutePositionY + current.AbsoluteSize.Y

						if PositionX < AbsolutePositionX or v257 < PositionX or PositionY < AbsolutePositionY or v259 < PositionY then
							p12.autocompleteDropdownActivated(false)
						end
					end
				end
			else
				v112(false)
			end
		end

		p12.onUnfocus()

		local ChatInputBarConfiguration = TextChatService:FindFirstChildOfClass("ChatInputBarConfiguration")

		if ChatInputBarConfiguration then
			ChatInputBarConfiguration.IsFocusedWrite = false
		end

		if v133.current then
			local LocalPlayer = Players.LocalPlayer

			if LocalPlayer then
				local TextBox = Instance.new("TextBox")

				TextBox.Visible = false
				TextBox.Parent = LocalPlayer:FindFirstChildOfClass("PlayerGui")
				TextBox:CaptureFocus()
				TextBox:ReleaseFocus()
				TextBox:Destroy()
			end

			v133.current = false
		end
	end)

	React.useEffect(function() -- line: 927
		-- upvalues: FFlagEnableConsoleExpControls (copy), v119 (copy), v118 (copy), FFlagChromeChatGamepadSupportFix (copy), GuiService (copy), v137 (copy), onChatInputBarFocusLost (copy), v138 (copy), ActionBindableEvent (copy)
		local u263 = nil
		local u264 = nil
		local connection = ActionBindableEvent.Event:Connect(function(p22) -- line: 931
			-- upvalues: FFlagEnableConsoleExpControls (copy), v119 (copy), v118 (copy), FFlagChromeChatGamepadSupportFix (copy), GuiService (copy), v137 (copy), u264 (ref), u263 (ref), onChatInputBarFocusLost (copy), v138 (copy)
			local u336 = nil

			if FFlagEnableConsoleExpControls then
				u336 = if not v119.current then v118.current else v119.current
			end

			if p22.type == "ChatTopBarFocusActivated" then
				if not FFlagEnableConsoleExpControls then
					u336 = if not v119.current then v118.current else v119.current
				end

				if u336 then
					task.delay(0, function() -- line: 942
						-- upvalues: u336 (ref)
						u336:CaptureFocus()
					end)
				end
			elseif not FFlagChromeChatGamepadSupportFix and FFlagEnableConsoleExpControls and p22.type == "ChatTopBarFocusSelect" and u336 then
				GuiService:SetMenuIsOpen(true, "ExperienceChat")
				v137()
				GuiService.SelectedCoreObject = u336
				u264 = task.delay(0, function() -- line: 957
					-- upvalues: u264 (ref), u263 (ref), onChatInputBarFocusLost (copy), p22 (copy), v138 (copy)
					u264 = nil

					if u263 then
						u263:Disconnect()
					end

					u263 = onChatInputBarFocusLost(p22.onSelectionLost, p22.keybinds, v138)
				end)
			end
		end)

		return function() -- line: 971
			-- upvalues: connection (copy), u264 (ref), u263 (ref)
			connection:disconnect()

			if u264 then
				task.cancel(u264)
				u264 = nil
			end

			if u263 then
				u263:Disconnect()
				u263 = nil
			end
		end
	end, {
		v118.current,
		v119.current
	})
	useEffectChatInputBarFocus(v118, v119, v121, v137, v138)

	local function handleAutocomplete(p23, p24, p25) -- line: 989
		-- upvalues: p12 (copy), u78 (ref), u77 (ref), sortCommandResultsCallback (copy), u76 (ref), sortEmojiResultsCallback (copy), u109 (ref), List (copy), v102 (copy), v64 (copy), v122 (copy), v136 (copy), u110 (ref)
		if p25 == "/" and p23.CursorPosition == 2 or p12.autocompleteDropdownReducer.autocompleteType == "commands" and p25 ~= ":" then
			p12.autocompleteDropdownTypeChanged("commands")
			p12.autocompleteDropdownActivated(true)

			if p25 ~= "" and p25 ~= " " then
				local v269 = string.sub(p24, 1, p23.CursorPosition - 1):lower()
				local v270 = ((if not p12.isGlobalChatTabActive or not u78 then u77 else u78)):getResults(v269, sortCommandResultsCallback)

				p12.autocompleteDropdownResultsChanged(v270)

				if v269 == v270[1] then
					p12.autocompleteDropdownActivated(false)
					p12.autocompleteDropdownResultsChanged({})

					return
				end
			else
				p12.autocompleteDropdownDeactivated()
			end

			return
		end

		if (p12.autocompleteDropdownReducer.activated or #p12.autocompleteDropdownReducer.results > 0) and p12.autocompleteDropdownReducer.autocompleteType == "emojis" then
			p12.autocompleteDropdownActivated(true)

			local v271 = string.sub(p24, 1, p23.CursorPosition - 1)
			local v272 = string.find(v271, ":[^:]*$")

			if p25 ~= "" and p25 ~= ":" and p25 ~= " " and v272 then
				local v273 = string.sub(p24, v272 + 1, p23.CursorPosition - 1):lower()
				local t6 = {}

				if v273 and string.len(v273) > 1 then
					t6 = u76:getResults(v273, sortEmojiResultsCallback)
				end

				p12.autocompleteDropdownResultsChanged(t6)

				return
			end

			if p25 == ":" then
				if v272 ~= u109 then
					local v275 = string.sub(p24, u109 + 1, p23.CursorPosition - 2):lower()

					if List.includes(p12.autocompleteDropdownReducer.results, v275) then
						local v276 = string.sub(p24, p23.CursorPosition, #p24)
						local v277 = string.sub(p24, 1, p23.CursorPosition - 2) .. v276

						p23.Text = v277
						v102(v277)

						if not v64 then
							p23.CursorPosition = p23.CursorPosition - 1
						end

						local current = v122.current

						if current then
							local OffsetFrame = current.ScrollBarFrame.ScrollViewFrame.ScrollView.OffsetFrame

							for _, child in ipairs(OffsetFrame:GetChildren()) do
								if child.ClassName ~= "Frame" then
									continue
								end

								local TextLabelButton = child:FindFirstChild("TextLabelButton")

								if TextLabelButton then
									local TextLabel = TextLabelButton:FindFirstChild("TextLabel")

									if not TextLabel or not TextLabel.Text or v275 ~= TextLabel.Text then
										continue
									end

									v136(TextLabelButton)

									return
								end
							end

							return
						end
					else
						p12.autocompleteDropdownActivated(false)
						p12.autocompleteDropdownResultsChanged({})
					end

					return
				end

				p12.autocompleteDropdownResultsChanged({})

				return
			end

			if p25 == " " then
				p12.autocompleteDropdownActivated(false)
				p12.autocompleteDropdownResultsChanged({})

				return
			end

			p12.autocompleteDropdownDeactivated()
			u110(0)

			return
		end

		local v284 = string.find(p24, ":[^:]*$")

		if p25 == ":" then
			p12.autocompleteDropdownTypeChanged("emojis")
			p12.autocompleteDropdownActivated(true)
			p12.autocompleteDropdownResultsChanged({})
			u110(v284)
		end
	end

	React.useEffect(function() -- line: 1106
		-- upvalues: TextChatService (copy), RBXTeamCommandname (ref), RBXTeamCommand (copy), RBXWhisperCommandname (ref), RBXWhisperCommand (copy)
		if TextChatService.CreateDefaultCommands then
			RBXTeamCommandname = TextChatService:FindFirstChild(RBXTeamCommand.name, true)
			RBXWhisperCommandname = TextChatService:FindFirstChild(RBXWhisperCommand.name, true)
		end
	end, {})

	local v140 = React.useCallback(function(p26) -- line: 1113
		-- upvalues: p12 (copy), v102 (copy), v27 (copy), v101 (copy), getEnableChatInputBarConfigurationAutocompleteEnabled (copy), handleAutocomplete (copy), v125 (copy), v62 (copy), v99 (copy), RBXTeamCommandname (ref), autoCastCommand (copy), RBXTeamCommand (copy), RBXWhisperCommandname (ref), RBXWhisperCommand (copy), Promise (copy)
		local p26Text = p26.Text

		if p12.autocompleteEnabled then
			local v287 = string.find(p26Text, "\r")
			local v288 = p26.CursorPosition < #p26Text + 1

			if v287 then
				local v289 = string.gsub(p26Text, "\r", "")

				p26.Text = v289
				v102(v289)

				if v288 then
					p26.CursorPosition = p26.CursorPosition - 1
				end

				return
			end
		end

		local v290 = string.sub(p26Text, p26.CursorPosition - 1, p26.CursorPosition - 1)

		v27:trace("Input: {}", p26Text)

		local v291 = if not utf8.len(p26Text) then string.len(p26Text) else utf8.len(utf8.nfcnormalize(p26Text))

		if v291 and v291 > p12.messageCharacterLimit then
			v27:debug("Message is over the character limit of {}", (tostring(p12.messageCharacterLimit)))
			p26.Text = v101

			return
		end

		v102(p26Text)

		if getEnableChatInputBarConfigurationAutocompleteEnabled() and p12.autocompleteEnabled then
			handleAutocomplete(p26, p26Text, v290)
		end

		v125.current = #p26Text == 0 and v125.current

		if v62 then
			if string.sub(p26Text, 1, 1) == "/" and p12.localPlayer and p26Text ~= v99.current then
				v99.current = p26Text

				local UserId = p12.localPlayer.UserId
				local t7 = {}

				if RBXTeamCommandname and RBXTeamCommandname.Enabled then
					table.insert(t7, autoCastCommand(RBXTeamCommand, UserId, p26Text))
				end

				if RBXWhisperCommandname and RBXWhisperCommandname.Enabled then
					table.insert(t7, autoCastCommand(RBXWhisperCommand, UserId, p26Text))
				end

				if #t7 == 0 then
					t7 = { Promise.reject() }
				end

				Promise.any(t7):andThen(function() -- line: 1169
					-- upvalues: p26 (copy), v102 (copy), v125 (copy)
					p26.Text = ""
					v102("")
					v125.current = true
				end):catch(function(p27) -- line: 1175
					-- upvalues: v27 (copy)
					v27:trace("Could not send autoCastCommand. Error: {}", p27)
				end)

				return
			end

			if string.sub(p26Text, 1, 1) ~= "/" then
				v99.current = ""

				return
			end
		elseif p12.localPlayer then
			local UserId = p12.localPlayer.UserId
			local t8 = {}

			if RBXTeamCommandname and RBXTeamCommandname.Enabled then
				table.insert(t8, autoCastCommand(RBXTeamCommand, UserId, p26Text))
			end

			if RBXWhisperCommandname and RBXWhisperCommandname.Enabled then
				table.insert(t8, autoCastCommand(RBXWhisperCommand, UserId, p26Text))
			end

			if #t8 == 0 then
				t8 = { Promise.reject() }
			end

			Promise.any(t8):andThen(function() -- line: 1198
				-- upvalues: p26 (copy), v102 (copy), v125 (copy)
				p26.Text = ""
				v102("")
				v125.current = true
			end):catch(function(p28) -- line: 1204
				-- upvalues: v27 (copy)
				v27:trace("Could not send autoCastCommand. Error: {}", p28)
			end)
		end
	end)
	local v141 = React.useCallback(function() -- line: 1211
		-- upvalues: v119 (copy), v118 (copy)
		local v296 = if not v119.current then v118.current else v119.current

		if v296 then
			v296:ReleaseFocus(true)
		end
	end, {
		v118.current,
		v119.current
	})
	local v142 = React.useCallback(function(p29) -- line: 1218
		-- upvalues: v116 (copy)
		v116(p29.Visible and p29.AbsoluteSize.X or 0)
	end)
	local v143 = if not FFlagExpChatEnableFocusNavigation then nil else useCursor()
	local v144 = React.useCallback(function(p30) -- line: 1225
		-- upvalues: p12 (copy)
		p12.autocompleteDropdownSelectionChanged(p30.LayoutOrder)
	end)
	local v145 = v101 == ""
	local v146 = v145 and not v111
	local chatInputBarSettings = p12.chatInputBarSettings
	local chatWindowSettings = p12.chatWindowSettings
	local v149 = if not FFlagExpChatUseMessagesStore or u129 == nil then p12.canLocalUserChat else u129

	React.useEffect(function() -- line: 1240
		-- upvalues: v52 (copy), v149 (copy), IXPServiceWrapper (copy), v53 (copy)
		if v52 and v149 then
			IXPServiceWrapper:LogUserLayerExposure(v53)
		end
	end, { v149 })

	local BackgroundTransparency = useInterpolatedClientSettings(chatInputBarSettings).BackgroundTransparency
	local BackgroundTransparency2 = useInterpolatedClientSettings(chatWindowSettings).BackgroundTransparency
	local BackgroundColor3 = useInterpolatedClientSettings(chatWindowSettings).BackgroundColor3
	local isSpatialUIEnabled = p12.isSpatialUIEnabled
	local createElement = React.createElement
	local t9 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = BackgroundColor3,
		BackgroundTransparency = if not FFlagExpChatNewInputBar then p12.transparencyValue:map(function(n2: number) -- line: 100
			-- upvalues: BackgroundTransparency2 (copy)
			return BackgroundTransparency2 + n2 * (1 - BackgroundTransparency2)
		end) else 1,
		BorderSizePixel = 0,
		LayoutOrder = p12.LayoutOrder,
		Size = p12.size,
		Visible = p12.visible,
		ZIndex = 2,
		[React.Event.MouseEnter] = p12.onHovered,
		[React.Event.MouseLeave] = p12.onUnhovered,
		[React.Change.AbsoluteSize] = React.useCallback(function(p31) -- line: 1266
			-- upvalues: TextChatService (copy), p12 (copy)
			local ChatInputBarConfiguration = TextChatService:FindFirstChildOfClass("ChatInputBarConfiguration")

			if ChatInputBarConfiguration and p12.onAbsoluteSizeChanged then
				p12.onAbsoluteSizeChanged(p31, ChatInputBarConfiguration)
			end
		end),
		[React.Change.AbsolutePosition] = React.useCallback(function(p32) -- line: 1272
			-- upvalues: TextChatService (copy), p12 (copy)
			local ChatInputBarConfiguration = TextChatService:FindFirstChildOfClass("ChatInputBarConfiguration")

			if ChatInputBarConfiguration and p12.onAbsolutePositionChanged then
				p12.onAbsolutePositionChanged(p32, ChatInputBarConfiguration)
			end
		end)
	}
	local t10 = {
		AutocompleteDropdown = getEnableChatInputBarConfigurationAutocompleteEnabled() and (not not p12.autocompleteEnabled and React.createElement(AutocompleteDropdown, {
			chatInputBarSettings = chatInputBarSettings,
			chatWindowSettings = chatWindowSettings,
			setTransparency = setTransparency,
			transparencyValue = p12.transparencyValue,
			activated = p12.autocompleteDropdownReducer.activated and v111,
			results = p12.autocompleteDropdownReducer.results,
			selectedIndex = p12.autocompleteDropdownReducer.selectedIndex,
			autocompleteType = p12.autocompleteDropdownReducer.autocompleteType,
			onAutocompleteDropdownHover = v144,
			onAutocompleteSelected = v136,
			autocompleteDropdownRef = v122,
			textBoxRef = if not chatInputBarSettings.TextBox then v118 else v119
		})) or nil,
		UISizeConstraint = React.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(Config.ChatWindowMaxWidth, 1e999)
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = if not FFlagExpChatNewInputBar then UDim.new(0, 8) else nil,
			PaddingRight = if not FFlagExpChatNewInputBar then UDim.new(0, 8) else nil,
			PaddingTop = p12.addTopPadding and UDim.new(0, 8) or UDim.new(0, 0),
			PaddingBottom = UDim.new(0, 1)
		}),
		ChatInputBarV2 = if not FFlagExpChatNewInputBar then nil else if not FFlagExpChatNewInputBarDictation or (not v70 or not v149) then React.createElement(ChatInputBarV2, {
			transparencyValue = p12.transparencyValue,
			sendButtonContainerWidth = p12.sendButtonContainerWidth,
			resetTargetChannel = p12.resetTargetChannel,
			targetTextChannel = p12.targetTextChannel,
			targetTextChannelDisplayName = p12.targetTextChannelDisplayName,
			isChannelBarVisible = p12.isChannelBarVisible,
			developerChannelTabsEnabled = p12.developerChannelTabsEnabled,
			canLocalUserChat = p12.canLocalUserChat,
			disabledChatPlaceholderText = p12.disabledChatPlaceholderText,
			placeholderText = p12.placeholderText,
			setTransparency = setTransparency,
			chatInputBarSettings = chatInputBarSettings,
			chatInputBarBackgroundTransparency = BackgroundTransparency,
			isSpatialUIEnabled = isSpatialUIEnabled,
			canLocalUserChatDerived = u129,
			targetChannelWidth = v115,
			showPlaceholderText = v146,
			hasEmptyInputText = v145,
			shouldTruncatePlaceholder = if not FFlagExpChatPresetChatEnabled then nil else v132,
			cursor = v143,
			placeholderRef = v121,
			textBoxRef = v118,
			customTextBoxRef = v119,
			onAbsoluteSizeChanged = v142,
			onFocused = v137,
			onFocusLost = v138,
			onTextChanged = v140,
			onReturnPressedFromOnScreenKeyboard = v141,
			onSendActivated = v134,
			isGlobalChatTabActive = if not FFlagExpChatFixBackspaceNilTargetChannel then nil else p12.isGlobalChatTabActive
		}) else React.createElement(ChatInputBarV2Dictation, {
			transparencyValue = p12.transparencyValue,
			sendButtonContainerWidth = p12.sendButtonContainerWidth,
			resetTargetChannel = p12.resetTargetChannel,
			targetTextChannel = p12.targetTextChannel,
			targetTextChannelDisplayName = p12.targetTextChannelDisplayName,
			isChannelBarVisible = p12.isChannelBarVisible,
			developerChannelTabsEnabled = p12.developerChannelTabsEnabled,
			canLocalUserChat = p12.canLocalUserChat,
			disabledChatPlaceholderText = p12.disabledChatPlaceholderText,
			placeholderText = p12.placeholderText,
			setTransparency = setTransparency,
			chatInputBarSettings = chatInputBarSettings,
			chatInputBarBackgroundTransparency = BackgroundTransparency,
			isSpatialUIEnabled = isSpatialUIEnabled,
			canLocalUserChatDerived = u129,
			targetChannelWidth = v115,
			showPlaceholderText = v146,
			hasEmptyInputText = v145,
			shouldTruncatePlaceholder = if not FFlagExpChatPresetChatEnabled then nil else v132,
			cursor = v143,
			placeholderRef = v121,
			textBoxRef = v118,
			customTextBoxRef = v119,
			onAbsoluteSizeChanged = v142,
			onFocused = v137,
			onFocusLost = v138,
			onTextChanged = v140,
			onReturnPressedFromOnScreenKeyboard = v141,
			onSendActivated = v134,
			onSendRecordingTap = v135,
			onTranscriptionStaged = if not v120 then nil else v120.stageTranscription,
			inputText = v101,
			setInputText = v102,
			isGlobalChatTabActive = p12.isGlobalChatTabActive,
			onDictationActivityChanged = p12.onDictationActivityChanged
		})
	}
	local v157

	if FFlagExpChatNewInputBar then
		v157 = nil
	elseif v70 and v149 then
		v157 = React.createElement(DictationInputBar, {
			chatInputBarSettings = chatInputBarSettings,
			transparencyValue = p12.transparencyValue,
			chatInputBarBackgroundTransparency = BackgroundTransparency,
			inputText = v101,
			setInputText = v102,
			canLocalUserChat = v149,
			disabledChatPlaceholderText = p12.disabledChatPlaceholderText,
			targetChannelWidth = v115,
			showPlaceholderText = v146,
			placeholderText = p12.placeholderText,
			cursor = v143,
			placeholderRef = if not v63 then nil else v121,
			textBoxRef = v118,
			customTextBoxRef = v119,
			onFocused = v137,
			onFocusLost = v138,
			onTextChanged = v140,
			onReturnPressedFromOnScreenKeyboard = v141,
			onChannelChipAbsoluteSizeChanged = v142,
			onChannelChipActivated = if not FFlagExpChatFixBackspaceNilTargetChannel then p12.resetTargetChannel else function() -- line: 1411
				-- upvalues: p12 (copy)
				p12.resetTargetChannel(p12.isGlobalChatTabActive)
			end,
			targetTextChannel = p12.targetTextChannel,
			targetTextChannelDisplayName = p12.targetTextChannelDisplayName or "",
			isChannelBarVisible = p12.isChannelBarVisible,
			isGlobalChatTabActive = p12.isGlobalChatTabActive,
			developerChannelTabsEnabled = p12.developerChannelTabsEnabled,
			onDictationActivityChanged = p12.onDictationActivityChanged,
			onSendActivated = v134,
			onSendRecordingTap = v135,
			onTranscriptionStaged = if not v120 then nil else v120.stageTranscription,
			isSpatialUIEnabled = isSpatialUIEnabled,
			isTextBoxSelectable = not not FFlagEnableConsoleExpControls or nil,
			isPlaceholderSelectable = not not v63 or nil,
			placeholderSelectionImageObject = if not v63 then nil else v143,
			selectionBehavior = if not FFlagEnableConsoleExpControls or FFlagExpChatEnableFocusNavigation then nil else Enum.SelectionBehavior.Stop,
			selectionGroup = FFlagEnableConsoleExpControls and not FFlagExpChatEnableFocusNavigation or nil
		})
	else
		local createElement2 = React.createElement
		local t11 = {
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundColor3 = chatInputBarSettings.BackgroundColor3,
			BackgroundTransparency = if not FFlagExpChatNewInputBar then p12.transparencyValue:map(function(n3: number) -- line: 100
				-- upvalues: BackgroundTransparency (copy)
				return BackgroundTransparency + n3 * (1 - BackgroundTransparency)
			end) else 1,
			Size = UDim2.new(1, 0, 0, 0)
		}
		local t12 = {}
		local createElement3 = React.createElement
		local t13 = {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Config.ChatInputBarBorderColor3
		}
		local ChatInputBarBorderTransparency = Config.ChatInputBarBorderTransparency

		t13.Transparency = p12.transparencyValue:map(function(n4: number) -- line: 100
			-- upvalues: ChatInputBarBorderTransparency (copy)
			return ChatInputBarBorderTransparency + n4 * (1 - ChatInputBarBorderTransparency)
		end)
		t12.Border = createElement3("UIStroke", t13)
		t12.Corner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, 3)
		})

		local createElement4 = React.createElement
		local t14 = {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0)
		}
		local t15 = {}
		local createElement5 = React.createElement
		local t16 = {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			SelectionBehaviorDown = if not FFlagEnableConsoleExpControls or FFlagExpChatEnableFocusNavigation then nil else Enum.SelectionBehavior.Stop,
			SelectionBehaviorLeft = if not FFlagEnableConsoleExpControls or FFlagExpChatEnableFocusNavigation then nil else Enum.SelectionBehavior.Stop,
			SelectionBehaviorRight = if not FFlagEnableConsoleExpControls or FFlagExpChatEnableFocusNavigation then nil else Enum.SelectionBehavior.Stop,
			SelectionBehaviorUp = if not FFlagEnableConsoleExpControls or FFlagExpChatEnableFocusNavigation then nil else Enum.SelectionBehavior.Stop,
			SelectionGroup = FFlagEnableConsoleExpControls and not FFlagExpChatEnableFocusNavigation or nil,
			Size = UDim2.new(1, -p12.sendButtonContainerWidth, 0, 0)
		}
		local t17 = {}
		local createElement6 = React.createElement
		local v171 = ChannelChip
		local t18 = {}
		local n5 = 0

		t18.transparency = p12.transparencyValue:map(function(n6: number) -- line: 100
			-- upvalues: n5 (copy)
			return n5 + n6 * (1 - n5)
		end)
		t18.onAbsoluteSizeChanged = v142
		t18.onChannelChipActivated = if not FFlagExpChatFixBackspaceNilTargetChannel then p12.resetTargetChannel else function() -- line: 1485
			-- upvalues: p12 (copy)
			p12.resetTargetChannel(p12.isGlobalChatTabActive)
		end
		t18.targetTextChannelDisplayName = p12.targetTextChannelDisplayName or ""
		t18.isChannelBarVisible = p12.isChannelBarVisible
		t18.developerChannelTabsEnabled = p12.developerChannelTabsEnabled
		t17.TargetChannelChip = createElement6(v171, t18)

		local v174 = if not FFlagExpChatUseMessagesStore then not p12.canLocalUserChat else not u129

		if v174 then
			local createElement7 = React.createElement
			local t19 = {
				BackgroundTransparency = 1,
				TextWrapped = true,
				AnchorPoint = Vector2.new(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Font = Config.ChatInputBarFont,
				Text = p12.disabledChatPlaceholderText,
				Position = UDim2.fromScale(1, 0),
				Size = v115:map(function(n7: number) -- line: 1502
					return UDim2.new(1, -(n7 + 8), 0, 0)
				end),
				TextColor3 = v146 and chatInputBarSettings.PlaceholderColor3 or chatInputBarSettings.TextColor3,
				TextSize = if not isSpatialUIEnabled then chatInputBarSettings.TextSize else chatInputBarSettings.SpatialPanelTextSize
			}
			local v177 = not v146 and 0 or 0.5

			t19.TextTransparency = p12.transparencyValue:map(function(n8: number) -- line: 100
				-- upvalues: v177 (copy)
				return v177 + n8 * (1 - v177)
			end)
			t19.Selectable = not not v63 or nil
			t19.SelectionImageObject = if not v63 then nil else v143
			t19.TextXAlignment = Enum.TextXAlignment.Left
			t19.TextYAlignment = Enum.TextYAlignment.Top
			t19.ref = if not v63 then nil else v121
			v174 = createElement7("TextLabel", t19)
		end

		t17.DisabledPlaceholderLabel = v174

		local v178 = if not FFlagExpChatUseMessagesStore then p12.canLocalUserChat else u129

		if v178 then
			local createElement8 = React.createElement
			local t20 = {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Position = UDim2.fromScale(1, 0),
				Size = v115:map(function(n9: number) -- line: 1530
					return UDim2.new(1, -(n9 + 8), 0, 0)
				end)
			}
			local t21 = {}
			local v182 = if not FFlagExpChatUseMessagesStore then p12.canLocalUserChat else u129

			if v182 then
				local createElement9 = React.createElement
				local t22 = {
					AnchorPoint = Vector2.new(0, 0),
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundTransparency = 1,
					ClearTextOnFocus = false,
					FontFace = chatInputBarSettings.FontFace,
					PlaceholderText = v146 and p12.placeholderText or "",
					Selectable = not not FFlagEnableConsoleExpControls or nil,
					SelectionImageObject = v143,
					Size = UDim2.fromScale(1, 0),
					Text = "",
					PlaceholderColor3 = chatInputBarSettings.PlaceholderColor3,
					TextColor3 = chatInputBarSettings.TextColor3,
					TextSize = if not isSpatialUIEnabled then chatInputBarSettings.TextSize else chatInputBarSettings.SpatialPanelTextSize
				}
				local v185 = not v146 and 0 or 0.5

				t22.TextTransparency = p12.transparencyValue:map(function(n10: number) -- line: 100
					-- upvalues: v185 (copy)
					return v185 + n10 * (1 - v185)
				end)

				local TextStrokeTransparency = chatInputBarSettings.TextStrokeTransparency

				t22.TextStrokeTransparency = p12.transparencyValue:map(function(n11: number) -- line: 100
					-- upvalues: TextStrokeTransparency (copy)
					return TextStrokeTransparency + n11 * (1 - TextStrokeTransparency)
				end)
				t22.TextStrokeColor3 = chatInputBarSettings.TextStrokeColor3
				t22.TextWrapped = true
				t22.TextXAlignment = Enum.TextXAlignment.Left
				t22.TextYAlignment = Enum.TextYAlignment.Top
				t22.ZIndex = 2
				t22[React.Event.Focused] = v137
				t22[React.Event.FocusLost] = v138
				t22[React.Change.Text] = v140
				t22[React.Event.ReturnPressedFromOnScreenKeyboard] = v141
				t22.ref = if not chatInputBarSettings.TextBox then v118 else v119
				v182 = createElement9("TextBox", t22)
			end

			t21.TextBox = v182
			v178 = createElement8("Frame", t20, t21)
		end

		t17.TextBoxContainer = v178
		t17.UIPadding = React.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, 10),
			PaddingLeft = UDim.new(0, 10),
			PaddingRight = UDim.new(0, 10),
			PaddingTop = UDim.new(0, 10)
		})
		t15.TextContainer = createElement5("Frame", t16, t17)

		local createElement10 = React.createElement
		local t23 = {
			AnchorPoint = Vector2.new(1, 0),
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Position = UDim2.fromScale(1, 0),
			Selectable = not FFlagExpChatEnableFocusNavigation and nil,
			Size = UDim2.new(0, p12.sendButtonContainerWidth, 1, 0),
			Text = "",
			[React.Event.Activated] = v134
		}
		local t24 = {
			Layout = React.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center
			})
		}
		local createElement11 = React.createElement
		local v191 = ImageSetLabel
		local t25 = {
			BackgroundTransparency = 1,
			ZIndex = 2,
			ImageColor3 = v145 and chatInputBarSettings.PlaceholderColor3 or chatInputBarSettings.TextColor3
		}
		local v193 = not v145 and 0 or 0.5

		t25.ImageTransparency = p12.transparencyValue:map(function(n12: number) -- line: 100
			-- upvalues: v193 (copy)
			return v193 + n12 * (1 - v193)
		end)
		t25.Image = Images["icons/actions/send"]
		t25.Size = UDim2.new(0, 30, 0, 30)
		t24.SendIcon = createElement11(v191, t25)
		t15.SendButton = createElement10("TextButton", t23, t24)
		t12.Container = createElement4("Frame", t14, t15)
		v157 = createElement2("Frame", t11, t12)
	end

	t10.Background = v157

	return createElement("Frame", t9, t10)
end

local v84 = Localization.connect(function(p33) -- line: 1615
	-- upvalues: getOtherDisplayNameInWhisperChannel (copy)
	local t27 = nil

	if p33.targetTextChannel then
		local t26 = {
			RBXTeam = "CoreScripts.TextChat.TeamChat.PrefixText",
			RBXWhisper = "CoreScripts.TextChat.WhisperChat.PrefixText.Outgoing"
		}

		for k, v in pairs(t26) do
			if string.match(p33.targetTextChannel.Name, k) then
				if k == "RBXWhisper" then
					local v199 = getOtherDisplayNameInWhisperChannel(p33.targetTextChannel, p33.localPlayer)

					if v199 then
						t27 = {
							v,
							{
								RBX_NAME = v199
							}
						}
					end
				else
					t27 = v
				end
			end
		end
	end

	return {
		targetTextChannelDisplayName = t27
	}
end)(ChatInputBar)

return React.memo(v84)
