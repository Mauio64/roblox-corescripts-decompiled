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
local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs
local FFlagExpChatDictation = SharedFlags.FFlagExpChatDictation
local FFlagExpChatContinuousDictation = SharedFlags.FFlagExpChatContinuousDictation
local v69 = FFlagExpChatDictation or FFlagExpChatContinuousDictation
local DictationInputBar = require(script.Parent.Dictation.DictationInputBar)
local useSendTelemetry = require(script.Parent.Dictation.useSendTelemetry)
local ActionBindableEvent = ExpChatShared.ActionBindableEvent
local v73 = GetFocusNavigationStore(false)

local function setTransparency(p1, p2) -- line: 98
	return p2:map(function(n1: number) -- line: 99
		-- upvalues: p1 (copy)
		return p1 + n1 * (1 - p1)
	end)
end

local u75 = nil
local u76 = nil
local u77 = nil
local RBXTeamCommandname = nil
local RBXWhisperCommandname = nil

local function onChatInputBarFocusLost(p3: ((...any) -> ...any)?, t1: {[any]: any}?, p4) -- line: 110
	-- upvalues: UserInputService (copy), GuiService (copy)
	local t2 = { Enum.KeyCode.ButtonB }
	local v90 = t1 or t2
	local u91 = nil

	u91 = UserInputService.InputBegan:Connect(function(input) -- line: 114
		-- upvalues: v90 (copy), GuiService (copy), p4 (copy), p3 (copy), u91 (ref)
		local v201 = if not input then nil else input.KeyCode

		for _, v203 in v90 do
			if v201 == v203 then
				GuiService:SetMenuIsOpen(false, "ExperienceChat")
				p4()

				if p3 then
					p3()
				else
					GuiService.SelectedCoreObject = nil
				end

				if not u91 then
					return
				end

				u91:Disconnect()
				u91 = nil

				return
			end
		end
	end)

	return u91
