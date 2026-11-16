local event = require(script.Parent.event)

local actions = script:FindFirstAncestor("ExpChat").Actions
local VoiceUIVisibilityChanged = require(actions.VoiceUIVisibilityChanged)

return event(VoiceUIVisibilityChanged)
