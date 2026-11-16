local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local ExpChatShared = require(parent.ExpChatShared)

local Config = require(ExpChat.Config)
local FFlagExpChatPresetChatEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatEnabled
local FFlagExpChatFixBackspaceNilTargetChannel = ExpChatShared.Flags.FFlagExpChatFixBackspaceNilTargetChannel
local FFlagExpChatDictationFTUX = require(ExpChat.Flags.FFlagExpChatDictationFTUX)

local FFlagExpChatInputBarV2CornerAndTruncationFix = require(ExpChat.Flags.FFlagExpChatInputBarV2CornerAndTruncationFix)
local FFlagExpChatComposerInputBarFigmaParity = require(ExpChat.Flags.FFlagExpChatComposerInputBarFigmaParity)
local FFlagExpChatDictationStopReplacesSend = require(ExpChat.Flags.FFlagExpChatDictationStopReplacesSend)
local FFlagExpChatDictationFadeOverride = require(ExpChat.Flags.FFlagExpChatDictationFadeOverride)
local FFlagExpChatContinuousDictationIdleFade = require(ExpChat.Flags.FFlagExpChatContinuousDictationIdleFade)
local v = FFlagExpChatDictationFadeOverride and FFlagExpChatContinuousDictationIdleFade

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls

local ChannelChip = require(script.Parent.ChannelChip)
local StopCountdown = require(script.Parent.StopCountdown)
require(script.Parent.Dictation)
local DictationFTUX = require(script.Parent.Dictation.DictationFTUX)
local DictationWaveform = require(script.Parent.Dictation.DictationWaveform)
local useDictationInputBar = require(script.Parent.Dictation.useDictationInputBar)
local useDictationTextArea = require(script.Parent.Dictation.useDictationTextArea)
local DictationAffordances = require(script.Parent.Dictation.DictationAffordances)

local function lerp(baseTransparency: number, p: number, p2: number) -- 1 equivalent call inferred from this helper
	return baseTransparency + (p - baseTransparency) * p2
end

