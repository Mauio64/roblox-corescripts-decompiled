local parent = script:FindFirstAncestor("ExpChat").Parent
local Rodux = require(parent.Rodux)
local llama = require(parent.llama)
local dictionary = llama.Dictionary
local ExpChatShared = require(parent.ExpChatShared)

local Actions = ExpChatShared.Actions
local PlayerAdded = Actions.PlayerAdded
local PlayerRemoved = Actions.PlayerRemoved

return Rodux.createReducer({}, {
	[PlayerAdded.name] = function(p, p2)
		if not p2.hasVerifiedBadge then
			return p
		end

		return dictionary.join(p, { [p2.userId] = p2.hasVerifiedBadge })
	end,
	[PlayerRemoved.name] = function(p, p2)
		if p[p2.userId] == nil then
			return p
		end

		return dictionary.removeKey(p, p2.userId)
	end
})
