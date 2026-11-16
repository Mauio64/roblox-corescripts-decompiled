local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local React = require(parent.React)

local GetVoiceStore = require(ExpChat.Stores.GetVoiceStore)
require(ExpChat.Stores.GetVoiceStore.createVoiceStore)

local voiceStore = GetVoiceStore(false)

local signal = Signals.createSignal(nil)

local function withSignalsData(p)
	return function(p2)
		local userId = p2.userId
		local v

		if userId then
			v = voiceStore.getOrCreateVoiceState(userId)
		end

		local voiceState = useSignalState(v or signal)

		local clone = table.clone(p2)
		clone.voiceState = voiceState

		return React.createElement(p, clone)
	end
end

return withSignalsData
