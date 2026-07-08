local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local React = require(ExpChatParent.React)
local Foundation = require(ExpChatParent.Foundation)
local FFlagExpChatDictationFTUX = require(ExpChat.Flags.FFlagExpChatDictationFTUX)
local Config = require(ExpChat.Config)
local ChannelChip = require(script.Parent.Parent.ChannelChip)
local DictationFTUX = require(script.Parent.DictationFTUX)
local StopCountdown = require(script.Parent.Parent.StopCountdown)
local DictationWaveform = require(script.Parent.DictationWaveform)
local useDictationInputBar = require(script.Parent.useDictationInputBar)
local useDictationTextArea = require(script.Parent.useDictationTextArea)
local DictationAffordances = require(script.Parent.DictationAffordances)

local function lerp(n1: number, n2: number, n3: number) -- line: 23
	return n1 + (n2 - n1) * n3
end
local function setTransparency(p1, p2) -- line: 29
	return p2:map(function(n4: number) -- line: 30
		-- upvalues: p1 (copy)
		local v51 = p1

		return v51 + (1 - v51) * n4
	end)
end
local function DictationInputBar(p3) -- line: 35
	-- upvalues: Foundation (copy), useDictationInputBar (copy), DictationAffordances (copy), React (copy), useDictationTextArea (copy), Config (copy), StopCountdown (copy), ChannelChip (copy), DictationWaveform (copy), FFlagExpChatDictationFTUX (copy), DictationFTUX (copy)
	local v23 = Foundation.Hooks.useTokens()
	local v24 = useDictationInputBar({
		inputText = p3.inputText,
		setInputText = p3.setInputText,
		chatInputBarSettings = p3.chatInputBarSettings,
		customTextBoxRef = p3.customTextBoxRef,
		textBoxRef = p3.textBoxRef,
		targetTextChannel = p3.targetTextChannel,
		isGlobalChatTabActive = p3.isGlobalChatTabActive,
		onDictationActivityChanged = p3.onDictationActivityChanged,
		onSendRecordingTap = p3.onSendRecordingTap,
		onTranscriptionStaged = p3.onTranscriptionStaged
	})
	local v25 = DictationAffordances.deriveMicSendButton(v24, {
		idleSendDisabled = false,
		hasEmptyInputText = p3.inputText == "",
		idleSendIcon = Foundation.Enums.IconName.PaperAirplane,
		idleSendVariant = Foundation.Enums.ButtonVariant.Emphasis,
		idleSendActivated = p3.onSendActivated
	})
	local v26 = DictationAffordances.deriveBackgroundColors(v24, {
		defaultColor3 = p3.chatInputBarSettings.BackgroundColor3,
		defaultTransparency = p3.chatInputBarBackgroundTransparency,
		listeningColor3 = v23.Color.Shift.Shift_200.Color3,
		listeningTransparency = v23.Color.Shift.Shift_200.Transparency
	})
	local v27 = React.useMemo(function() -- line: 70
		-- upvalues: p3 (copy), v26 (copy)
		return p3.transparencyValue:map(function(n5: number) -- line: 71
			-- upvalues: v26 (copy)
			local t1 = {
				Color3 = v26.color3
			}
			local baseTransparency = v26.baseTransparency

			t1.Transparency = baseTransparency + (1 - baseTransparency) * n5

			return t1
		end)
	end, {
		p3.transparencyValue,
		v26.color3,
		v26.baseTransparency
	})
	local v28 = DictationAffordances.shouldPreventFade(v24)
	local v29 = React.useMemo(function() -- line: 83
		-- upvalues: v28 (copy), p3 (copy)
		if v28 then
			return p3.transparencyValue:map(function(_: number) -- line: 85
				return 0
			end)
		end

		return p3.transparencyValue
	end, {
		v28,
		p3.transparencyValue
	})
	local v30 = useDictationTextArea(v24, {
		transparencyValue = p3.transparencyValue,
		showPlaceholderText = p3.showPlaceholderText
	})
	local useLongPressOverlay = v25.useLongPressOverlay
	local micGestureHandlers = v24.micGestureHandlers
	local createElement = React.createElement
	local View = Foundation.View
	local t2 = {
		Name = "Background",
		tag = "row align-y-center gap-small size-full-0 auto-y padding-x-xsmall radius-medium",
		backgroundStyle = v27
	}
	local t3 = {
		Color = Config.ChatInputBarBorderColor3
	}
	local ChatInputBarBorderTransparency = Config.ChatInputBarBorderTransparency

	t3.Transparency = p3.transparencyValue:map(function(n7: number) -- line: 30
		-- upvalues: ChatInputBarBorderTransparency (copy)
		local v53 = ChatInputBarBorderTransparency

		return v53 + (1 - v53) * n7
	end)
	t2.stroke = t3

	local t4 = {
		StopCountdown = React.createElement(StopCountdown, {
			LayoutOrder = 1,
			countdownProgress = v24.dictation.bindings.countdownProgress,
			onActivated = v24.dictation.stopDictation,
			Visible = v24.dictation.bindings.isRecording
		})
	}
	local createElement2 = React.createElement
	local t5 = {
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(0, 0),
		SelectionBehaviorDown = p3.selectionBehavior,
		SelectionBehaviorLeft = p3.selectionBehavior,
		SelectionBehaviorRight = p3.selectionBehavior,
		SelectionBehaviorUp = p3.selectionBehavior,
		SelectionGroup = p3.selectionGroup
	}
	local t6 = {}
	local createElement3 = React.createElement
	local v43 = ChannelChip
	local t7 = {}
	local n8 = 0

	t7.transparency = p3.transparencyValue:map(function(n9: number) -- line: 30
		-- upvalues: n8 (copy)
		local v55 = n8

		return v55 + (1 - v55) * n9
	end)
	t7.onAbsoluteSizeChanged = p3.onChannelChipAbsoluteSizeChanged
	t7.onChannelChipActivated = p3.onChannelChipActivated
	t7.targetTextChannelDisplayName = p3.targetTextChannelDisplayName or ""
	t7.isChannelBarVisible = p3.isChannelBarVisible
	t7.developerChannelTabsEnabled = p3.developerChannelTabsEnabled
	t6.TargetChannelChip = createElement3(v43, t7)

	local v46 = not p3.canLocalUserChat

	if v46 then
		local createElement4 = React.createElement
		local t8 = {
			BackgroundTransparency = 1,
			TextWrapped = true,
			AnchorPoint = Vector2.new(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Font = Config.ChatInputBarFont,
			Text = p3.disabledChatPlaceholderText,
			Position = UDim2.fromScale(1, 0),
			Size = p3.targetChannelWidth:map(function(n10: number) -- line: 141
				return UDim2.new(1, -(n10 + 8), 0, 0)
			end),
			TextColor3 = p3.showPlaceholderText and p3.chatInputBarSettings.PlaceholderColor3 or p3.chatInputBarSettings.TextColor3,
			TextSize = if not p3.isSpatialUIEnabled then p3.chatInputBarSettings.TextSize else p3.chatInputBarSettings.SpatialPanelTextSize
		}
		local v49 = not p3.showPlaceholderText and 0 or 0.5

		t8.TextTransparency = p3.transparencyValue:map(function(n11: number) -- line: 30
			-- upvalues: v49 (copy)
			local v58 = v49

			return v58 + (1 - v58) * n11
		end)
		t8.Selectable = p3.isPlaceholderSelectable
		t8.SelectionImageObject = p3.placeholderSelectionImageObject
		t8.TextXAlignment = Enum.TextXAlignment.Left
		t8.TextYAlignment = Enum.TextYAlignment.Top
		t8.ref = p3.placeholderRef
		v46 = createElement4("TextLabel", t8)
	end

	t6.DisabledPlaceholderLabel = v46
	t6.TextBoxContainer = p3.canLocalUserChat and React.createElement("Frame", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = UDim2.fromScale(1, 0),
		Size = p3.targetChannelWidth:map(function(n12: number) -- line: 165
			return UDim2.new(1, -(n12 + 8), 0, 0)
		end)
	}, {
		TextBox = React.createElement("TextBox", {
			AnchorPoint = Vector2.new(0, 0),
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			ClearTextOnFocus = false,
			FontFace = p3.chatInputBarSettings.FontFace,
			PlaceholderText = p3.showPlaceholderText and p3.placeholderText or "",
			Selectable = p3.isTextBoxSelectable,
			SelectionImageObject = p3.cursor,
			Size = UDim2.fromScale(1, 0),
			Text = "",
			PlaceholderColor3 = p3.chatInputBarSettings.PlaceholderColor3,
			TextColor3 = p3.chatInputBarSettings.TextColor3,
			TextSize = if not p3.isSpatialUIEnabled then p3.chatInputBarSettings.TextSize else p3.chatInputBarSettings.SpatialPanelTextSize,
			TextTransparency = v30.textTransparency,
			TextStrokeTransparency = v30.textStrokeTransparency,
			TextStrokeColor3 = p3.chatInputBarSettings.TextStrokeColor3,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			ZIndex = 2,
			[React.Event.Focused] = p3.onFocused,
			[React.Event.FocusLost] = p3.onFocusLost,
			[React.Change.Text] = p3.onTextChanged,
			[React.Event.ReturnPressedFromOnScreenKeyboard] = p3.onReturnPressedFromOnScreenKeyboard,
			ref = if not p3.chatInputBarSettings.TextBox then p3.textBoxRef else p3.customTextBoxRef
		})
	}) or nil
	t6.WaveformOverlay = React.createElement("Frame", {
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		ZIndex = 3,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.fromScale(0, 0.5),
		Size = UDim2.new(1, 0, 0, if not p3.isSpatialUIEnabled then p3.chatInputBarSettings.TextSize else p3.chatInputBarSettings.SpatialPanelTextSize),
		Visible = v24.dictation.bindings.isAudioActive
	}, {
		List = React.createElement(DictationWaveform, {
			isActive = v24.isRecording or v24.isListening,
			audioDeviceInput = v24.dictation.audioDeviceInput,
			transcribedSamplesBinding = v24.transcribedSamplesBinding,
			onSample = v24.onWaveformSample
		})
	})
	t6.UIFlexItem = React.createElement("UIFlexItem", {
		FlexMode = Enum.UIFlexMode.Fill
	})
	t4.TextArea = createElement2("Frame", t5, t6)
	t4.MicButton = React.createElement(Foundation.View, {
		tag = "auto-xy padding-xsmall",
		LayoutOrder = 3,
		ref = v24.micButtonSlotRef,
		GroupTransparency = v29
	}, {
		IconButton = React.createElement(Foundation.IconButton, {
			isCircular = true,
			icon = v25.icon,
			size = Foundation.Enums.InputSize.Small,
			variant = v25.variant,
			isDisabled = v25.isDisabled,
			onActivated = if not useLongPressOverlay then v25.onActivated else function() -- line: 253
			end,
			Selectable = not useLongPressOverlay and nil
		}),
		InputTarget = if not useLongPressOverlay or micGestureHandlers == nil then nil else React.createElement("TextButton", {
			Active = true,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Text = "",
			ZIndex = 2,
			Selectable = true,
			SelectionImageObject = v24.micCursor,
			[React.Event.Activated] = micGestureHandlers[React.Event.Activated],
			[React.Event.InputBegan] = micGestureHandlers[React.Event.InputBegan],
			[React.Event.InputEnded] = micGestureHandlers[React.Event.InputEnded]
		})
	})
	t4.FTUX = if not FFlagExpChatDictationFTUX or (not v24.ftux or not v24.ftux.shouldShow) then nil else React.createElement(DictationFTUX, {
		anchorRef = v24.micButtonSlotRef,
		onDismiss = if not FFlagExpChatDictationFTUX then nil else v24.ftux.dismiss
	})
	t4.SendIcon = React.createElement(Foundation.Icon, {
		Visible = false,
		name = Foundation.Enums.IconName.PaperAirplane,
		style = {
			Transparency = 0,
			Color3 = p3.chatInputBarSettings.PlaceholderColor3
		},
		size = Foundation.Enums.IconSize.Small
	})

	return createElement(View, t2, t4)
end

return React.memo(DictationInputBar)
