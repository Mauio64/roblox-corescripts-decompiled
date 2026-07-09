local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Dictionary = require(ExpChatParent.llama).Dictionary
local None = require(ExpChatParent.llama).None
local Rodux = require(ExpChatParent.Rodux)
local VOICE_STATE = require(ExpChatParent.VoiceChat).Constants.VOICE_STATE
local Actions = ExpChat.Actions
local VoiceParticipantAdded = require(Actions.VoiceParticipantAdded)
local VoiceParticipantRemoved = require(Actions.VoiceParticipantRemoved)
local VoiceStateChanged = require(Actions.VoiceStateChanged)
local VoiceParticipantsChanged = require(Actions.VoiceParticipantsChanged)

return Rodux.createReducer({}, {
	[VoiceParticipantAdded.name] = function(t1: {[any]: any}, p1) -- line: 22
		-- upvalues: Dictionary (copy)
		local userId = p1.userId
		local v15 = t1[userId] or "Hidden"

		return Dictionary.join(t1, {
			[userId] = v15
		})
	end,
	[VoiceParticipantRemoved.name] = function(t2: {[any]: any}, p2) -- line: 32
		-- upvalues: Dictionary (copy), None (copy)
		return Dictionary.join(t2, {
			[p2.userId] = None
		})
	end,
	[VoiceParticipantsChanged.name] = function(p3, p4) -- line: 39
		-- upvalues: VOICE_STATE (copy)
		local newParticipants = p4.newParticipants
		local v21 = table.clone(p3)

		for v22, v23 in newParticipants do
			local INACTIVE = VOICE_STATE.INACTIVE

			if not v23.subscriptionCompleted then
				INACTIVE = VOICE_STATE.CONNECTING
			elseif v23.isMutedLocally then
				INACTIVE = VOICE_STATE.LOCAL_MUTED
			elseif v23.isMuted then
				INACTIVE = VOICE_STATE.MUTED
			elseif v23.isSignalActive then
				INACTIVE = VOICE_STATE.TALKING
			end

			v21[tostring(v22)] = INACTIVE
		end

		return v21
	end,
	[VoiceStateChanged.name] = function(t3: {[any]: any}, p5) -- line: 59
		-- upvalues: Dictionary (copy)
		if t3[p5.userId] then
			return Dictionary.join(t3, {
				[p5.userId] = p5.newState
			})
		end

		return t3
	end
})
