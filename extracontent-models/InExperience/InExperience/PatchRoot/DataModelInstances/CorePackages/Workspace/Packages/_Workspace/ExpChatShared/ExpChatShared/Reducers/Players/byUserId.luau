local ExpChatShared = script:FindFirstAncestor("ExpChatShared")
local parent = ExpChatShared.Parent
local Rodux = require(parent.Rodux)
local llama = require(parent.llama)
local dictionary = llama.Dictionary

local Actions = ExpChatShared.Actions
local PlayerAdded = require(Actions.PlayerAdded)
local PlayerRemoved = require(Actions.PlayerRemoved)

return Rodux.createReducer({}, {
	[PlayerAdded.name] = function(p, data)
		return dictionary.join(p, {
			[data.userId] = {
				userId = data.userId,
				username = data.username,
				displayName = data.displayName
			}
		})
	end,
	[PlayerRemoved.name] = function(p, p2)
		return dictionary.removeKey(p, p2.userId)
	end
})
