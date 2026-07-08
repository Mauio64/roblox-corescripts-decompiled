local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Rodux = require(ExpChatParent.Rodux)
local Dictionary = require(ExpChatParent.llama).Dictionary
local Actions = ExpChat.Actions
local ChatTimeoutUpdated = require(Actions.ChatTimeoutUpdated)
local t1 = {
	timeoutData = {
		endTimestamp = 0,
		isEnforced = false
	}
}

local function updateChatTimeoutData(t2: {[any]: any}, p1) -- line: 24
	-- upvalues: Dictionary (copy)
	return Dictionary.join(t2, {
		timeoutData = {
			endTimestamp = p1.endTimestamp,
			isEnforced = p1.isEnforced
		}
	})
end

return Rodux.createReducer(t1, {
	[ChatTimeoutUpdated.name] = updateChatTimeoutData
})
