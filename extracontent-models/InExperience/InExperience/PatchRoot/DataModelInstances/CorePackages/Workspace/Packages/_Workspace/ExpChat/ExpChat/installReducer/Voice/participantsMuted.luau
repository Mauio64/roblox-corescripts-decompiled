local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Dictionary = require(ExpChatParent.llama).Dictionary
local None = require(ExpChatParent.llama).None
local Rodux = require(ExpChatParent.Rodux)
local Actions = ExpChat.Actions
local VoiceParticipantToggleMuted = require(Actions.VoiceParticipantToggleMuted)
local VoiceParticipantAdded = require(Actions.VoiceParticipantAdded)
local VoiceParticipantRemoved = require(Actions.VoiceParticipantRemoved)

return Rodux.createReducer({}, {
	[VoiceParticipantAdded.name] = function(t1: {[any]: any}, p1) -- line: 19
		-- upvalues: Dictionary (copy)
		local userId = p1.userId
		local v13 = t1[userId] or false

		return Dictionary.set(t1, userId, v13)
	end,
	[VoiceParticipantRemoved.name] = function(t2: {[any]: any}, p2) -- line: 27
		-- upvalues: Dictionary (copy), None (copy)
		return Dictionary.set(t2, p2.userId, None)
	end,
	[VoiceParticipantToggleMuted.name] = function(t3: {[any]: any}, p3) -- line: 32
		-- upvalues: Dictionary (copy)
		if t3[p3.userId] ~= nil then
			return Dictionary.join(t3, {
				[p3.userId] = p3.isMuted
			})
		end

		return t3
	end
})
