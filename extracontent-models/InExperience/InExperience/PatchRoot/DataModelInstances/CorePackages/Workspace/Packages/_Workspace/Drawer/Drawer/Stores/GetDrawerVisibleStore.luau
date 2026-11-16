local parent = script:FindFirstAncestor("Drawer").Parent
local Signals = require(parent.Signals)
local createDrawerVisibleStore = require(script.createDrawerVisibleStore)

return Signals.createComputed(createDrawerVisibleStore)
