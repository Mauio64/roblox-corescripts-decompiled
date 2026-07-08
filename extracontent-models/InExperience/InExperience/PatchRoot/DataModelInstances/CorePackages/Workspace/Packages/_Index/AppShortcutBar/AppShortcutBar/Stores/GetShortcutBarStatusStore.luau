local Parent = script:FindFirstAncestor("AppShortcutBar").Parent
local Signals = require(Parent.Signals)
local createShortcutBarStatusStore = require(script.createShortcutBarStatusStore)

return Signals.createComputed(createShortcutBarStatusStore)
