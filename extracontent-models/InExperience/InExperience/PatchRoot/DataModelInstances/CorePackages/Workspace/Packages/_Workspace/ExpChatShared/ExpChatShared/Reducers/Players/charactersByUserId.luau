local ExpChatShared = script:FindFirstAncestor("ExpChatShared")
local ExpChatSharedParent = ExpChatShared.Parent
local Rodux = require(ExpChatSharedParent.Rodux)
local Dictionary = require(ExpChatSharedParent.llama).Dictionary
local Actions = ExpChatShared.Actions
local CharacterAdded = require(Actions.CharacterAdded)
local PlayerRemoved = require(Actions.PlayerRemoved)

return Rodux.createReducer({}, {
	[CharacterAdded.name] = function(t1: {[any]: any}, p1) -- line: 15
		-- upvalues: Dictionary (copy)
		return Dictionary.join(t1, {
			[p1.userId] = p1.character
		})
	end,
	[PlayerRemoved.name] = function(t2: {[any]: any}, p2) -- line: 21
		-- upvalues: Dictionary (copy)
		return Dictionary.removeKey(t2, p2.userId)
	end
})
