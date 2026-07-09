local ExpChatShared = script:FindFirstAncestor("ExpChatShared")
local ExpChatSharedParent = ExpChatShared.Parent
local Rodux = require(ExpChatSharedParent.Rodux)
local Dictionary = require(ExpChatSharedParent.llama).Dictionary
local List = require(ExpChatSharedParent.llama).List
local Actions = ExpChatShared.Actions
local PlayerAdded = require(Actions.PlayerAdded)
local PlayerRemoved = require(Actions.PlayerRemoved)

return Rodux.createReducer({}, {
	[PlayerAdded.name] = function(t1: {[any]: any}, p1) -- line: 16
		-- upvalues: Dictionary (copy), List (copy)
		local v11 = string.lower(p1.displayName)

		return Dictionary.join(t1, {
			[v11] = List.append(t1[v11] or {}, p1.userId)
		})
	end,
	[PlayerRemoved.name] = function(t2: {[any]: any}, p2) -- line: 23
		-- upvalues: Dictionary (copy), List (copy)
		return Dictionary.map(t2, function(p3) -- line: 24
			-- upvalues: List (copy), p2 (copy)
			return List.removeValue(p3, p2.userId)
		end)
	end
})
