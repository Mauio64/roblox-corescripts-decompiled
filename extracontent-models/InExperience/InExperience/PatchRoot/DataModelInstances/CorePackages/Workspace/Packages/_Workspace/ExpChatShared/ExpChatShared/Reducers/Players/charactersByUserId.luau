local ExpChatShared = script:FindFirstAncestor("ExpChatShared")
local parent = ExpChatShared.Parent
local Rodux = require(parent.Rodux)
local llama = require(parent.llama)
local dictionary = llama.Dictionary

local Actions = ExpChatShared.Actions
local CharacterAdded = require(Actions.CharacterAdded)
local PlayerRemoved = require(Actions.PlayerRemoved)

return Rodux.createReducer({}, {
	[CharacterAdded.name] = function(p, p2)
		return dictionary.join(p, { [p2.userId] = p2.character })
	end,
	[PlayerRemoved.name] = function(p, p2)
		return dictionary.removeKey(p, p2.userId)
	end
})