local function ChatInputBarV2Dictation(props)
	local v2 = Foundation.Hooks.useTokens()
	local setTransparency = props.setTransparency
	local chatInputBarSettings = props.chatInputBarSettings
	local isSpatialUIEnabled = props.isSpatialUIEnabled
	local v3 = props.canLocalUserChatDerived
	local targetChannelWidth = props.targetChannelWidth
	local showPlaceholderText = props.showPlaceholderText
	local hasEmptyInputText = props.hasEmptyInputText == true
	local cursor = props.cursor

	local v4 = useDictationInputBar({
		inputText = props.inputText,
		setInputText = props.setInputText,
		chatInputBarSettings = chatInputBarSettings,
		customTextBoxRef = props.customTextBoxRef,
		textBoxRef = props.textBoxRef,
		targetTextChannel = props.targetTextChannel,
		isGlobalChatTabActive = props.isGlobalChatTabActive,
		onDictationActivityChanged = props.onDictationActivityChanged,
		onDictationStateChanged = props.onDictationStateChanged,
		onSendActivated = props.onSendActivated,
		onSendRecordingTap = props.onSendRecordingTap,
		onTranscriptionStaged = props.onTranscriptionStaged
	})

	local deriveMicSendButton = DictationAffordances.deriveMicSendButton
	local v5 = {
		hasEmptyInputText = hasEmptyInputText,
		idleSendIcon = Foundation.Enums.IconName.ArrowMediumUp,
		idleSendVariant = 0,
		idleSendActivated = 0,
		idleSendDisabled = 0
	}
	local idleSendVariant

	if hasEmptyInputText then
		idleSendVariant = Foundation.Enums.ButtonVariant.Standard
	else
		idleSendVariant = Foundation.Enums.ButtonVariant.Emphasis
	end

	v5.idleSendVariant = idleSendVariant

	v5.idleSendActivated = props.onSendActivated
	v5.idleSendDisabled = hasEmptyInputText
	local v6 = deriveMicSendButton(v4, v5)

	local backgroundColors = DictationAffordances.deriveBackgroundColors(v4, {
		defaultColor3 = chatInputBarSettings.BackgroundColor3,
		defaultTransparency = props.chatInputBarBackgroundTransparency,
		listeningColor3 = v2.Color.Shift.Shift_200.Color3,
		listeningTransparency = v2.Color.Shift.Shift_200.Transparency
	})

	local backgroundStyle = React.useMemo(function()
		return props.transparencyValue:map(function(p: number)
			return {
				Color3 = backgroundColors.color3,
				Transparency = lerp(backgroundColors.baseTransparency, 1, p) -- inferred equivalent call
			}
		end)
	end, { props.transparencyValue, backgroundColors.color3, backgroundColors.baseTransparency })

	local shouldPreventFade = DictationAffordances.shouldPreventFade(v4, v)
	local groupTransparency = React.useMemo(function()
		if shouldPreventFade then
			return props.transparencyValue:map(function(_: number): number
				return 0
			end)
		end

		return props.transparencyValue
	end, { shouldPreventFade, props.transparencyValue })

	local v7 = useDictationTextArea(v4, {
		transparencyValue = props.transparencyValue,
		showPlaceholderText = showPlaceholderText
	})

	local useLongPressOverlay = v6.useLongPressOverlay
	local micGestureHandlers = v4.micGestureHandlers
	local isRecording = FFlagExpChatDictationStopReplacesSend and v4.isRecording

	local createElement = React.createElement
	local v8 = {
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0)
	}

	local createElement2 = React.createElement
	local v9 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1
	}

	local createElement3 = React.createElement
	local view = Foundation.View
	local v10 = {
		tag = {
			["row align-y-center auto-y padding-x-xxsmall"] = true,
			["radius-circle"] = not FFlagExpChatInputBarV2CornerAndTruncationFix
		},
		cornerRadius = 0,
		backgroundStyle = 0,
		stroke = 0,
		LayoutOrder = 1,
		Position = 0,
		Size = 0
	}
	local cornerRadius

	if FFlagExpChatInputBarV2CornerAndTruncationFix then
		cornerRadius = UDim.new(0, 20)
	end

	v10.cornerRadius = cornerRadius
	v10.backgroundStyle = backgroundStyle
	v10.stroke = {
		Color = v2.Color.Stroke.Default.Color3,
		Transparency = setTransparency(v2.Color.Stroke.Default.Transparency, props.transparencyValue)
	}

	v10.Position = UDim2.fromScale(0, 0)
	v10.Size = UDim2.fromScale(1, 0)
	local stopCountdown

	if not FFlagExpChatDictationStopReplacesSend then
		stopCountdown = React.createElement(StopCountdown, {
			LayoutOrder = 1,
			countdownProgress = v4.dictation.bindings.countdownProgress,
			onActivated = v4.dictation.stopDictation,
			Visible = v4.dictation.bindings.isRecording
		})
	end

	local createElement4 = React.createElement
	local v11 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		Size = UDim2.fromScale(0, 0)
	}
	local children2 = {
		TargetChannelChip = React.createElement(ChannelChip, {
			transparency = setTransparency(0, props.transparencyValue),
			onAbsoluteSizeChanged = props.onAbsoluteSizeChanged,
			onChannelChipActivated = FFlagExpChatFixBackspaceNilTargetChannel and function()
				props.resetTargetChannel(props.isGlobalChatTabActive)
			end or props.resetTargetChannel,
			targetTextChannelDisplayName = props.targetTextChannelDisplayName or "",
			isChannelBarVisible = props.isChannelBarVisible,
			developerChannelTabsEnabled = props.developerChannelTabsEnabled
		}),
		DisabledPlaceholderLabel = 0,
		TextBoxContainer = 0,
		WaveformOverlay = 0,
		UIFlexItem = 0,
		UIPadding = 0
	}

	local disabledPlaceholderLabel = not v3

	if disabledPlaceholderLabel then
		local createElement5 = React.createElement
		local v12 = {
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
			TextWrapped = 0,
			TextTruncate = 0,
			TextXAlignment = 0,
			TextYAlignment = 0,
			ref = 0
		}
		local textSize

		if isSpatialUIEnabled then
			textSize = chatInputBarSettings.SpatialPanelTextSize
		else
			textSize = chatInputBarSettings.TextSize
		end

		v12.TextSize = textSize

		v12.TextTransparency = setTransparency(showPlaceholderText and 0.5 or 0, props.transparencyValue)

		v12.SelectionImageObject = cursor
		local textWrapped

		if FFlagExpChatInputBarV2CornerAndTruncationFix then
			textWrapped = not showPlaceholderText
		else
			local shouldTruncatePlaceholder = FFlagExpChatPresetChatEnabled
				and showPlaceholderText
				and props.shouldTruncatePlaceholder
			textWrapped = not shouldTruncatePlaceholder
		end

		v12.TextWrapped = textWrapped
		local atEnd

		if FFlagExpChatInputBarV2CornerAndTruncationFix and showPlaceholderText then
			atEnd = Enum.TextTruncate.AtEnd
		elseif FFlagExpChatPresetChatEnabled and showPlaceholderText then
			atEnd = Enum.TextTruncate.AtEnd
		end

		v12.TextTruncate = atEnd

		v12.TextXAlignment = Enum.TextXAlignment.Left
		v12.TextYAlignment = Enum.TextYAlignment.Top
		v12.ref = props.placeholderRef
		disabledPlaceholderLabel = createElement5("TextLabel", v12)
	end

	children2.DisabledPlaceholderLabel = disabledPlaceholderLabel

	if v3 then
		local createElement5 = React.createElement
		local v12 = {
			AnchorPoint = Vector2.new(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(1, 0),
			Size = targetChannelWidth:map(function(p: number)
				return UDim2.new(1, -(p + 8), 0, 0)
			end)
		}

		if v3 then
			local createElement6 = React.createElement
			local v13 = {}
			v13.AnchorPoint = Vector2.new(0, 0)
			v13.AutomaticSize = Enum.AutomaticSize.XY
			v13.BackgroundTransparency = 1
			v13.ClearTextOnFocus = false
			v13.FontFace = chatInputBarSettings.FontFace
			v13.PlaceholderText = showPlaceholderText and props.placeholderText or ""
			v13.Selectable = FFlagEnableConsoleExpControls and true or nil
			v13.SelectionImageObject = cursor
			v13.Size = UDim2.fromScale(1, 0)
			v13.Text = ""
			local placeholderColor

			if
				FFlagExpChatComposerInputBarFigmaParity
				and chatInputBarSettings.PlaceholderColor3 == Config.ChatInputBarPlaceholderColor
			then
				placeholderColor = v2.DarkMode.Content.Default.Color3
			else
				placeholderColor = chatInputBarSettings.PlaceholderColor3
			end

			v13.PlaceholderColor3 = placeholderColor

			v13.TextColor3 = chatInputBarSettings.TextColor3
			local textSize

			if isSpatialUIEnabled then
				textSize = chatInputBarSettings.SpatialPanelTextSize
			else
				textSize = chatInputBarSettings.TextSize
			end

			v13.TextSize = textSize

			v13.TextTransparency = v7.textTransparency
			v13.TextStrokeTransparency = v7.textStrokeTransparency
			v13.TextStrokeColor3 = chatInputBarSettings.TextStrokeColor3
			v13.TextWrapped = not FFlagExpChatInputBarV2CornerAndTruncationFix or not showPlaceholderText
			local textTruncate

			if FFlagExpChatInputBarV2CornerAndTruncationFix and showPlaceholderText then
				textTruncate = Enum.TextTruncate.AtEnd
			end

			v13.TextTruncate = textTruncate

			v13.TextXAlignment = Enum.TextXAlignment.Left
			v13.TextYAlignment = Enum.TextYAlignment.Top
			v13.ZIndex = 2

			v13[React.Event.Focused] = props.onFocused
			v13[React.Event.FocusLost] = props.onFocusLost
			v13[React.Change.Text] = props.onTextChanged
			v13[React.Event.ReturnPressedFromOnScreenKeyboard] = props.onReturnPressedFromOnScreenKeyboard
			local ref

			if chatInputBarSettings.TextBox then
				ref = props.customTextBoxRef
			else
				ref = props.textBoxRef
			end

			v13.ref = ref
			v3 = createElement6("TextBox", v13)
		end

		v3 = createElement5("Frame", v12, { TextBox = v3 })
	end

	children2.TextBoxContainer = v3

	local createElement5 = React.createElement
	local v12 = {
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.fromScale(0, 0.5),
		Size = 0,
		Visible = 0,
		ZIndex = 3
	}
	local v13

	if isSpatialUIEnabled then
		v13 = chatInputBarSettings.SpatialPanelTextSize
	else
		v13 = chatInputBarSettings.TextSize
	end

	v12.Size = UDim2.new(1, 0, 0, v13)

	v12.Visible = v4.dictation.bindings.isAudioActive

	local createElement6 = React.createElement
	local v14 = {
		isActive = v4.isRecording or v4.isListening,
		audioDeviceInput = v4.dictation.audioDeviceInput,
		transcribedSamplesBinding = v4.transcribedSamplesBinding,
		transparencyValue = 0,
		onSample = 0
	}
	local transparencyValue

	if v4.isListening and not shouldPreventFade then
		transparencyValue = props.transparencyValue
	end

	v14.transparencyValue = transparencyValue

	v14.onSample = v4.onWaveformSample
	children2.WaveformOverlay = createElement5("Frame", v12, {
		List = createElement6(DictationWaveform, v14)
	})

	children2.UIFlexItem = React.createElement("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill })

	children2.UIPadding = React.createElement("UIPadding", {
		PaddingBottom = UDim.new(0, 10),
		PaddingLeft = UDim.new(0, v2.Padding.Medium),
		PaddingRight = UDim.new(0, v2.Padding.Medium),
		PaddingTop = UDim.new(0, 10)
	})
	local children = {
		StopCountdown = stopCountdown,
		TextContainer = createElement4("Frame", v11, children2),
		SendButtonContainer = 0,
		FTUX = 0
	}

	local createElement7 = React.createElement
	local view2 = Foundation.View
	local v15 = {
		ref = v4.micButtonSlotRef,
		tag = "auto-xy padding-xxsmall",
		GroupTransparency = groupTransparency,
		LayoutOrder = 3
	}
	local trailingStopCountdown

	if isRecording then
		trailingStopCountdown = React.createElement(StopCountdown, {
			countdownProgress = v4.dictation.bindings.countdownProgress,
			onActivated = v4.dictation.stopDictation
		})
	end

	local v16 = {
		TrailingStopCountdown = trailingStopCountdown,
		SendButton = React.createElement(Foundation.IconButton, {
			icon = v6.icon,
			variant = v6.variant,
			size = Foundation.Enums.InputSize.Small,
			isCircular = true,
			isDisabled = v6.isDisabled,
			Selectable = not useLongPressOverlay and nil,
			onActivated = useLongPressOverlay and function() end or v6.onActivated,
			Visible = not isRecording and nil
		}),
		InputTarget = 0
	}
	local inputTarget

	if useLongPressOverlay and micGestureHandlers ~= nil then
		inputTarget = React.createElement("TextButton", {
			Active = true,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Text = "",
			ZIndex = 2,
			Selectable = true,
			SelectionImageObject = v4.micCursor,
			[React.Event.Activated] = micGestureHandlers[React.Event.Activated],
			[React.Event.InputBegan] = micGestureHandlers[React.Event.InputBegan],
			[React.Event.InputEnded] = micGestureHandlers[React.Event.InputEnded]
		})
	end

	v16.InputTarget = inputTarget
	children.SendButtonContainer = createElement7(view2, v15, v16)
	local ftux

	if FFlagExpChatDictationFTUX and v4.ftux and v4.ftux.shouldShow then
		local createElement8 = React.createElement
		local v17 = { anchorRef = v4.micButtonSlotRef, onDismiss = 0 }
		local onDismiss

		if FFlagExpChatDictationFTUX then
			onDismiss = v4.ftux.dismiss
		end

		v17.onDismiss = onDismiss
		ftux = createElement8(DictationFTUX, v17)
	end

	children.FTUX = ftux
	return createElement("Frame", v8, {
		Container = createElement2("Frame", v9, {
			InputGroup = createElement3(view, v10, children)
		})
	})
end

return React.memo(ChatInputBarV2Dictation)
