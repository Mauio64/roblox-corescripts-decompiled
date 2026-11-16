local event = require(script.Parent.event)

local actions = script:FindFirstAncestor("ExpChat").Actions
local RemoveReverseNudgeToxicUser = require(actions.RemoveReverseNudgeToxicUser)

return event(RemoveReverseNudgeToxicUser)
