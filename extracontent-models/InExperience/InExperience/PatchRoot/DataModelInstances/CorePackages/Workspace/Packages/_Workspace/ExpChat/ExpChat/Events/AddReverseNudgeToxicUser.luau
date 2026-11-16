local event = require(script.Parent.event)

local actions = script:FindFirstAncestor("ExpChat").Actions
local AddReverseNudgeToxicUser = require(actions.AddReverseNudgeToxicUser)

return event(AddReverseNudgeToxicUser)
