local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local llama = require(parent.llama)
local dictionary = llama.Dictionary
local llama2 = require(parent.llama)
local none = llama2.None
local Rodux = require(parent.Rodux)

local VoiceChat = require(parent.VoiceChat)
local VOICE_STATE = VoiceChat.Constants.VOICE_STATE
local Actions = ExpChat.Actions
local VoiceParticipantAdded = require(Actions.VoiceParticipantAdded)
local VoiceParticipantRemoved = require(Actions.VoiceParticipantRemoved)
local VoiceStateChanged = require(Actions.VoiceStateChanged)
local VoiceParticipantsChanged = require(Actions.VoiceParticipantsChanged)

return Rodux.createReducer({}, {
	[VoiceParticipantAdded.name] = function(p, p2)
		local userId = p2.userId
		local v = p[userId] or "Hidden"

		return dictionary.join(p, { [userId] = v })
	end,
	[VoiceParticipantRemoved.name] = function(p, p2)
		return dictionary.join(p, { [p2.userId] = none })
	end,
	[VoiceParticipantsChanged.name] = function(p, p2)
		local newParticipants = p2.newParticipants
		local clone = table.clone(p)

		for k, newParticipant in newParticipants do
			local v = VOICE_STATE.INACTIVE

			if newParticipant.subscriptionCompleted then
				if newParticipant.isMutedLocally then
					v = VOICE_STATE.LOCAL_MUTED
				elseif newParticipant.isMuted then
					v = VOICE_STATE.MUTED
				elseif newParticipant.isSignalActive then
					v = VOICE_STATE.TALKING
				end
			else
				v = VOICE_STATE.CONNECTING
			end

			clone[tostring(k)] = v
		end

		return clone
	end,
	[VoiceStateChanged.name] = function(p, p2)
		if not p[p2.userId] then
			return p
		end

		return dictionary.join(p, { [p2.userId] = p2.newState })
	end
})
