local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local Rodux = require(parent.Rodux)
local llama = require(parent.llama)
local dictionary = llama.Dictionary

local Actions = ExpChat.Actions
local AddReverseNudgeToxicUser = require(Actions.AddReverseNudgeToxicUser)
local RemoveReverseNudgeToxicUser = require(Actions.RemoveReverseNudgeToxicUser)

return Rodux.createReducer({}, {
	[AddReverseNudgeToxicUser.name] = function(p, p2)
		return dictionary.join(p, { [p2.toxicUserId] = p2.reverseNudgeType })
	end,
	[RemoveReverseNudgeToxicUser.name] = function(p, p2)
		return dictionary.removeKey(p, p2.toxicUserId)
	end
})
