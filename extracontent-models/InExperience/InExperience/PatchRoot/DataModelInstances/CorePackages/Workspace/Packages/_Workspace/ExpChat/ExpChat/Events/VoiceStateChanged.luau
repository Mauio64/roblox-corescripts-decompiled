local event = require(script.Parent.event)

local actions = script:FindFirstAncestor("ExpChat").Actions
local VoiceStateChanged = require(actions.VoiceStateChanged)

return event(VoiceStateChanged)
