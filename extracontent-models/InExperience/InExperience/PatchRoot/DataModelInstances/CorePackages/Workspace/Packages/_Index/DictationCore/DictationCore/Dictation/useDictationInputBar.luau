local DictationCore = script:FindFirstAncestor("DictationCore")
local parent = DictationCore.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local useDictation = require(script.Parent.useDictation)
local DictationMode = require(script.Parent.DictationMode)
local DictationInputMode = require(script.Parent.DictationInputMode)
local joinPhrase = require(DictationCore.Utils.joinPhrase)
local useTranscribedSamples = require(DictationCore.UI.useTranscribedSamples)

local useDictation2 = useDictation.useDictation
local dictationState = useDictation.DictationState

local function useDictationInputBar(data)
	local getText = data.getText
	local setText = data.setText
	local onSubmit = data.onSubmit

	local v = useTranscribedSamples()

	local ref = React.useRef(nil)

	local onWaveformSample = React.useCallback(function(current: number, _: number)
		ref.current = current
	end, {})

	local onSpeechStarted = React.useCallback(function(p)
		if p ~= DictationMode.Continuous then
			return
		end

		if ref.current ~= nil then
			v.begin(ref.current)
		end
	end, { v })

	local onActivityChanged = React.useCallback(function(flag: boolean)
		if not flag then
			ref.current = nil
			v.reset()
		end
	end, { v })

	local dictation = useDictation2({
		onTranscription = React.useCallback(function(p: string, p2)
			if p2 == DictationMode.Continuous and ref.current ~= nil then
				v.commit(ref.current)
			end

			local text = getText()

			if text == nil then
				return
			end

			local v2 = joinPhrase(text, p)
			setText(v2)

			if p2 == DictationMode.Continuous then
				onSubmit(v2)
			end
		end, { getText, setText, onSubmit, v }),
		onSpeechStarted = onSpeechStarted,
		onActivityChanged = onActivityChanged,
		onError = data.onError,
		logger = data.logger,
		containerName = data.containerName
	})

	local v2 = SignalsReact.useSignalState(dictation.getDictationState)
	local isAudioActive = v2 == dictationState.Recording or v2 == dictationState.Listening

	local hasText = data.hasText
	local isIdle = dictation.bindings.isIdle
	local isMicVisible = React.useMemo(function()
		return React.joinBindings({ hasText = hasText, isIdle = isIdle }):map(function(p): boolean
			return not (p.hasText and p.isIdle)
		end)
	end, { hasText, isIdle })
	local isSubmitVisible = React.useMemo(function()
		return isMicVisible:map(function(flag: boolean): boolean
			return not flag
		end)
	end, { isMicVisible })

	return {
		dictation = dictation,
		inputMode = data.inputMode or DictationInputMode.Standard,
		isAudioActive = isAudioActive,
		isMicVisible = isMicVisible,
		isSubmitVisible = isSubmitVisible,
		onWaveformSample = onWaveformSample,
		transcribedSamplesBinding = v.binding
	}
end

return useDictationInputBar
