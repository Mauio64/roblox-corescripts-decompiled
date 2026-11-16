local event = require(script.Parent.event)

local actions = script:FindFirstAncestor("ExpChat").Actions
local VoiceEnabledChanged = require(actions.VoiceEnabledChanged)

return event(VoiceEnabledChanged)
