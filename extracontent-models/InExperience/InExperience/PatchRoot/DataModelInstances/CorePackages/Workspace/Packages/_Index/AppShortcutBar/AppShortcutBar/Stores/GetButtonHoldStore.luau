local parent = script:FindFirstAncestor("AppShortcutBar").Parent

local Signals = require(parent.Signals)
local createButtonHoldStore = require(script.createButtonHoldStore)

return Signals.createComputed(createButtonHoldStore)
