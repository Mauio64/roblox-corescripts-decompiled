local parent = script:FindFirstAncestor("AppShortcutBarStore").Parent

local Signals = require(parent.Signals)
local createShortcutBarStatusStore = require(script.createShortcutBarStatusStore)

return Signals.createComputed(createShortcutBarStatusStore)
