local event = require(script.Parent.event)

local actions = script:FindFirstAncestor("ExpChat").Actions
local ChatTopBarButtonActivated = require(actions.ChatTopBarButtonActivated)

return event(ChatTopBarButtonActivated)
