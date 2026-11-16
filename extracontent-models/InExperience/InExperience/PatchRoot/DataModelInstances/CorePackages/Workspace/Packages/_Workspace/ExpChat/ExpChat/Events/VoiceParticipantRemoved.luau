local event = require(script.Parent.event)

local actions = script:FindFirstAncestor("ExpChat").Actions
local VoiceParticipantRemoved = require(actions.VoiceParticipantRemoved)

return event(VoiceParticipantRemoved)
