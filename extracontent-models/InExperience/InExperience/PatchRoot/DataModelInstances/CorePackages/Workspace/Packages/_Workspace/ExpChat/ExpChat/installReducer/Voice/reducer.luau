local parent = script:FindFirstAncestor("ExpChat").Parent
local Rodux = require(parent.Rodux)
local SharedFlags = require(parent.SharedFlags)

local GetFFlagExpChatUseVoiceParticipantsStore = SharedFlags.GetFFlagExpChatUseVoiceParticipantsStore

local defineFastFlag = game:DefineFastFlag("EasierUnmutingVoiceParticipantsMutedReducer", false)

local combineReducers = Rodux.combineReducers
local participants

if not GetFFlagExpChatUseVoiceParticipantsStore() then
	participants = require(script.Parent.participants)
end

local participantsMuted

if defineFastFlag then
	participantsMuted = require(script.Parent.participantsMuted)
else
	participantsMuted = Rodux.createReducer({}, {})
end

return combineReducers({
	participants = participants,
	participantsMuted = participantsMuted,
	isEnabled = require(script.Parent.isEnabled),
	isVoiceUIVisible = require(script.Parent.isVoiceUIVisible)
})
