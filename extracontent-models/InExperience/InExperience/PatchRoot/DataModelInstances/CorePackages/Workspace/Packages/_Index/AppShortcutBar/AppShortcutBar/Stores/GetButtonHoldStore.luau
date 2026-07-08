local Parent = script:FindFirstAncestor("AppShortcutBar").Parent
local Signals = require(Parent.Signals)
local createButtonHoldStore = require(script.createButtonHoldStore)

return Signals.createComputed(createButtonHoldStore)
