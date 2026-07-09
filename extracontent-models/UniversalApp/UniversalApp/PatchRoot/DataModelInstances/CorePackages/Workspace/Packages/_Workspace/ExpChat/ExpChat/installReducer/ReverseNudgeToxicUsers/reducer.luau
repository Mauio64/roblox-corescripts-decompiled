local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Rodux = require(ExpChatParent.Rodux)
local Dictionary = require(ExpChatParent.llama).Dictionary
local Actions = ExpChat.Actions
local AddReverseNudgeToxicUser = require(Actions.AddReverseNudgeToxicUser)
local RemoveReverseNudgeToxicUser = require(Actions.RemoveReverseNudgeToxicUser)

return Rodux.createReducer({}, {
	[AddReverseNudgeToxicUser.name] = function(t1: {[any]: any}, p1) -- line: 16
		-- upvalues: Dictionary (copy)
		return Dictionary.join(t1, {
			[p1.toxicUserId] = p1.reverseNudgeType
		})
	end,
	[RemoveReverseNudgeToxicUser.name] = function(t2: {[any]: any}, p2) -- line: 20
		-- upvalues: Dictionary (copy)
		return Dictionary.removeKey(t2, p2.toxicUserId)
	end
})
