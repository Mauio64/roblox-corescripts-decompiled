local Parent = script:FindFirstAncestor("ExpChat").Parent
local Rodux = require(Parent.Rodux)
local GetFFlagExpChatUseVoiceParticipantsStore = require(Parent.SharedFlags).GetFFlagExpChatUseVoiceParticipantsStore
local v4 = game:DefineFastFlag("EasierUnmutingVoiceParticipantsMutedReducer", false)

return Rodux.combineReducers({
	participants = if not GetFFlagExpChatUseVoiceParticipantsStore() then require(script.Parent.participants) else nil,
	participantsMuted = if not v4 then Rodux.createReducer({}, {}) else require(script.Parent.participantsMuted),
	isEnabled = require(script.Parent.isEnabled),
	isVoiceUIVisible = require(script.Parent.isVoiceUIVisible)
})
