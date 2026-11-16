local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local Rodux = require(parent.Rodux)
local llama = require(parent.llama)
local dictionary = llama.Dictionary

local Actions = ExpChat.Actions
local ChatTimeoutUpdated = require(Actions.ChatTimeoutUpdated)

local function updateChatTimeoutData(p, p2)
	return dictionary.join(p, {
		timeoutData = { endTimestamp = p2.endTimestamp, isEnforced = p2.isEnforced }
	})
end

return Rodux.createReducer({
	timeoutData = { endTimestamp = 0, isEnforced = false }
}, { [ChatTimeoutUpdated.name] = updateChatTimeoutData })
