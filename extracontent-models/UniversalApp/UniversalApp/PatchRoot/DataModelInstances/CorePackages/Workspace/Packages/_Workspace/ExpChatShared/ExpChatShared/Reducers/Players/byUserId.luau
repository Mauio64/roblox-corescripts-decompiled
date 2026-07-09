local ExpChatShared = script:FindFirstAncestor("ExpChatShared")
local ExpChatSharedParent = ExpChatShared.Parent
local Rodux = require(ExpChatSharedParent.Rodux)
local Dictionary = require(ExpChatSharedParent.llama).Dictionary
local Actions = ExpChatShared.Actions
local PlayerAdded = require(Actions.PlayerAdded)
local PlayerRemoved = require(Actions.PlayerRemoved)

return Rodux.createReducer({}, {
	[PlayerAdded.name] = function(t1: {[any]: any}, p1) -- line: 19
		-- upvalues: Dictionary (copy)
		return Dictionary.join(t1, {
			[p1.userId] = {
				userId = p1.userId,
				username = p1.username,
				displayName = p1.displayName
			}
		})
	end,
	[PlayerRemoved.name] = function(t2: {[any]: any}, p2) -- line: 29
		-- upvalues: Dictionary (copy)
		return Dictionary.removeKey(t2, p2.userId)
	end
})
