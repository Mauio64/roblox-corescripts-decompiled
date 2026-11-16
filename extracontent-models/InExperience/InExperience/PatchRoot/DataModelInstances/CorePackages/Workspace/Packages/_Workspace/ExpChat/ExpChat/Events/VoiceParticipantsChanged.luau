local event = require(script.Parent.event)

local actions = script:FindFirstAncestor("ExpChat").Actions
local VoiceParticipantsChanged = require(actions.VoiceParticipantsChanged)

return event(VoiceParticipantsChanged)
