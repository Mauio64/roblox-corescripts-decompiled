local parent = script:FindFirstAncestor("SwitchServer").Parent

local Signals = require(parent.Signals)
local createSwitchServerStore = require(script.createSwitchServerStore)

return Signals.createComputed(createSwitchServerStore)
