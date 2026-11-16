local event = require(script.Parent.event)

local actions = script:FindFirstAncestor("ExpChat").Actions
local VoiceParticipantAdded = require(actions.VoiceParticipantAdded)

return event(VoiceParticipantAdded)
