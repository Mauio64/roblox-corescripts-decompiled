local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local llama = require(parent.llama)
local dictionary = llama.Dictionary
local llama2 = require(parent.llama)
local none = llama2.None
local Rodux = require(parent.Rodux)

local Actions = ExpChat.Actions
local VoiceParticipantToggleMuted = require(Actions.VoiceParticipantToggleMuted)
local VoiceParticipantAdded = require(Actions.VoiceParticipantAdded)
local VoiceParticipantRemoved = require(Actions.VoiceParticipantRemoved)

return Rodux.createReducer({}, {
	[VoiceParticipantAdded.name] = function(p, p2)
		local userId = p2.userId
		local v = p[userId] or false

		return dictionary.set(p, userId, v)
	end,
	[VoiceParticipantRemoved.name] = function(p, p2)
		return dictionary.set(p, p2.userId, none)
	end,
	[VoiceParticipantToggleMuted.name] = function(p, p2)
		if p[p2.userId] == nil then
			return p
		end

		return dictionary.join(p, { [p2.userId] = p2.isMuted })
	end
})