end
local function useEffectChatInputBarFocus(p5, p6, p7, p8, p9) -- line: 138
	-- upvalues: FFlagConsoleChatUseChromeFocusUtils (copy), React (copy), FFlagExpChatEnableFocusNavigation (copy), Signals (copy), v73 (copy), v63 (copy), GuiService (copy), UserInputService (copy), FocusUtils (copy), FFlagChromeChatGamepadSupportFix (copy), FFlagEnableConsoleExpControls (copy), onChatInputBarFocusLost (copy), ActionBindableEvent (copy)
	if FFlagConsoleChatUseChromeFocusUtils then
		React.useEffect(function() -- line: 140
			-- upvalues: FFlagExpChatEnableFocusNavigation (copy), Signals (copy), v73 (copy), p6 (copy), p5 (copy), v63 (copy), p7 (copy), GuiService (copy), p8 (copy), UserInputService (copy), FocusUtils (copy), p9 (copy)
			local t3 = {
				[Enum.KeyCode.DPadUp] = not FFlagExpChatEnableFocusNavigation or nil
			}
			local connection = nil
			local v206 = Signals.createEffect(function(p10) -- line: 146
				-- upvalues: v73 (copy), p6 (copy), p5 (copy), v63 (copy), p7 (copy), GuiService (copy), p8 (copy), connection (ref), UserInputService (copy), t3 (copy), FocusUtils (copy), p9 (copy)
				local v313 = v73.getChatInputBarFocused(p10)
				local v314 = if not p6.current then p5.current else p6.current

				if v63 then
					v314 = v314 or p7.current
				end

				if not v314 then
					return
				end

				if v313 then
					GuiService:SetMenuIsOpen(true, "ExperienceChat")
					p8()
					GuiService.SelectedCoreObject = v314

					if not connection then
						connection = UserInputService.InputBegan:Connect(function(input) -- line: 168
							-- upvalues: t3 (copy), FocusUtils (copy), v73 (copy)
							if input and t3[input.KeyCode] then
								FocusUtils.FocusOnChrome(function() -- line: 171
									-- upvalues: v73 (copy)
									v73.unfocusChatInputBar()
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

			return function() -- line: 187
				-- upvalues: v206 (copy), connection (ref)
				v206()

				if connection then
					connection:Disconnect()
					connection = nil
				end
			end
		end, {})

		return
	end

	if FFlagChromeChatGamepadSupportFix then
		React.useEffect(function() -- line: 197
			-- upvalues: p6 (copy), p5 (copy), FFlagEnableConsoleExpControls (copy), GuiService (copy), p8 (copy), onChatInputBarFocusLost (copy), p9 (copy), ActionBindableEvent (copy)
			local u207 = nil
			local u208 = nil
			local connection = ActionBindableEvent.Event:Connect(function(p11) -- line: 201
				-- upvalues: p6 (copy), p5 (copy), FFlagEnableConsoleExpControls (copy), GuiService (copy), p8 (copy), u208 (ref), u207 (ref), onChatInputBarFocusLost (copy), p9 (copy)
				local v316 = if not p6.current then p5.current else p6.current

				if FFlagEnableConsoleExpControls and (p11.type == "ChatTopBarFocusSelect" and v316) then
					GuiService:SetMenuIsOpen(true, "ExperienceChat")
					p8()
					GuiService.SelectedCoreObject = v316
					u208 = task.delay(0, function() -- line: 213
						-- upvalues: u208 (ref), u207 (ref), onChatInputBarFocusLost (copy), p11 (copy), p9 (copy)
						u208 = nil

						if u207 then
							u207:Disconnect()
						end

						u207 = onChatInputBarFocusLost(p11.onSelectionLost, p11.keybinds, p9)
					end)
				end
			end)

			return function() -- line: 227
				-- upvalues: connection (copy), u208 (ref), u207 (ref)
				connection:disconnect()

				if u208 then
					task.cancel(u208)
					u208 = nil
				end

				if u207 then
					u207:Disconnect()
					u207 = nil
				end
			end
		end, {
			p5.current,
			p6.current
		})
	end
end
local function ChatInputBar(p12) -- line: 243
	-- upvalues: React (copy), FFlagExpChatUseUnifiedTooltipStore (copy), GetChatTooltipStore (copy), v69 (copy), useSendTelemetry (copy), FFlagExpChatEnableFocusNavigation (copy), ReactFocusNavigation (copy), FFlagExpChatFocusViaLastModeFix (copy), FocusNavigationUtils (copy), SignalsReact (copy), v73 (copy), FFlagExpChatUseMessagesStore (copy), GetMessagesStore (copy), FFlagExpChatPresetChatEnabled (copy), GetPresetChatStore (copy), TextChatService (copy), u76 (ref), AutocompleteText (copy), initializeCommands (copy), getEnableChatInputBarConfigurationAutocompleteEnabled (copy), u75 (ref), initializeEmojis (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), u77 (ref), initializeGlobalCommands (copy), initialCommands (copy), v27 (copy), FFlagExpChatDictation (copy), FFlagExpChatPresetChatGamepadEnabled (copy), GuiService (copy), v64 (copy), v50 (copy), IXPServiceWrapper (copy), v51 (copy), FFlagExpChatBackspaceExitsTargetChannelInGlobalTabs (copy), Config (copy), Players (copy), FFlagEnableConsoleExpControls (copy), FFlagChromeChatGamepadSupportFix (copy), onChatInputBarFocusLost (copy), ActionBindableEvent (copy), useEffectChatInputBarFocus (copy), sortCommandResultsCallback (copy), sortEmojiResultsCallback (copy), List (copy), RBXTeamCommandname (ref), RBXTeamCommand (copy), RBXWhisperCommandname (ref), RBXWhisperCommand (copy), v62 (copy), autoCastCommand (copy), Promise (copy), useCursor (copy), v52 (copy), v53 (copy), useInterpolatedClientSettings (copy), FFlagExpChatNewInputBar (copy), AutocompleteDropdown (copy), setTransparency (copy), FFlagExpChatNewInputBarDictation (copy), ChatInputBarV2Dictation (copy), ChatInputBarV2 (copy), DictationInputBar (copy), v63 (copy), ChannelChip (copy), ImageSetLabel (copy), Images (copy)
	local v98 = React.useRef("")

	if FFlagExpChatUseUnifiedTooltipStore then
		local setIsChatInputBarVisible = GetChatTooltipStore(false).setIsChatInputBarVisible

		React.useEffect(function() -- line: 251
			-- upvalues: p12 (copy), setIsChatInputBarVisible (copy)
			if p12.visible ~= nil then
				setIsChatInputBarVisible(p12.visible)
			else
				setIsChatInputBarVisible(true)
			end

			return function() -- line: 260
				-- upvalues: setIsChatInputBarVisible (copy)
				setIsChatInputBarVisible(false)
			end
		end, {
			p12.visible,
			setIsChatInputBarVisible
		})
	end

	local v100, v101 = React.useState("")
	local v102, v103 = React.useState(0)
	local u104 = v102
	local u105 = v103
	local v106, v107 = React.useState(0)
	local u108 = v106
	local u109 = v107
	local v110, v111 = React.useState(false)
	local v112, _ = React.useState(true)
	local v114, v115 = React.useBinding(0)
	local v116 = React.useRef(false)
	local v117 = React.useRef(nil)
	local v118 = React.useRef(nil)
	local v119 = if not v69 then nil else useSendTelemetry({
		enabled = v69,
		textBoxRef = v117,
		customTextBoxRef = v118
	})
	local v120 = React.useRef(nil)
	local v121 = React.useRef(nil)
	local v122 = React.useRef(nil)
	local v123 = React.useRef(nil)
	local v124 = React.useRef(false)
	local v125 = if not FFlagExpChatEnableFocusNavigation then nil else ReactFocusNavigation.useFocusGuiObject()
	local v126 = if not FFlagExpChatEnableFocusNavigation or FFlagExpChatFocusViaLastModeFix then nil else FocusNavigationUtils.useLastInputMode()
	local v127 = if not FFlagExpChatFocusViaLastModeFix then nil else SignalsReact.useSignalState(v73.getChatInputBarFocused)
	local u128 = nil

	if FFlagExpChatUseMessagesStore then
		local v129 = GetMessagesStore(false)

		u128 = SignalsReact.useSignalState(v129.getCanLocalUserChat)
	end

	local v130 = if not FFlagExpChatPresetChatEnabled then nil else SignalsReact.useSignalState(GetPresetChatStore(false).getIsTrayOpen)
	local v131 = if not FFlagExpChatPresetChatEnabled then nil else SignalsReact.useSignalState(GetPresetChatStore(false).getIsEnabled)
	local v132 = React.useRef(false)

	React.useEffect(function() -- line: 325
		-- upvalues: v118 (copy), p12 (copy)
		v118.current = p12.chatInputBarSettings.TextBox
	end, { p12.chatInputBarSettings.TextBox == nil and "nil" or p12.chatInputBarSettings.TextBox })
	React.useEffect(function() -- line: 330
		-- upvalues: p12 (copy), TextChatService (copy), u76 (ref), AutocompleteText (copy), initializeCommands (copy), getEnableChatInputBarConfigurationAutocompleteEnabled (copy), u75 (ref), initializeEmojis (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), u77 (ref), initializeGlobalCommands (copy), initialCommands (copy)
		if not p12.autocompleteEnabled then
			return
		end

		local t4 = {}
		local connection = TextChatService.DescendantAdded:Connect(function(descendant) -- line: 335
			-- upvalues: u76 (ref), AutocompleteText (copy), initializeCommands (copy), t4 (copy)
			if descendant:IsA("TextChatCommand") and string.sub(descendant.PrimaryAlias, 1, 1) == "/" then
				u76 = AutocompleteText.new(initializeCommands)

				local connection = descendant:GetPropertyChangedSignal("AutocompleteVisible"):Connect(function() -- line: 341
					-- upvalues: u76 (ref), AutocompleteText (copy), initializeCommands (copy)
					u76 = AutocompleteText.new(initializeCommands)
				end)

				table.insert(t4, connection)
			end
		end)
		local connection2 = TextChatService.DescendantRemoving:Connect(function(descendant) -- line: 348
			-- upvalues: u76 (ref), AutocompleteText (copy), initializeCommands (copy)
			if descendant:IsA("TextChatCommand") and string.sub(descendant.PrimaryAlias, 1, 1) == "/" then
				u76 = AutocompleteText.new(initializeCommands)
			end
		end)

		if getEnableChatInputBarConfigurationAutocompleteEnabled() then
			u76 = AutocompleteText.new(initializeCommands)
			u75 = AutocompleteText.new(initializeEmojis)

			if GetFFlagTextChatEnableUniverseChatTabs() then
				u77 = AutocompleteText.new(initializeGlobalCommands)
			end

			local v213 = initialCommands()

			if v213 then
				for _, v215 in v213 do
					table.insert(t4, (v215:GetPropertyChangedSignal("AutocompleteVisible"):Connect(function() -- line: 365
						-- upvalues: u76 (ref), AutocompleteText (copy), initializeCommands (copy)
						u76 = AutocompleteText.new(initializeCommands)
					end)))
				end
			end
		end

		return function() -- line: 373
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

	local v133 = React.useCallback(function() -- line: 386
		-- upvalues: v27 (copy), v100 (copy), FFlagExpChatUseMessagesStore (copy), u128 (ref), p12 (copy), v116 (copy), v117 (copy), v118 (copy), v119 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), FFlagExpChatDictation (copy), v101 (copy), FFlagExpChatPresetChatGamepadEnabled (copy), GuiService (copy), v124 (copy)
		v27:trace("onSendActivated with input text: '{}'", v100)

		local v216 = if not FFlagExpChatUseMessagesStore then p12.canLocalUserChat else u128

		if not v116.current or not v216 then
			v27:debug("onSendActivated could not send message. isMounted: {} canLocalUserChat: {}", tostring(v116.current), v216)

			return
		end

		if v117.current or v118.current then
			local v217 = if not v118.current then v117.current.Text else v118.current.Text
			local v218 = if not v119 then nil else v119.consumeOnSend(v217)
			local v219 = if not GetFFlagTextChatEnableUniverseChatTabs() or (not p12.isGlobalChatTabActive or not p12.onSendGlobalChat) then p12.onSendChat else p12.onSendGlobalChat

			if v219 and string.find(v217, "%S") ~= nil then
				if FFlagExpChatDictation then
					v219(v217, v218, v218 ~= nil)
				else
					v219(v217)
				end
			else
				v27:debug("onSendActivated could not send message. text: '{}' canLocalUserChat: {}", v217, v216)
			end

			if v118.current then
				v118.current.Text = ""
				v118.current:ReleaseFocus()
			end

			if v117.current then
				v117.current.Text = ""
				v117.current:ReleaseFocus()
			end

			v101("")

			if FFlagExpChatPresetChatGamepadEnabled then
				local v220 = v118.current or v117.current

				if v220 then
					GuiService.SelectedCoreObject = v220
				end
			end

			if p12.targetTextChannel and p12.targetTextChannelDisplayName ~= "" then
				v124.current = true

				return
			end
		else
			v27:debug("onSendActivated could not send message because textBoxRef.current was nil")
		end
	end, {
		v100,
		v118.current,
		u128,
		p12.canLocalUserChat,
		p12.isGlobalChatTabActive,
		p12.onSendChat or false,
		p12.onSendGlobalChat or false,
		p12.targetTextChannel or false,
		p12.targetTextChannelDisplayName,
		not not v119 and v119.consumeOnSend
	})
	local v134 = if not v69 then nil else React.useCallback(function(t5: {[any]: any}?) -- line: 473
		-- upvalues: FFlagExpChatUseMessagesStore (copy), u128 (ref), p12 (copy), v116 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), v118 (copy), v117 (copy), v101 (copy), FFlagExpChatPresetChatGamepadEnabled (copy), GuiService (copy), v124 (copy)
		local v222 = if not FFlagExpChatUseMessagesStore then p12.canLocalUserChat else u128

		if not v116.current or not v222 then
			return
		end

		local v223 = t5 and t5.textSent or ""
		local v224 = if not GetFFlagTextChatEnableUniverseChatTabs() or (not p12.isGlobalChatTabActive or not p12.onSendGlobalChat) then p12.onSendChat else p12.onSendGlobalChat

		if v224 and string.find(v223, "%S") ~= nil then
			v224(v223, t5, true)
		end

		if v118.current then
			v118.current.Text = ""
			v118.current:ReleaseFocus()
		end

		if v117.current then
			v117.current.Text = ""
			v117.current:ReleaseFocus()
		end

		v101("")

		if FFlagExpChatPresetChatGamepadEnabled then
			local v225 = v118.current or v117.current

			if v225 then
				GuiService.SelectedCoreObject = v225
			end
		end

		if p12.targetTextChannel and p12.targetTextChannelDisplayName ~= "" then
			v124.current = true
		end
	end, {
		v118.current,
		u128,
		p12.canLocalUserChat,
		p12.isGlobalChatTabActive,
		p12.onSendChat or false,
		p12.onSendGlobalChat or false,
		p12.targetTextChannel or false,
		p12.targetTextChannelDisplayName
	})
	local v135 = React.useCallback(function(p13) -- line: 521
		-- upvalues: p12 (copy), v118 (copy), v117 (copy), u104 (ref), v101 (copy), v116 (copy), FFlagExpChatFocusViaLastModeFix (copy), v127 (copy), v125 (copy), v126 (copy), v64 (copy), v27 (copy)
		p12.autocompleteDropdownActivated(false)
		p12.autocompleteDropdownResultsChanged({})

		local v227 = if not v118.current then v117.current else v118.current

		if v227 then
			local Text = v227.Text
			local v229 = string.sub(Text, 1, u104 - 1)
			local v230 = string.sub(Text, u104, #Text)
			local s1 = ""

			if p12.autocompleteDropdownReducer.autocompleteType == "emojis" then
				local EmojiLabelText = p13.EmojiLabel.Text

				s1 = string.gsub(v229, ":[^:]*$", EmojiLabelText)
			elseif p12.autocompleteDropdownReducer.autocompleteType == "commands" then
				local TextLabelText = p13.TextLabel.Text

				s1 = string.gsub(v229, "(/.*)", TextLabelText)
			end

			if v230 ~= "" then
				s1 ..= v230
			end

			v227.Text = s1
			v101(s1)

			if v116.current then
				v227:CaptureFocus()

				if FFlagExpChatFocusViaLastModeFix then
					if v127 then
						v125(v227)
					end
				elseif v126 == "Focus" then
					v125(v227)
				end

				if v230 ~= "" and not v64 then
					v227.CursorPosition = #s1 - #v230 + 1
				end
			end

			p12.autocompleteDropdownDeactivated()

			return
		end

		v27:error("Could not find textBox")
	end, if not FFlagExpChatEnableFocusNavigation then nil else {
		if not FFlagExpChatFocusViaLastModeFix then nil else v127,
		v125,
		v112,
		u104,
		if not FFlagExpChatFocusViaLastModeFix then v126 else nil,
		p12.autocompleteDropdownActivated,
		p12.autocompleteDropdownDeactivated,
		p12.autocompleteDropdownReducer and p12.autocompleteDropdownReducer.autocompleteType,
		p12.autocompleteDropdownResultsChanged
	})

	React.useEffect(function() -- line: 592
		-- upvalues: v116 (copy), v118 (copy), v117 (copy), v27 (copy)
		if v116.current then
			local v234 = if not v118.current then v117.current else v118.current

			if v234 then
				v234:CaptureFocus()

				return
			end

			v27:error("Could not focus chat input bar because textBox not found")
		end
	end, {
		p12.shouldFocusChatInputBar,
		v118.current
	})

	if FFlagExpChatPresetChatEnabled then
		React.useEffect(function() -- line: 604
			-- upvalues: v130 (copy), v118 (copy), v117 (copy)
			if not v130 then
				return
			end

			local v235 = if not v118.current then v117.current else v118.current

			if v235 and v235:IsFocused() then
				v235:ReleaseFocus()
			end
		end, { v130 })
	end

	React.useEffect(function() -- line: 615
		-- upvalues: v27 (copy), v116 (copy), v50 (copy), IXPServiceWrapper (copy), v51 (copy)
		v27:trace("Mounted")
		v116.current = true

		if v50 then
			IXPServiceWrapper:LogUserLayerExposure(v51)
		end

		return function() -- line: 623
			-- upvalues: v27 (copy), v116 (copy)
			v27:trace("Unmounting")
			v116.current = false
		end
	end, {})
	React.useEffect(function() -- line: 629
		-- upvalues: p12 (copy), v118 (copy), v117 (copy), u105 (ref)
		local connection = nil

		if p12.autocompleteEnabled then
			local v237 = if not v118.current then v117.current else v118.current

			if v237 then
				connection = v237:GetPropertyChangedSignal("CursorPosition"):Connect(function() -- line: 634
					-- upvalues: v237 (copy), u105 (ref)
					local CursorPosition = v237.CursorPosition

					if CursorPosition and CursorPosition ~= -1 then
						u105(CursorPosition)
					end
				end)
			end
		end

		return function() -- line: 643
			-- upvalues: connection (ref)
			if connection then
				connection:Disconnect()
			end
		end
	end, { v118.current })
	React.useEffect(function() -- line: 651
		-- upvalues: p12 (copy), v123 (copy)
		if p12.autocompleteEnabled then
			v123.current = p12.userInputService.InputBegan:connect(function(p14, _) -- line: 653
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

			return function() -- line: 675
				-- upvalues: v123 (copy)
				local current = v123.current

				if current and current.Connected then
					current:Disconnect()
				end

				v123.current = nil
			end
		end

		return function() -- line: 683
		end
	end, {
		p12.userInputService,
		p12.autocompleteDropdownReducer
	})
	React.useEffect(function() -- line: 687
		-- upvalues: GetFFlagTextChatEnableUniverseChatTabs (copy), p12 (copy), FFlagExpChatBackspaceExitsTargetChannelInGlobalTabs (copy), v122 (copy), v118 (copy), v117 (copy), v124 (copy), v27 (copy), v100 (copy)
		local v238 = GetFFlagTextChatEnableUniverseChatTabs() and not p12.developerChannelTabsEnabled
		local v239 = if not FFlagExpChatBackspaceExitsTargetChannelInGlobalTabs then not p12.isChannelBarVisible else not p12.isChannelBarVisible or v238

		v122.current = p12.userInputService.InputEnded:connect(function(p16, _) -- line: 695
			-- upvalues: v118 (copy), v117 (copy), v124 (copy), v239 (copy), p12 (copy), v27 (copy), v100 (copy)
			if if not v118.current then v117.current and (v117.current:IsFocused() and (p16 and p16.KeyCode == Enum.KeyCode.Backspace)) else v118.current and (v118.current:IsFocused() and (p16 and p16.KeyCode == Enum.KeyCode.Backspace)) then
				if v124.current and v239 then
					p12.resetTargetChannel()
					v27:debug("ChatInputBar ChatInputBarResetTargetChannel()")
					v124.current = false

					return
				end

				if v100 == "" and p12.targetTextChannelDisplayName ~= "" then
					v124.current = true
				end
			end
		end)

		return function() -- line: 722
			-- upvalues: v122 (copy)
			local current = v122.current

			if current and current.Connected then
				current:Disconnect()
			end

			v122.current = nil
		end
	end, {
		p12.userInputService,
		v118.current,
		p12.isChannelBarVisible,
		p12.targetTextChannelDisplayName,
		p12.resetTargetChannel,
		if not FFlagExpChatBackspaceExitsTargetChannelInGlobalTabs then nil else p12.developerChannelTabsEnabled
	})
	React.useEffect(function() -- line: 739
		-- upvalues: p12 (copy), Config (copy), v118 (copy), v117 (copy), v132 (copy)
		local function handleAction(_: string, p18, p19) -- line: 740
			-- upvalues: p12 (copy), Config (copy), v118 (copy), v117 (copy), v132 (copy)
			if p12.isChatHotkeyEnabled and p19 and (p19.KeyCode == Config.ChatInputBarDefaultFocusKeyCode or p19.KeyCode == p12.devDefinedFocusKeyCode) then
				local v332 = if not v118.current then v117.current else v118.current

				if v332 and p18 == Enum.UserInputState.Begin and v332 and not v332:IsFocused() then
					task.delay(0, function() -- line: 762
						-- upvalues: v332 (copy)
						v332:CaptureFocus()
					end)
					p12.focusChatHotKeyActivated()
					v132.current = true

					return Enum.ContextActionResult.Sink
				end
			end

			return Enum.ContextActionResult.Pass
		end

		p12.contextActionService:BindCoreAction("FocusChat", handleAction, false, Enum.UserInputType.Keyboard)

		return function() -- line: 786
			-- upvalues: p12 (copy)
			p12.contextActionService:UnbindCoreAction("FocusChat")
		end
	end, {
		p12.isChatHotkeyEnabled,
		p12.devDefinedFocusKeyCode,
		v132.current,
		v118.current
	})

	local v136 = React.useCallback(function() -- line: 800
		-- upvalues: v111 (copy), p12 (copy), TextChatService (copy)
		v111(true)
		p12.onFocus()

		local ChatInputBarConfiguration = TextChatService:FindFirstChildOfClass("ChatInputBarConfiguration")

		if ChatInputBarConfiguration then
			ChatInputBarConfiguration.IsFocusedWrite = true
		end
	end, { p12.onFocus })
	local v137 = React.useCallback(function(_, b1: boolean, p21) -- line: 806
		-- upvalues: v27 (copy), v121 (copy), FFlagExpChatEnableFocusNavigation (copy), p12 (copy), v135 (copy), v133 (copy), v116 (copy), v118 (copy), v117 (copy), u104 (ref), v64 (copy), v111 (copy), TextChatService (copy), v132 (copy), Players (copy)
		v27:debug("Focus lost with enter: {}", (tostring(b1)))

		local current = v121.current

		if b1 or FFlagExpChatEnableFocusNavigation and p21 and (p21.KeyCode == Enum.KeyCode.Return or p21.KeyCode == Enum.KeyCode.KeypadEnter) then
			if p12.autocompleteEnabled and current and p12.autocompleteDropdownReducer.activated and #p12.autocompleteDropdownReducer.results > 0 then
				local OffsetFrame = current.ScrollBarFrame.ScrollViewFrame.ScrollView.OffsetFrame

				for _, child in ipairs(OffsetFrame:GetChildren()) do
					if child.ClassName == "Frame" and child.LayoutOrder == p12.autocompleteDropdownReducer.selectedIndex then
						v135(child.TextLabelButton)

						return
					end
				end
			else
				v133()
			end
		end

		if v116.current then
			if p12.autocompleteEnabled and current and p12.autocompleteDropdownReducer.activated then
				if p21 then
					if p21.KeyCode == Enum.KeyCode.Escape then
						p12.autocompleteDropdownActivated(false)

						local v251 = if not v118.current then v117.current else v118.current

						if v251 then
							local v252 = u104

							v251:CaptureFocus()

							if not v64 then
								v251.CursorPosition = v252
							end

							return
						end

						v27:error("Could not focus chat input bar because textBox not found")
					else
						local PositionX = p21.Position.X
						local PositionY = p21.Position.Y
						local AbsolutePositionX = current.AbsolutePosition.X
						local v256 = AbsolutePositionX + current.AbsoluteSize.X
						local AbsolutePositionY = current.AbsolutePosition.Y
						local v258 = AbsolutePositionY + current.AbsoluteSize.Y

						if PositionX < AbsolutePositionX or v256 < PositionX or PositionY < AbsolutePositionY or v258 < PositionY then
							p12.autocompleteDropdownActivated(false)
						end
					end
				end
			else
				v111(false)
			end
		end

		p12.onUnfocus()

		local ChatInputBarConfiguration = TextChatService:FindFirstChildOfClass("ChatInputBarConfiguration")

		if ChatInputBarConfiguration then
			ChatInputBarConfiguration.IsFocusedWrite = false
		end

		if v132.current then
			local LocalPlayer = Players.LocalPlayer

			if LocalPlayer then
				local TextBox = Instance.new("TextBox")

				TextBox.Visible = false
				TextBox.Parent = LocalPlayer:FindFirstChildOfClass("PlayerGui")
				TextBox:CaptureFocus()
				TextBox:ReleaseFocus()
				TextBox:Destroy()
			end

			v132.current = false
		end
	end)

	React.useEffect(function() -- line: 911
		-- upvalues: FFlagEnableConsoleExpControls (copy), v118 (copy), v117 (copy), FFlagChromeChatGamepadSupportFix (copy), GuiService (copy), v136 (copy), onChatInputBarFocusLost (copy), v137 (copy), ActionBindableEvent (copy)
		local u262 = nil
		local u263 = nil
		local connection = ActionBindableEvent.Event:Connect(function(p22) -- line: 915
			-- upvalues: FFlagEnableConsoleExpControls (copy), v118 (copy), v117 (copy), FFlagChromeChatGamepadSupportFix (copy), GuiService (copy), v136 (copy), u263 (ref), u262 (ref), onChatInputBarFocusLost (copy), v137 (copy)
			local u334 = nil

			if FFlagEnableConsoleExpControls then
				u334 = if not v118.current then v117.current else v118.current
			end

			if p22.type == "ChatTopBarFocusActivated" then
				if not FFlagEnableConsoleExpControls then
					u334 = if not v118.current then v117.current else v118.current
				end

				if u334 then
					task.delay(0, function() -- line: 926
						-- upvalues: u334 (ref)
						u334:CaptureFocus()
					end)
				end
			elseif not FFlagChromeChatGamepadSupportFix and FFlagEnableConsoleExpControls and p22.type == "ChatTopBarFocusSelect" and u334 then
				GuiService:SetMenuIsOpen(true, "ExperienceChat")
				v136()
				GuiService.SelectedCoreObject = u334
				u263 = task.delay(0, function() -- line: 941
					-- upvalues: u263 (ref), u262 (ref), onChatInputBarFocusLost (copy), p22 (copy), v137 (copy)
					u263 = nil

					if u262 then
						u262:Disconnect()
					end

					u262 = onChatInputBarFocusLost(p22.onSelectionLost, p22.keybinds, v137)
				end)
			end
		end)

		return function() -- line: 955
			-- upvalues: connection (copy), u263 (ref), u262 (ref)
			connection:disconnect()

			if u263 then
				task.cancel(u263)
				u263 = nil
			end

			if u262 then
				u262:Disconnect()
				u262 = nil
			end
		end
	end, {
		v117.current,
		v118.current
	})
	useEffectChatInputBarFocus(v117, v118, v120, v136, v137)

	local function handleAutocomplete(p23, p24, p25) -- line: 973
		-- upvalues: p12 (copy), u77 (ref), u76 (ref), sortCommandResultsCallback (copy), u75 (ref), sortEmojiResultsCallback (copy), u108 (ref), List (copy), v101 (copy), v64 (copy), v121 (copy), v135 (copy), u109 (ref)
		if p25 == "/" and p23.CursorPosition == 2 or p12.autocompleteDropdownReducer.autocompleteType == "commands" and p25 ~= ":" then
			p12.autocompleteDropdownTypeChanged("commands")
			p12.autocompleteDropdownActivated(true)

			if p25 ~= "" and p25 ~= " " then
				local v268 = string.sub(p24, 1, p23.CursorPosition - 1):lower()
				local v269 = ((if not p12.isGlobalChatTabActive or not u77 then u76 else u77)):getResults(v268, sortCommandResultsCallback)

				p12.autocompleteDropdownResultsChanged(v269)

				if v268 == v269[1] then
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

			local v270 = string.sub(p24, 1, p23.CursorPosition - 1)
			local v271 = string.find(v270, ":[^:]*$")

			if p25 ~= "" and p25 ~= ":" and p25 ~= " " and v271 then
				local v272 = string.sub(p24, v271 + 1, p23.CursorPosition - 1):lower()
				local t6 = {}

				if v272 and string.len(v272) > 1 then
					t6 = u75:getResults(v272, sortEmojiResultsCallback)
				end

				p12.autocompleteDropdownResultsChanged(t6)

				return
			end

			if p25 == ":" then
				if v271 ~= u108 then
					local v274 = string.sub(p24, u108 + 1, p23.CursorPosition - 2):lower()

					if List.includes(p12.autocompleteDropdownReducer.results, v274) then
						local v275 = string.sub(p24, p23.CursorPosition, #p24)
						local v276 = string.sub(p24, 1, p23.CursorPosition - 2) .. v275

						p23.Text = v276
						v101(v276)

						if not v64 then
							p23.CursorPosition = p23.CursorPosition - 1
						end

						local current = v121.current

						if current then
							local OffsetFrame = current.ScrollBarFrame.ScrollViewFrame.ScrollView.OffsetFrame

							for _, child in ipairs(OffsetFrame:GetChildren()) do
								if child.ClassName ~= "Frame" then
									continue
								end

								local TextLabelButton = child:FindFirstChild("TextLabelButton")

								if TextLabelButton then
									local TextLabel = TextLabelButton:FindFirstChild("TextLabel")

									if not TextLabel or not TextLabel.Text or v274 ~= TextLabel.Text then
										continue
									end

									v135(TextLabelButton)

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
			u109(0)

			return
		end

		local v283 = string.find(p24, ":[^:]*$")

		if p25 == ":" then
			p12.autocompleteDropdownTypeChanged("emojis")
			p12.autocompleteDropdownActivated(true)
			p12.autocompleteDropdownResultsChanged({})
			u109(v283)
		end
	end

	React.useEffect(function() -- line: 1090
		-- upvalues: TextChatService (copy), RBXTeamCommandname (ref), RBXTeamCommand (copy), RBXWhisperCommandname (ref), RBXWhisperCommand (copy)
		if TextChatService.CreateDefaultCommands then
			RBXTeamCommandname = TextChatService:FindFirstChild(RBXTeamCommand.name, true)
			RBXWhisperCommandname = TextChatService:FindFirstChild(RBXWhisperCommand.name, true)
		end
	end, {})

	local v139 = React.useCallback(function(p26) -- line: 1097
		-- upvalues: p12 (copy), v101 (copy), v27 (copy), v100 (copy), getEnableChatInputBarConfigurationAutocompleteEnabled (copy), handleAutocomplete (copy), v124 (copy), v62 (copy), v98 (copy), RBXTeamCommandname (ref), autoCastCommand (copy), RBXTeamCommand (copy), RBXWhisperCommandname (ref), RBXWhisperCommand (copy), Promise (copy)
		local p26Text = p26.Text

		if p12.autocompleteEnabled then
			local v286 = string.find(p26Text, "\r")
			local v287 = p26.CursorPosition < #p26Text + 1

			if v286 then
				local v288 = string.gsub(p26Text, "\r", "")

				p26.Text = v288
				v101(v288)

				if v287 then
					p26.CursorPosition = p26.CursorPosition - 1
				end

				return
			end
		end

		local v289 = string.sub(p26Text, p26.CursorPosition - 1, p26.CursorPosition - 1)

		v27:trace("Input: {}", p26Text)

		local v290 = if not utf8.len(p26Text) then string.len(p26Text) else utf8.len(utf8.nfcnormalize(p26Text))

		if v290 and v290 > p12.messageCharacterLimit then
			v27:debug("Message is over the character limit of {}", (tostring(p12.messageCharacterLimit)))
			p26.Text = v100

			return
		end

		v101(p26Text)

		if getEnableChatInputBarConfigurationAutocompleteEnabled() and p12.autocompleteEnabled then
			handleAutocomplete(p26, p26Text, v289)
		end

		v124.current = #p26Text == 0 and v124.current

		if v62 then
			if string.sub(p26Text, 1, 1) == "/" and p12.localPlayer and p26Text ~= v98.current then
				v98.current = p26Text

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

				Promise.any(t7):andThen(function() -- line: 1153
					-- upvalues: p26 (copy), v101 (copy), v124 (copy)
					p26.Text = ""
					v101("")
					v124.current = true
				end):catch(function(p27) -- line: 1159
					-- upvalues: v27 (copy)
					v27:trace("Could not send autoCastCommand. Error: {}", p27)
				end)

				return
			end

			if string.sub(p26Text, 1, 1) ~= "/" then
				v98.current = ""

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

			Promise.any(t8):andThen(function() -- line: 1182
				-- upvalues: p26 (copy), v101 (copy), v124 (copy)
				p26.Text = ""
				v101("")
				v124.current = true
			end):catch(function(p28) -- line: 1188
				-- upvalues: v27 (copy)
				v27:trace("Could not send autoCastCommand. Error: {}", p28)
			end)
		end
	end)
	local v140 = React.useCallback(function() -- line: 1195
		-- upvalues: v118 (copy), v117 (copy)
		local v295 = if not v118.current then v117.current else v118.current

		if v295 then
			v295:ReleaseFocus(true)
		end
	end, {
		v117.current,
		v118.current
	})
	local v141 = React.useCallback(function(p29) -- line: 1202
		-- upvalues: v115 (copy)
		v115(p29.Visible and p29.AbsoluteSize.X or 0)
	end)
	local v142 = if not FFlagExpChatEnableFocusNavigation then nil else useCursor()
	local v143 = React.useCallback(function(p30) -- line: 1209
		-- upvalues: p12 (copy)
		p12.autocompleteDropdownSelectionChanged(p30.LayoutOrder)
	end)
	local v144 = v100 == ""
	local v145 = v144 and not v110
	local chatInputBarSettings = p12.chatInputBarSettings
	local chatWindowSettings = p12.chatWindowSettings
	local v148 = if not FFlagExpChatUseMessagesStore or u128 == nil then p12.canLocalUserChat else u128

	React.useEffect(function() -- line: 1224
		-- upvalues: v52 (copy), v148 (copy), IXPServiceWrapper (copy), v53 (copy)
		if v52 and v148 then
			IXPServiceWrapper:LogUserLayerExposure(v53)
		end
	end, { v148 })

	local BackgroundTransparency = useInterpolatedClientSettings(chatInputBarSettings).BackgroundTransparency
	local BackgroundTransparency2 = useInterpolatedClientSettings(chatWindowSettings).BackgroundTransparency
	local BackgroundColor3 = useInterpolatedClientSettings(chatWindowSettings).BackgroundColor3
	local isSpatialUIEnabled = p12.isSpatialUIEnabled
	local createElement = React.createElement
	local t9 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = BackgroundColor3,
		BackgroundTransparency = if not FFlagExpChatNewInputBar then p12.transparencyValue:map(function(n2: number) -- line: 99
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
		[React.Change.AbsoluteSize] = React.useCallback(function(p31) -- line: 1250
			-- upvalues: TextChatService (copy), p12 (copy)
			local ChatInputBarConfiguration = TextChatService:FindFirstChildOfClass("ChatInputBarConfiguration")

			if ChatInputBarConfiguration and p12.onAbsoluteSizeChanged then
				p12.onAbsoluteSizeChanged(p31, ChatInputBarConfiguration)
			end
		end),
		[React.Change.AbsolutePosition] = React.useCallback(function(p32) -- line: 1256
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
			activated = p12.autocompleteDropdownReducer.activated and v110,
			results = p12.autocompleteDropdownReducer.results,
			selectedIndex = p12.autocompleteDropdownReducer.selectedIndex,
			autocompleteType = p12.autocompleteDropdownReducer.autocompleteType,
			onAutocompleteDropdownHover = v143,
			onAutocompleteSelected = v135,
			autocompleteDropdownRef = v121,
			textBoxRef = if not chatInputBarSettings.TextBox then v117 else v118
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
		ChatInputBarV2 = if not FFlagExpChatNewInputBar then nil else if not FFlagExpChatNewInputBarDictation or (not v69 or not v148) then React.createElement(ChatInputBarV2, {
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
			canLocalUserChatDerived = u128,
			targetChannelWidth = v114,
			showPlaceholderText = v145,
			hasEmptyInputText = v144,
			shouldTruncatePlaceholder = if not FFlagExpChatPresetChatEnabled then nil else v131,
			cursor = v142,
			placeholderRef = v120,
			textBoxRef = v117,
			customTextBoxRef = v118,
			onAbsoluteSizeChanged = v141,
			onFocused = v136,
			onFocusLost = v137,
			onTextChanged = v139,
			onReturnPressedFromOnScreenKeyboard = v140,
			onSendActivated = v133
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
			canLocalUserChatDerived = u128,
			targetChannelWidth = v114,
			showPlaceholderText = v145,
			hasEmptyInputText = v144,
			shouldTruncatePlaceholder = if not FFlagExpChatPresetChatEnabled then nil else v131,
			cursor = v142,
			placeholderRef = v120,
			textBoxRef = v117,
			customTextBoxRef = v118,
			onAbsoluteSizeChanged = v141,
			onFocused = v136,
			onFocusLost = v137,
			onTextChanged = v139,
			onReturnPressedFromOnScreenKeyboard = v140,
			onSendActivated = v133,
			onSendRecordingTap = v134,
			onTranscriptionStaged = if not v119 then nil else v119.stageTranscription,
			inputText = v100,
			setInputText = v101,
			isGlobalChatTabActive = p12.isGlobalChatTabActive,
			onDictationActivityChanged = p12.onDictationActivityChanged
		})
	}
	local v156

	if FFlagExpChatNewInputBar then
		v156 = nil
	elseif v69 and v148 then
		v156 = React.createElement(DictationInputBar, {
			chatInputBarSettings = chatInputBarSettings,
			transparencyValue = p12.transparencyValue,
			chatInputBarBackgroundTransparency = BackgroundTransparency,
			inputText = v100,
			setInputText = v101,
			canLocalUserChat = v148,
			disabledChatPlaceholderText = p12.disabledChatPlaceholderText,
			targetChannelWidth = v114,
			showPlaceholderText = v145,
			placeholderText = p12.placeholderText,
			cursor = v142,
			placeholderRef = if not v63 then nil else v120,
			textBoxRef = v117,
			customTextBoxRef = v118,
			onFocused = v136,
			onFocusLost = v137,
			onTextChanged = v139,
			onReturnPressedFromOnScreenKeyboard = v140,
			onChannelChipAbsoluteSizeChanged = v141,
			onChannelChipActivated = p12.resetTargetChannel,
			targetTextChannel = p12.targetTextChannel,
			targetTextChannelDisplayName = p12.targetTextChannelDisplayName or "",
			isChannelBarVisible = p12.isChannelBarVisible,
			isGlobalChatTabActive = p12.isGlobalChatTabActive,
			developerChannelTabsEnabled = p12.developerChannelTabsEnabled,
			onDictationActivityChanged = p12.onDictationActivityChanged,
			onSendActivated = v133,
			onSendRecordingTap = v134,
			onTranscriptionStaged = if not v119 then nil else v119.stageTranscription,
			isSpatialUIEnabled = isSpatialUIEnabled,
			isTextBoxSelectable = not not FFlagEnableConsoleExpControls or nil,
			isPlaceholderSelectable = not not v63 or nil,
			placeholderSelectionImageObject = if not v63 then nil else v142,
			selectionBehavior = if not FFlagEnableConsoleExpControls or FFlagExpChatEnableFocusNavigation then nil else Enum.SelectionBehavior.Stop,
			selectionGroup = FFlagEnableConsoleExpControls and not FFlagExpChatEnableFocusNavigation or nil
		})
	else
		local createElement2 = React.createElement
		local t11 = {
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundColor3 = chatInputBarSettings.BackgroundColor3,
			BackgroundTransparency = if not FFlagExpChatNewInputBar then p12.transparencyValue:map(function(n3: number) -- line: 99
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

		t13.Transparency = p12.transparencyValue:map(function(n4: number) -- line: 99
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
		local v170 = ChannelChip
		local t18 = {}
		local n5 = 0

		t18.transparency = p12.transparencyValue:map(function(n6: number) -- line: 99
			-- upvalues: n5 (copy)
			return n5 + n6 * (1 - n5)
		end)
		t18.onAbsoluteSizeChanged = v141
		t18.onChannelChipActivated = p12.resetTargetChannel
		t18.targetTextChannelDisplayName = p12.targetTextChannelDisplayName or ""
		t18.isChannelBarVisible = p12.isChannelBarVisible
		t18.developerChannelTabsEnabled = p12.developerChannelTabsEnabled
		t17.TargetChannelChip = createElement6(v170, t18)

		local v173 = if not FFlagExpChatUseMessagesStore then not p12.canLocalUserChat else not u128

		if v173 then
			local createElement7 = React.createElement
			local t19 = {
				BackgroundTransparency = 1,
				TextWrapped = true,
				AnchorPoint = Vector2.new(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Font = Config.ChatInputBarFont,
				Text = p12.disabledChatPlaceholderText,
				Position = UDim2.fromScale(1, 0),
				Size = v114:map(function(n7: number) -- line: 1475
					return UDim2.new(1, -(n7 + 8), 0, 0)
				end),
				TextColor3 = v145 and chatInputBarSettings.PlaceholderColor3 or chatInputBarSettings.TextColor3,
				TextSize = if not isSpatialUIEnabled then chatInputBarSettings.TextSize else chatInputBarSettings.SpatialPanelTextSize
			}
			local v176 = not v145 and 0 or 0.5

			t19.TextTransparency = p12.transparencyValue:map(function(n8: number) -- line: 99
				-- upvalues: v176 (copy)
				return v176 + n8 * (1 - v176)
			end)
			t19.Selectable = not not v63 or nil
			t19.SelectionImageObject = if not v63 then nil else v142
			t19.TextXAlignment = Enum.TextXAlignment.Left
			t19.TextYAlignment = Enum.TextYAlignment.Top
			t19.ref = if not v63 then nil else v120
			v173 = createElement7("TextLabel", t19)
		end

		t17.DisabledPlaceholderLabel = v173

		local v177 = if not FFlagExpChatUseMessagesStore then p12.canLocalUserChat else u128

		if v177 then
			local createElement8 = React.createElement
			local t20 = {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Position = UDim2.fromScale(1, 0),
				Size = v114:map(function(n9: number) -- line: 1503
					return UDim2.new(1, -(n9 + 8), 0, 0)
				end)
			}
			local t21 = {}
			local v181 = if not FFlagExpChatUseMessagesStore then p12.canLocalUserChat else u128

			if v181 then
				local createElement9 = React.createElement
				local t22 = {
					AnchorPoint = Vector2.new(0, 0),
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundTransparency = 1,
					ClearTextOnFocus = false,
					FontFace = chatInputBarSettings.FontFace,
					PlaceholderText = v145 and p12.placeholderText or "",
					Selectable = not not FFlagEnableConsoleExpControls or nil,
					SelectionImageObject = v142,
					Size = UDim2.fromScale(1, 0),
					Text = "",
					PlaceholderColor3 = chatInputBarSettings.PlaceholderColor3,
					TextColor3 = chatInputBarSettings.TextColor3,
					TextSize = if not isSpatialUIEnabled then chatInputBarSettings.TextSize else chatInputBarSettings.SpatialPanelTextSize
				}
				local v184 = not v145 and 0 or 0.5

				t22.TextTransparency = p12.transparencyValue:map(function(n10: number) -- line: 99
					-- upvalues: v184 (copy)
					return v184 + n10 * (1 - v184)
				end)

				local TextStrokeTransparency = chatInputBarSettings.TextStrokeTransparency

				t22.TextStrokeTransparency = p12.transparencyValue:map(function(n11: number) -- line: 99
					-- upvalues: TextStrokeTransparency (copy)
					return TextStrokeTransparency + n11 * (1 - TextStrokeTransparency)
				end)
				t22.TextStrokeColor3 = chatInputBarSettings.TextStrokeColor3
				t22.TextWrapped = true
				t22.TextXAlignment = Enum.TextXAlignment.Left
				t22.TextYAlignment = Enum.TextYAlignment.Top
				t22.ZIndex = 2
				t22[React.Event.Focused] = v136
				t22[React.Event.FocusLost] = v137
				t22[React.Change.Text] = v139
				t22[React.Event.ReturnPressedFromOnScreenKeyboard] = v140
				t22.ref = if not chatInputBarSettings.TextBox then v117 else v118
				v181 = createElement9("TextBox", t22)
			end

			t21.TextBox = v181
			v177 = createElement8("Frame", t20, t21)
		end

		t17.TextBoxContainer = v177
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
			[React.Event.Activated] = v133
		}
		local t24 = {
			Layout = React.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center
			})
		}
		local createElement11 = React.createElement
		local v190 = ImageSetLabel
		local t25 = {
			BackgroundTransparency = 1,
			ZIndex = 2,
			ImageColor3 = v144 and chatInputBarSettings.PlaceholderColor3 or chatInputBarSettings.TextColor3
		}
		local v192 = not v144 and 0 or 0.5

		t25.ImageTransparency = p12.transparencyValue:map(function(n12: number) -- line: 99
			-- upvalues: v192 (copy)
			return v192 + n12 * (1 - v192)
		end)
		t25.Image = Images["icons/actions/send"]
		t25.Size = UDim2.new(0, 30, 0, 30)
		t24.SendIcon = createElement11(v190, t25)
		t15.SendButton = createElement10("TextButton", t23, t24)
		t12.Container = createElement4("Frame", t14, t15)
		v156 = createElement2("Frame", t11, t12)
	end

	t10.Background = v156

	return createElement("Frame", t9, t10)
end

local v83 = Localization.connect(function(p33) -- line: 1588
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
					local v198 = getOtherDisplayNameInWhisperChannel(p33.targetTextChannel, p33.localPlayer)

					if v198 then
						t27 = {
							v,
							{
								RBX_NAME = v198
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

return React.memo(v83)
