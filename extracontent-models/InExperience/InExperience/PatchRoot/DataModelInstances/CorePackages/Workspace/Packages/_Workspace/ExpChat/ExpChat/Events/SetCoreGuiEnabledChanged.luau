local event = require(script.Parent.event)

local actions = script:FindFirstAncestor("ExpChat").Actions
local SetCoreGuiEnabledChanged = require(actions.SetCoreGuiEnabledChanged)

return event(SetCoreGuiEnabledChanged)
