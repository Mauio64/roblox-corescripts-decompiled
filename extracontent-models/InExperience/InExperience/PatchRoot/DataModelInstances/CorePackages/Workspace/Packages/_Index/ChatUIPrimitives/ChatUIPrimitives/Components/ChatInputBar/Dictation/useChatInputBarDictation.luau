local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local useDictationInputBar = require(parent.DictationCore.useDictationInputBar)
local Constants = require(parent.DictationCore.Constants)
local getDictationInputMode = require(script.Parent.getDictationInputMode)

local DictationState = Constants.DictationState

local function useChatInputBarDictation(data, p, onSubmit, flag: boolean, flag2: boolean)
	local v = data ~= nil
	local hasText, v2 = React.useBinding(not flag)
	React.useEffect(function()
		v2(not flag)
	end, { flag })

	local v3 = {
		getText = React.useCallback(function()
			local current = p.current
			return if current then current.Text else nil
		end, { p }),
		setText = React.useCallback(function(text: string)
			local current = p.current

			if current then
				current.Text = text
			end
		end, { p }),
		onSubmit = onSubmit,
		hasText = hasText,
		inputMode = 0,
		onError = 0,
		containerName = 0,
		logger = 0
	}
	local v4

	if data then
		v4 = data.handsFreeEnabled
	end

	v3.inputMode = getDictationInputMode(v4)
	local onError

	if data then
		onError = data.onError
	end

	v3.onError = onError
	local containerName

	if data then
		containerName = data.surfaceName
	end

	v3.containerName = containerName
	local logger

	if data then
		logger = data.logger
	end

	v3.logger = logger
	local v5 = useDictationInputBar(v3)

	local getDictationState = v5.dictation.getDictationState
	local cancel = v5.dictation.cancel
	React.useEffect(function()
		if not (flag2 and v) and getDictationState(false) ~= DictationState.Idle then
			cancel()
		end
	end, { flag2, v, getDictationState, cancel })

	local v6 = SignalsReact.useSignalState(getDictationState)

	return v, v5, v and (v6 == DictationState.Recording or v6 == DictationState.Transcribing)
end

return useChatInputBarDictation
