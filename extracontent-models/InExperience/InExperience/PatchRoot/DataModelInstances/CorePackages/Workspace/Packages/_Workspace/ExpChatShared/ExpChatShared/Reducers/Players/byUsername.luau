local ExpChatShared = script:FindFirstAncestor("ExpChatShared")
local parent = ExpChatShared.Parent
local Rodux = require(parent.Rodux)
local llama = require(parent.llama)
local dictionary = llama.Dictionary

local Actions = ExpChatShared.Actions
local PlayerAdded = require(Actions.PlayerAdded)
local PlayerRemoved = require(Actions.PlayerRemoved)

return Rodux.createReducer({}, {
	[PlayerAdded.name] = function(p, p2)
		local username = string.lower(p2.username)
		return dictionary.join(p, { [username] = p2.userId })
	end,
	[PlayerRemoved.name] = function(p, p2)
		return dictionary.filter(p, function(p3): boolean
			return p3 ~= p2.userId
		end)
	end
})
