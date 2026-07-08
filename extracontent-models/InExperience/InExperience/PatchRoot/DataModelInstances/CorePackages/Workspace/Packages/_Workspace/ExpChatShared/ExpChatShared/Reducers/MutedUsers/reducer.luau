local ExpChatShared = script:FindFirstAncestor("ExpChatShared")
local ExpChatSharedParent = ExpChatShared.Parent
local Rodux = require(ExpChatSharedParent.Rodux)
local Set = require(ExpChatSharedParent.llama).Set
local Actions = ExpChatShared.Actions
local UserMuted = require(Actions.UserMuted)
local UserUnmuted = require(Actions.UserUnmuted)

return Rodux.createReducer({}, {
	[UserMuted.name] = function(t1: {[any]: any}, p1) -- line: 16
		-- upvalues: Set (copy)
		return Set.add(t1, p1.userId)
	end,
	[UserUnmuted.name] = function(t2: {[any]: any}, p2) -- line: 20
		-- upvalues: Set (copy)
		return Set.subtract(t2, p2.userId)
	end
})
