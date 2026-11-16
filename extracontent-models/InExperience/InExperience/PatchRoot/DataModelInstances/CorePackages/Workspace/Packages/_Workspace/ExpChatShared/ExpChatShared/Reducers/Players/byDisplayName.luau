local ExpChatShared = script:FindFirstAncestor("ExpChatShared")
local parent = ExpChatShared.Parent
local Rodux = require(parent.Rodux)
local llama = require(parent.llama)
local dictionary = llama.Dictionary
local llama2 = require(parent.llama)
local list = llama2.List

local Actions = ExpChatShared.Actions
local PlayerAdded = require(Actions.PlayerAdded)
local PlayerRemoved = require(Actions.PlayerRemoved)

return Rodux.createReducer({}, {
	[PlayerAdded.name] = function(p, p2)
		local displayName = string.lower(p2.displayName)
		return dictionary.join(p, {
			[displayName] = list.append(p[displayName] or {}, p2.userId)
		})
	end,
	[PlayerRemoved.name] = function(p, p2)
		return dictionary.map(p, function(p3)
			return list.removeValue(p3, p2.userId)
		end)
	end
})
