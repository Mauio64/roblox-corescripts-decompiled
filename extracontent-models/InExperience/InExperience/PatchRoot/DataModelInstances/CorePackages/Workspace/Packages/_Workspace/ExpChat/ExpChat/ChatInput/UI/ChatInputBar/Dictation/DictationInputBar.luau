local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local FFlagExpChatDictationFTUX = require(ExpChat.Flags.FFlagExpChatDictationFTUX)
local FFlagExpChatDictationFadeOverride = require(ExpChat.Flags.FFlagExpChatDictationFadeOverride)
local FFlagExpChatContinuousDictationIdleFade = require(ExpChat.Flags.FFlagExpChatContinuousDictationIdleFade)
local v = FFlagExpChatDictationFadeOverride and FFlagExpChatContinuousDictationIdleFade

local Config = require(ExpChat.Config)

local ChannelChip = require(script.Parent.Parent.ChannelChip)
local DictationFTUX = require(script.Parent.DictationFTUX)
local StopCountdown = require(script.Parent.Parent.StopCountdown)
local DictationWaveform = require(script.Parent.DictationWaveform)
local useDictationInputBar = require(script.Parent.useDictationInputBar)
local useDictationTextArea = require(script.Parent.useDictationTextArea)
local DictationAffordances = require(script.Parent.DictationAffordances)

local function lerp(p: number, p2: number, p3: number) -- 2 equivalent calls inferred from this helper
	return p + (p2 - p) * p3
end

local function setTransparency(p, transparencyValue) -- 3 equivalent calls inferred from this helper
	return transparencyValue:map(function(p2: number)
		return lerp(p, 1, p2) -- inferred equivalent call
	end)
end

