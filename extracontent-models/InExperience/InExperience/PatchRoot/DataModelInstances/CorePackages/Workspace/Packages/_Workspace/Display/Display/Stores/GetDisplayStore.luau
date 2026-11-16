local parent = script.Parent.Parent.Parent
local Signals = require(parent.Signals)
local createDisplayStore = require(script.createDisplayStore)

return Signals.createComputed(createDisplayStore)
