local event = require(script.Parent.event)

local actions = script:FindFirstAncestor("ExpChat").Actions
local ChatTopBarFocusSelect = require(actions.ChatTopBarFocusSelect)

return event(ChatTopBarFocusSelect)
