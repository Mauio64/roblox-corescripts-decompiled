local event = require(script.Parent.event)

local actions = script:FindFirstAncestor("ExpChat").Actions
local VoiceParticipantToggleMuted = require(actions.VoiceParticipantToggleMuted)

return event(VoiceParticipantToggleMuted)
