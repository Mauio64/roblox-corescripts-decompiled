local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local Signals = require(parent.Signals)
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local DictationState = require(ExpChat.ChatInput.UI.ChatInputBar.Dictation.DictationState)

return function()
	local signal, setDictationState = createSignal(DictationState.Idle)

	return {
		getDictationState = signal,
		getIsListening = createComputed(function(p): boolean
			return signal(p) == DictationState.Listening
		end),
		setDictationState = setDictationState
	}
end
