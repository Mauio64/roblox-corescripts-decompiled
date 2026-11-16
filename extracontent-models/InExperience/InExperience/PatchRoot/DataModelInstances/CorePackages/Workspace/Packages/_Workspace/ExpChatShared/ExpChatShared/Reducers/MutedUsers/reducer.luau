local ExpChatShared = script:FindFirstAncestor("ExpChatShared")
local parent = ExpChatShared.Parent
local Rodux = require(parent.Rodux)
local llama = require(parent.llama)
local set = llama.Set

local Actions = ExpChatShared.Actions
local UserMuted = require(Actions.UserMuted)
local UserUnmuted = require(Actions.UserUnmuted)

return Rodux.createReducer({}, {
	[UserMuted.name] = function(p, p2)
		return set.add(p, p2.userId)
	end,
	[UserUnmuted.name] = function(p, p2)
		return set.subtract(p, p2.userId)
	end
})
