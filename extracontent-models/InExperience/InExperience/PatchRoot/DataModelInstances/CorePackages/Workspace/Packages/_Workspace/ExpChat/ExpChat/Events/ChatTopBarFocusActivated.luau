local event = require(script.Parent.event)

local actions = script:FindFirstAncestor("ExpChat").Actions
local ChatTopBarFocusActivated = require(actions.ChatTopBarFocusActivated)

return event(ChatTopBarFocusActivated)