local function DictationInputBar(props)
	local v2 = Foundation.Hooks.useTokens()

	local v3 = useDictationInputBar({
		inputText = props.inputText,
		setInputText = props.setInputText,
		chatInputBarSettings = props.chatInputBarSettings,
		customTextBoxRef = props.customTextBoxRef,
		textBoxRef = props.textBoxRef,
		targetTextChannel = props.targetTextChannel,
		isGlobalChatTabActive = props.isGlobalChatTabActive,
		onDictationActivityChanged = props.onDictationActivityChanged,
		onDictationStateChanged = props.onDictationStateChanged,
		onSendRecordingTap = props.onSendRecordingTap,
		onTranscriptionStaged = props.onTranscriptionStaged
	})

	local micSendButton = DictationAffordances.deriveMicSendButton(v3, {
		hasEmptyInputText = props.inputText == "",
		idleSendIcon = Foundation.Enums.IconName.PaperAirplane,
		idleSendVariant = Foundation.Enums.ButtonVariant.Emphasis,
		idleSendActivated = props.onSendActivated,
		idleSendDisabled = false
	})

	local backgroundColors = DictationAffordances.deriveBackgroundColors(v3, {
		defaultColor3 = props.chatInputBarSettings.BackgroundColor3,
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

	local shouldPreventFade = DictationAffordances.shouldPreventFade(v3, v)
	local groupTransparency = React.useMemo(function()
		if shouldPreventFade then
			return props.transparencyValue:map(function(_: number): number
				return 0
			end)
		end

		return props.transparencyValue
	end, { shouldPreventFade, props.transparencyValue })

	local v4 = useDictationTextArea(v3, {
		transparencyValue = props.transparencyValue,
		showPlaceholderText = props.showPlaceholderText
	})

	local useLongPressOverlay = micSendButton.useLongPressOverlay
	local micGestureHandlers = v3.micGestureHandlers

	local createElement = React.createElement
	local view = Foundation.View
	local background = {
		Name = "Background",
		tag = "row align-y-center gap-small size-full-0 auto-y padding-x-xsmall radius-medium",
		backgroundStyle = backgroundStyle,
		stroke = {
			Color = Config.ChatInputBarBorderColor3,
			Transparency = setTransparency(Config.ChatInputBarBorderTransparency, props.transparencyValue) -- inferred equivalent call
		}
	}

	local children = {
		StopCountdown = React.createElement(StopCountdown, {
			LayoutOrder = 1,
			countdownProgress = v3.dictation.bindings.countdownProgress,
			onActivated = v3.dictation.stopDictation,
			Visible = v3.dictation.bindings.isRecording
		}),
		TextArea = 0,
		MicButton = 0,
		FTUX = 0,
		SendIcon = 0
	}

	local createElement2 = React.createElement
	local v5 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		Size = UDim2.fromScale(0, 0),
		SelectionBehaviorDown = props.selectionBehavior,
		SelectionBehaviorLeft = props.selectionBehavior,
		SelectionBehaviorRight = props.selectionBehavior,
		SelectionBehaviorUp = props.selectionBehavior,
		SelectionGroup = props.selectionGroup
	}
	local children2 = {
		TargetChannelChip = React.createElement(ChannelChip, {
			transparency = setTransparency(0, props.transparencyValue), -- inferred equivalent call
			onAbsoluteSizeChanged = props.onChannelChipAbsoluteSizeChanged,
			onChannelChipActivated = props.onChannelChipActivated,
			targetTextChannelDisplayName = props.targetTextChannelDisplayName or "",
			isChannelBarVisible = props.isChannelBarVisible,
			developerChannelTabsEnabled = props.developerChannelTabsEnabled
		}),
		DisabledPlaceholderLabel = 0,
		TextBoxContainer = 0,
		WaveformOverlay = 0,
		UIFlexItem = 0
	}

	local disabledPlaceholderLabel = not props.canLocalUserChat

	if disabledPlaceholderLabel then
		local createElement3 = React.createElement
		local v6 = {
			AnchorPoint = Vector2.new(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Font = Config.ChatInputBarFont,
			Text = props.disabledChatPlaceholderText,
			Position = UDim2.fromScale(1, 0),
			Size = props.targetChannelWidth:map(function(p: number)
				return UDim2.new(1, -(p + 8), 0, 0)
			end),
			TextColor3 = props.showPlaceholderText and props.chatInputBarSettings.PlaceholderColor3 or props.chatInputBarSettings.TextColor3,
			TextSize = 0,
			TextTransparency = 0,
			Selectable = 0,
			SelectionImageObject = 0,
			TextWrapped = true,
			TextXAlignment = 0,
			TextYAlignment = 0,
			ref = 0
		}
		local textSize

		if props.isSpatialUIEnabled then
			textSize = props.chatInputBarSettings.SpatialPanelTextSize
		else
			textSize = props.chatInputBarSettings.TextSize
		end

		v6.TextSize = textSize

		v6.TextTransparency = setTransparency(props.showPlaceholderText and 0.5 or 0, props.transparencyValue) -- inferred equivalent call

		v6.Selectable = props.isPlaceholderSelectable
		v6.SelectionImageObject = props.placeholderSelectionImageObject

		v6.TextXAlignment = Enum.TextXAlignment.Left
		v6.TextYAlignment = Enum.TextYAlignment.Top
		v6.ref = props.placeholderRef
		disabledPlaceholderLabel = createElement3("TextLabel", v6)
	end

	children2.DisabledPlaceholderLabel = disabledPlaceholderLabel
	local textBoxContainer

	if props.canLocalUserChat then
		local createElement3 = React.createElement
		local v6 = {
			AnchorPoint = Vector2.new(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(1, 0),
			Size = props.targetChannelWidth:map(function(p: number)
				return UDim2.new(1, -(p + 8), 0, 0)
			end)
		}

		local createElement4 = React.createElement
		local v7 = {}
		v7.AnchorPoint = Vector2.new(0, 0)
		v7.AutomaticSize = Enum.AutomaticSize.XY
		v7.BackgroundTransparency = 1
		v7.ClearTextOnFocus = false
		v7.FontFace = props.chatInputBarSettings.FontFace
		v7.PlaceholderText = props.showPlaceholderText and props.placeholderText or ""
		v7.Selectable = props.isTextBoxSelectable
		v7.SelectionImageObject = props.cursor
		v7.Size = UDim2.fromScale(1, 0)
		v7.Text = ""
		v7.PlaceholderColor3 = props.chatInputBarSettings.PlaceholderColor3
		v7.TextColor3 = props.chatInputBarSettings.TextColor3
		local textSize

		if props.isSpatialUIEnabled then
			textSize = props.chatInputBarSettings.SpatialPanelTextSize
		else
			textSize = props.chatInputBarSettings.TextSize
		end

		v7.TextSize = textSize

		v7.TextTransparency = v4.textTransparency
		v7.TextStrokeTransparency = v4.textStrokeTransparency
		v7.TextStrokeColor3 = props.chatInputBarSettings.TextStrokeColor3
		v7.TextWrapped = true
		v7.TextXAlignment = Enum.TextXAlignment.Left
		v7.TextYAlignment = Enum.TextYAlignment.Top
		v7.ZIndex = 2

		v7[React.Event.Focused] = props.onFocused
		v7[React.Event.FocusLost] = props.onFocusLost
		v7[React.Change.Text] = props.onTextChanged
		v7[React.Event.ReturnPressedFromOnScreenKeyboard] = props.onReturnPressedFromOnScreenKeyboard
		local ref

		if props.chatInputBarSettings.TextBox then
			ref = props.customTextBoxRef
		else
			ref = props.textBoxRef
		end

		v7.ref = ref
		textBoxContainer = createElement3("Frame", v6, { TextBox = createElement4("TextBox", v7) }) or nil
	end

	children2.TextBoxContainer = textBoxContainer

	local createElement3 = React.createElement
	local v6 = {
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.fromScale(0, 0.5),
		Size = 0,
		Visible = 0,
		ZIndex = 3
	}
	local v7

	if props.isSpatialUIEnabled then
		v7 = props.chatInputBarSettings.SpatialPanelTextSize
	else
		v7 = props.chatInputBarSettings.TextSize
	end

	v6.Size = UDim2.new(1, 0, 0, v7)

	v6.Visible = v3.dictation.bindings.isAudioActive

	local createElement4 = React.createElement
	local v8 = {
		isActive = v3.isRecording or v3.isListening,
		audioDeviceInput = v3.dictation.audioDeviceInput,
		transcribedSamplesBinding = v3.transcribedSamplesBinding,
		transparencyValue = 0,
		onSample = 0
	}
	local transparencyValue

	if v3.isListening and not shouldPreventFade then
		transparencyValue = props.transparencyValue
	end

	v8.transparencyValue = transparencyValue

	v8.onSample = v3.onWaveformSample
	children2.WaveformOverlay = createElement3("Frame", v6, {
		List = createElement4(DictationWaveform, v8)
	})

	children2.UIFlexItem = React.createElement("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill })
	children.TextArea = createElement2("Frame", v5, children2)

	local createElement5 = React.createElement
	local view2 = Foundation.View
	local v9 = {
		ref = v3.micButtonSlotRef,
		tag = "auto-xy padding-xsmall",
		GroupTransparency = groupTransparency,
		LayoutOrder = 3
	}

	local v10 = {
		IconButton = React.createElement(Foundation.IconButton, {
			icon = micSendButton.icon,
			size = Foundation.Enums.InputSize.Small,
			variant = micSendButton.variant,
			isCircular = true,
			isDisabled = micSendButton.isDisabled,
			onActivated = useLongPressOverlay and function() end or micSendButton.onActivated,
			Selectable = not useLongPressOverlay and nil
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
			SelectionImageObject = v3.micCursor,
			[React.Event.Activated] = micGestureHandlers[React.Event.Activated],
			[React.Event.InputBegan] = micGestureHandlers[React.Event.InputBegan],
			[React.Event.InputEnded] = micGestureHandlers[React.Event.InputEnded]
		})
	end

	v10.InputTarget = inputTarget
	children.MicButton = createElement5(view2, v9, v10)
	local ftux

	if FFlagExpChatDictationFTUX and v3.ftux and v3.ftux.shouldShow then
		local createElement6 = React.createElement
		local v11 = { anchorRef = v3.micButtonSlotRef, onDismiss = 0 }
		local onDismiss

		if FFlagExpChatDictationFTUX then
			onDismiss = v3.ftux.dismiss
		end

		v11.onDismiss = onDismiss
		ftux = createElement6(DictationFTUX, v11)
	end

	children.FTUX = ftux

	children.SendIcon = React.createElement(Foundation.Icon, {
		name = Foundation.Enums.IconName.PaperAirplane,
		style = { Color3 = props.chatInputBarSettings.PlaceholderColor3, Transparency = 0 },
		size = Foundation.Enums.IconSize.Small,
		Visible = false
	})
	return createElement(view, background, children)
end

return React.memo(DictationInputBar)
