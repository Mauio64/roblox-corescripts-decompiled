local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Signals = require(ExpChatParent.Signals)
local useSignalState = require(ExpChatParent.SignalsReact).useSignalState
local React = require(ExpChatParent.React)
local GetVoiceStore = require(ExpChat.Stores.GetVoiceStore)

require(ExpChat.Stores.GetVoiceStore.createVoiceStore)

local v7 = GetVoiceStore(false)
local v8 = Signals.createSignal(nil)

local function withSignalsData(p1) -- line: 24
	-- upvalues: v7 (copy), useSignalState (copy), v8 (copy), React (copy)
	return function(p2) -- line: 25
		-- upvalues: v7 (copy), useSignalState (copy), v8 (copy), React (copy), p1 (copy)
		local userId = p2.userId
		local v13 = if not userId then nil else v7.getOrCreateVoiceState(userId)
		local v14 = useSignalState(v13 or v8)
		local v15 = table.clone(p2)

		v15.voiceState = v14

		return React.createElement(p1, v15)
	end
end

return withSignalsData
