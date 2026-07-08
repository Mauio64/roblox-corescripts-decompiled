local Parent = script:FindFirstAncestor("Drawer").Parent
local Signals = require(Parent.Signals)
local createDrawerVisibleStore = require(script.createDrawerVisibleStore)

return Signals.createComputed(createDrawerVisibleStore)
