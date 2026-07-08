local event = require(script.Parent.event)
local Actions = script:FindFirstAncestor("ExpChat").Actions

return event((require(Actions.ChatTopBarFocusActivated)))
