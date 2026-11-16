local event = require(script.Parent.event)

local actions = script:FindFirstAncestor("ExpChat").Actions
local ChatTimeoutUpdated = require(actions.ChatTimeoutUpdated)

return event(ChatTimeoutUpdated)
