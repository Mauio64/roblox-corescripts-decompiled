local DictationCore = script:FindFirstAncestor("DictationCore")
local parent = DictationCore.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local useDictation = require(DictationCore.Dictation.useDictation)
local dictationState = useDictation.DictationState
local DictationMode = require(DictationCore.Dictation.DictationMode)
local DictationInputMode = require(DictationCore.Dictation.DictationInputMode)
local DictationAffordances = require(script.Parent.DictationAffordances)
local CountdownRing = require(script.Parent.CountdownRing)
local StopCountdownButton = require(script.Parent.StopCountdownButton)
local useLongPress = require(script.Parent.useLongPress)

local FFlagDictationMicKeepsFocus = require(DictationCore.Flags.FFlagDictationMicKeepsFocus)

local useSignalState = SignalsReact.useSignalState

local signal = Signals.createSignal(false)

local function noop() end

local function MicButton(props)
	local getDictationState = props.getDictationState
	local onStart = props.onStart
	local onStop = props.onStop
	local inputMode = props.inputMode or DictationInputMode.Standard
	local isDictationEligible = props.isDictationEligible == nil or props.isDictationEligible
	local v

	if inputMode == DictationInputMode.Continuous then
		v = DictationMode.Continuous
	else
		v = DictationMode.Standard
	end

	local v2 = useSignalState(getDictationState)
	local isMicInUseElsewhere = useSignalState(props.getIsMicInUseElsewhere or signal)

	local v3 = React.useCallback(function()
		if getDictationState(false) == dictationState.Idle then
			onStart(v)
		else
			onStop()
		end
	end, { getDictationState, onStart, onStop, v })

	local onLongPress = React.useCallback(function()
		if getDictationState(false) == dictationState.Idle then
			onStart(DictationMode.Continuous)
		end
	end, { getDictationState, onStart })

	if inputMode ~= DictationInputMode.Hybrid then
		onLongPress = nil
	end

	local micGestureHandlers = useLongPress({ onLongPress = onLongPress, onTap = v3 })

	local v4 = {
		isRecording = v2 == dictationState.Recording,
		isTranscribing = v2 == dictationState.Transcribing,
		isListening = v2 == dictationState.Listening,
		isMicInUseElsewhere = isMicInUseElsewhere,
		isDictationEligible = isDictationEligible,
		onMicTap = v3,
		dictation = { cancel = v3 },
		micGestureHandlers = micGestureHandlers
	}

	local micSendButton = DictationAffordances.deriveMicSendButton(v4, {
		hasEmptyInputText = true,
		idleSendIcon = Foundation.Enums.IconName.Microphone,
		idleSendVariant = Foundation.Enums.ButtonVariant.Utility,
		idleSendActivated = nil,
		idleSendDisabled = not isDictationEligible
	})

	local useLongPressOverlay = micSendButton.useLongPressOverlay

	if not FFlagDictationMicKeepsFocus and v4.isRecording then
		return React.createElement(StopCountdownButton, {
			countdownProgress = props.countdownProgress,
			onActivated = onStop
		})
	end

	local isRecording = FFlagDictationMicKeepsFocus and v4.isRecording
	local countdownProgress = props.countdownProgress

	local createElement = React.createElement
	local iconButton = Foundation.IconButton
	local icon

	if isRecording then
		icon = Foundation.Enums.IconName.StopSmall
	else
		icon = micSendButton.icon
	end

	local v5 = {
		icon = icon,
		size = props.size or Foundation.Enums.InputSize.Small,
		variant = 0,
		isCircular = true,
		testId = 0,
		isDisabled = 0,
		Selectable = 0,
		onActivated = 0,
		tag = 0
	}
	local variant

	if isRecording then
		variant = Foundation.Enums.ButtonVariant.Utility
	else
		variant = micSendButton.variant
	end

	v5.variant = variant

	v5.testId = props.testId
	v5.isDisabled = micSendButton.isDisabled

	v5.Selectable = not useLongPressOverlay and nil
	local onActivated

	if useLongPressOverlay then
		onActivated = noop
	else
		onActivated = micSendButton.onActivated or noop
	end

	v5.onActivated = onActivated
	v5.tag = props.tag
	local element = createElement(iconButton, v5)

	if not FFlagDictationMicKeepsFocus and micGestureHandlers == nil then
		return element
	end

	local createElement2 = React.createElement
	local v6 = {
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Size = UDim2.new()
	}
	local progress

	if isRecording and countdownProgress ~= nil then
		progress = React.createElement(CountdownRing, { countdownProgress = countdownProgress })
	end

	local holdTarget

	if useLongPressOverlay and micGestureHandlers ~= nil then
		holdTarget = React.createElement("TextButton", {
			Active = true,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Text = "",
			ZIndex = 2,
			Selectable = true,
			[React.Event.Activated] = micGestureHandlers[React.Event.Activated],
			[React.Event.InputBegan] = micGestureHandlers[React.Event.InputBegan],
			[React.Event.InputEnded] = micGestureHandlers[React.Event.InputEnded]
		})
	end

	return createElement2("Frame", v6, {
		Progress = progress,
		Button = element,
		HoldTarget = holdTarget
	})
end

return React.memo(MicButton)
