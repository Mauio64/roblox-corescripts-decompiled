local ExpChatShared = script:FindFirstAncestor("ExpChatShared")
local ExpChatSharedParent = ExpChatShared.Parent
local Rodux = require(ExpChatSharedParent.Rodux)
local Dictionary = require(ExpChatSharedParent.llama).Dictionary
local Actions = ExpChatShared.Actions
local PlayerAdded = require(Actions.PlayerAdded)
local PlayerRemoved = require(Actions.PlayerRemoved)

return Rodux.createReducer({}, {
	[PlayerAdded.name] = function(t1: {[any]: any}, p1) -- line: 15
		-- upvalues: Dictionary (copy)
		local v10 = string.lower(p1.username)

		return Dictionary.join(t1, {
			[v10] = p1.userId
		})
	end,
	[PlayerRemoved.name] = function(t2: {[any]: any}, p2) -- line: 22
		-- upvalues: Dictionary (copy)
		return Dictionary.filter(t2, function(p3) -- line: 23
			-- upvalues: p2 (copy)
			return p3 ~= p2.userId
		end)
	end
})
